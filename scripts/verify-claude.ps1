[CmdletBinding()]
param()

# Expected Claude agents per plugin (includes poteto-agent alias; comment-sicko uses name "Comment Sicko").
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$plugins = @{
    'cursor-team-kit' = @('ci-watcher')
    'pstack' = @('coding-agent', 'review-agent', 'poteto-mode', 'poteto-agent', 'comment-sicko')
    'thermos' = @('thermo-nuclear-code-quality-review-subagent', 'thermo-nuclear-review-subagent')
}
$errors = [System.Collections.Generic.List[string]]::new()

function Get-Frontmatter {
    param([string] $Path)

    $lines = Get-Content -LiteralPath $Path
    if ($lines.Count -lt 3 -or $lines[0] -ne '---') {
        $errors.Add("$Path is missing opening Claude agent frontmatter")
        return @{}
    }

    $end = [Array]::IndexOf($lines, '---', 1)
    if ($end -lt 0) {
        $errors.Add("$Path is missing closing Claude agent frontmatter")
        return @{}
    }

    $values = @{}
    foreach ($line in $lines[1..($end - 1)]) {
        if ($line -match '^([A-Za-z][A-Za-z0-9_-]*):\s*(.+)$') {
            $values[$Matches[1]] = $Matches[2].Trim()
        }
    }
    return $values
}

foreach ($plugin in $plugins.Keys) {
    $pluginRoot = Join-Path $repositoryRoot $plugin
    $manifestPath = Join-Path $pluginRoot '.claude-plugin/plugin.json'
    $skillsRoot = Join-Path $pluginRoot 'skills'
    $agentsRoot = Join-Path $pluginRoot 'agents'

    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        $errors.Add("$plugin is missing .claude-plugin/plugin.json")
        continue
    }

    if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
        $errors.Add("$plugin is missing skills/")
        continue
    }

    foreach ($skillFile in Get-ChildItem -LiteralPath $skillsRoot -Recurse -Filter SKILL.md -File) {
        $frontmatter = Get-Frontmatter -Path $skillFile.FullName
        $name = $frontmatter['name']
        $description = $frontmatter['description']

        if ($name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
            $errors.Add("$($skillFile.FullName) has an invalid skill name")
        }
        if ($name -ne $skillFile.Directory.Name) {
            $errors.Add("$($skillFile.FullName) has a name that does not match its directory")
        }
        if ([string]::IsNullOrWhiteSpace($description)) {
            $errors.Add("$($skillFile.FullName) has no description")
        }
    }

    if (-not (Test-Path -LiteralPath $agentsRoot -PathType Container)) {
        $errors.Add("$plugin is missing agents/")
        continue
    }

    $agentFiles = @(Get-ChildItem -LiteralPath $agentsRoot -Filter *.md -File)
    $agentNames = @($agentFiles.BaseName)
    foreach ($requiredAgent in $plugins[$plugin]) {
        if ($agentNames -notcontains $requiredAgent) {
            $errors.Add("$plugin is missing Claude agent $requiredAgent")
        }
    }

    foreach ($agentFile in $agentFiles) {
        $frontmatter = Get-Frontmatter -Path $agentFile.FullName
        $name = $frontmatter['name']
        $description = $frontmatter['description']

        if ([string]::IsNullOrWhiteSpace($name)) {
            $errors.Add("$($agentFile.FullName) has no Claude agent name")
        }
        if ($name -ne $agentFile.BaseName -and $name -match '^[a-z0-9]+(-[a-z0-9]+)*$') {
            $errors.Add("$($agentFile.FullName) has a name that does not match its file")
        }
        if ([string]::IsNullOrWhiteSpace($description)) {
            $errors.Add("$($agentFile.FullName) has no Claude agent description")
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validated Claude Code skill and agent assets for $($plugins.Keys -join ', ')."
