[CmdletBinding()]
param()

# Expected OpenCode agents per plugin, including legacy compatibility targets.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$plugins = @{
    'cursor-team-kit' = @('ci-watcher')
    'pstack' = @('poteto-mode', 'poteto-agent', 'poteto-research', 'poteto-worker', 'poteto-expert', 'comment-sicko')
    'thermos' = @('thermo-nuclear-code-quality-review-subagent', 'thermo-nuclear-review-subagent')
    'opencode-workflow' = @(
        'code',
        'review',
        'rigor',
        'compatibility-scan-review',
        'startup-review',
        'validation-review',
        'docs-reliability-review',
        'agents-memory-updater'
    )
}
$errors = [System.Collections.Generic.List[string]]::new()

function Get-Frontmatter {
    param([string] $Path)

    $lines = Get-Content -LiteralPath $Path
    if ($lines.Count -lt 3 -or $lines[0] -ne '---') {
        $errors.Add("$Path is missing opening OpenCode frontmatter")
        return @{}
    }

    $end = [Array]::IndexOf($lines, '---', 1)
    if ($end -lt 0) {
        $errors.Add("$Path is missing closing OpenCode frontmatter")
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
    $skillsRoot = Join-Path $pluginRoot 'skills'
    $agentsRoot = Join-Path $pluginRoot 'opencode/agent'


    if (-not (Test-Path -LiteralPath $skillsRoot -PathType Container)) {
        $errors.Add("$plugin is missing skills/")
        continue
    }

    foreach ($skillFile in Get-ChildItem -LiteralPath $skillsRoot -Recurse -Filter SKILL.md -File) {
        $frontmatter = Get-Frontmatter -Path $skillFile.FullName
        $name = $frontmatter['name']
        $description = $frontmatter['description']

        if ($name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
            $errors.Add("$($skillFile.FullName) has an invalid OpenCode skill name")
        }
        if ($name -ne $skillFile.Directory.Name) {
            $errors.Add("$($skillFile.FullName) has a name that does not match its directory")
        }
        if ([string]::IsNullOrWhiteSpace($description)) {
            $errors.Add("$($skillFile.FullName) has no description")
        }
    }

    if (Test-Path -LiteralPath $agentsRoot -PathType Container) {
        $agentFiles = @(Get-ChildItem -LiteralPath $agentsRoot -Filter *.md -File)
        $agentNames = @($agentFiles.BaseName)
        foreach ($requiredAgent in $plugins[$plugin]) {
            if ($agentNames -notcontains $requiredAgent) {
                $errors.Add("$plugin is missing OpenCode agent $requiredAgent")
            }
        }

        foreach ($agentFile in $agentFiles) {
            $frontmatter = Get-Frontmatter -Path $agentFile.FullName
            if ([string]::IsNullOrWhiteSpace($frontmatter['description'])) {
                $errors.Add("$($agentFile.FullName) has no OpenCode agent description")
            }
            if ($frontmatter['mode'] -notin @('subagent', 'primary', 'all')) {
                $errors.Add("$($agentFile.FullName) has no OpenCode agent mode")
            }
        }
    } elseif ($plugins[$plugin].Count -gt 0) {
        $errors.Add("$plugin is missing opencode/agent/")
    }

    $commandsRoot = Join-Path $pluginRoot 'opencode/command'
    if (Test-Path -LiteralPath $commandsRoot -PathType Container) {
        foreach ($commandFile in Get-ChildItem -LiteralPath $commandsRoot -Filter *.md -File) {
            $frontmatter = Get-Frontmatter -Path $commandFile.FullName
            if ([string]::IsNullOrWhiteSpace($frontmatter['description'])) {
                $errors.Add("$($commandFile.FullName) has no OpenCode command description")
            }
        }
    }
}

$workflowRoot = Join-Path $repositoryRoot 'opencode-workflow'
if (-not (Test-Path -LiteralPath (Join-Path $workflowRoot 'WORKFLOW.md') -PathType Leaf)) {
    $errors.Add('opencode-workflow is missing WORKFLOW.md')
}
if (-not (Test-Path -LiteralPath (Join-Path $workflowRoot 'opencode.json.template') -PathType Leaf)) {
    $errors.Add('opencode-workflow is missing opencode.json.template')
} else {
    try {
        Get-Content -LiteralPath (Join-Path $workflowRoot 'opencode.json.template') -Raw | ConvertFrom-Json | Out-Null
    } catch {
        $errors.Add("opencode-workflow opencode.json.template is not valid JSON: $_")
    }
}

$documentationCheck = Join-Path $PSScriptRoot 'check-opencode-docs.ps1'
if (-not (Test-Path -LiteralPath $documentationCheck -PathType Leaf)) {
    $errors.Add('scripts is missing check-opencode-docs.ps1')
} else {
    & $documentationCheck -RepositoryRoot $repositoryRoot
    if (-not $?) {
        $errors.Add('OpenCode documentation check failed')
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Validated OpenCode skill and agent assets for $($plugins.Keys -join ', ')."
