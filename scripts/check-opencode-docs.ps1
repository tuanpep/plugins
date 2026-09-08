param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$plugins = @('cursor-team-kit', 'opencode-workflow', 'pstack', 'thermos')
$supportedFiles = @(
    'README.md',
    'cursor-team-kit/README.md',
    'opencode-workflow/README.md',
    'pstack/README.md',
    'thermos/README.md'
) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'pstack/docs') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + ($plugins | ForEach-Object {
    $plugin = $_
    @('skills', 'opencode') | ForEach-Object {
        $sourceRoot = Join-Path $RepositoryRoot "$plugin/$_"
        if (Test-Path -LiteralPath $sourceRoot -PathType Container) {
            Get-ChildItem -Path $sourceRoot -Filter '*.md' -Recurse | ForEach-Object {
                $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
            }
        }
    }
}) | Sort-Object -Unique

$legacyHostPatterns = @(
    '(?i)\bClaude Code\b',
    '(?i)\bclaude\s+mcp\s+list\b',
    '(?i)(?:~|\$HOME)?/\.claude(?:/|\\)',
    '(?i)\b(?:install|verify)-claude\b',
    '(?i)\bquick-install-all-plugins\b'
)

$deletedAssets = @(
    '.claude-plugin/marketplace.json',
    'cursor-team-kit/.claude-plugin/plugin.json',
    'opencode-workflow/.claude-plugin/plugin.json',
    'pstack/.claude-plugin/plugin.json',
    'thermos/.claude-plugin/plugin.json',
    'scripts/install-claude.ps1',
    'scripts/install-claude.sh',
    'scripts/verify-claude.ps1',
    'scripts/verify-claude.sh',
    'cursor-team-kit/agents/ci-watcher.md',
    'pstack/agents/coding-agent.md',
    'pstack/agents/review-agent.md',
    'pstack/agents/poteto-mode.md',
    'pstack/agents/poteto-agent.md',
    'pstack/agents/comment-sicko.md',
    'thermos/agents/thermo-nuclear-code-quality-review-subagent.md',
    'thermos/agents/thermo-nuclear-review-subagent.md'
)

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($relativePath in $deletedAssets) {
    if (Test-Path -LiteralPath (Join-Path $RepositoryRoot $relativePath)) {
        $failures.Add("Deleted Claude support asset is present: $relativePath")
    }
}

foreach ($relativePath in $supportedFiles) {
    $path = Join-Path $RepositoryRoot $relativePath
    $content = Get-Content -LiteralPath $path -Raw

    foreach ($pattern in $legacyHostPatterns) {
        if ($content -match $pattern) {
            $failures.Add("Actionable legacy-host reference in $relativePath matches '$pattern'.")
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output "CHECK: deleted Claude support assets are absent ($($deletedAssets.Count) paths)."
Write-Output "CHECK: supported OpenCode files contain no actionable legacy-host references ($($supportedFiles.Count) files)."
