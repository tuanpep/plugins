param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

$files = @(
    'README.md',
    'cursor-team-kit/README.md',
    'opencode-workflow/README.md',
    'pstack/README.md',
    'thermos/README.md'
) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'pstack/docs/guide') -Filter '*.md' | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'pstack/skills') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'opencode-workflow/skills') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'pstack/opencode') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'opencode-workflow/opencode') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
}) + (Get-ChildItem -Path (Join-Path $RepositoryRoot 'thermos/opencode') -Filter '*.md' -Recurse | ForEach-Object {
    $_.FullName.Substring($RepositoryRoot.Length + 1).Replace('\', '/')
})

$forbidden = @(
    '(?i)\bClaude Code\b',
    '(?i)\bclaude\s+mcp\s+list\b',
    '(?i)(?:~|\$HOME)?/\.claude(?:/|\\)',
    '(?i)\b(?:install|verify)-claude\b',
    '(?i)\bquick-install-all-plugins\b'
)

$failures = foreach ($relativePath in $files) {
    $path = Join-Path $RepositoryRoot $relativePath
    $content = Get-Content -LiteralPath $path -Raw

    foreach ($pattern in $forbidden) {
        if ($content -match $pattern) {
            "$relativePath contains '$pattern'."
        }
    }
}

if ($failures) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output "OpenCode documentation check passed for $($files.Count) files."
