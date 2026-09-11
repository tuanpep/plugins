[CmdletBinding()]
param(
    [string] $Destination = (Join-Path $HOME '.config/opencode')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$pluginNames = @('cursor-team-kit', 'pstack', 'thermos', 'opencode-workflow')
$mappings = @(
    @{ Source = 'skills'; Destination = 'skills' },
    @{ Source = 'opencode/agent'; Destination = 'agents' },
    @{ Source = 'opencode/command'; Destination = 'commands' }
)
$expected = @{}
$errors = [System.Collections.Generic.List[string]]::new()

function Get-FileHashValue {
    param([string] $Path)

    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

foreach ($pluginName in $pluginNames) {
    $pluginRoot = Join-Path $repositoryRoot $pluginName
    foreach ($mapping in $mappings) {
        $sourceRoot = Join-Path $pluginRoot $mapping.Source
        if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
            continue
        }

        foreach ($sourceFile in Get-ChildItem -LiteralPath $sourceRoot -Recurse -File) {
            $relativePath = $sourceFile.FullName.Substring($sourceRoot.Length).TrimStart('\', '/')
            $targetPath = Join-Path (Join-Path $Destination $mapping.Destination) $relativePath
            if ($expected.ContainsKey($targetPath)) {
                $errors.Add("Multiple plugin files install to $targetPath")
                continue
            }
            $expected[$targetPath] = $sourceFile.FullName
        }
    }

    $workflowFile = Join-Path $pluginRoot 'WORKFLOW.md'
    if (Test-Path -LiteralPath $workflowFile -PathType Leaf) {
        $expected[(Join-Path $Destination 'WORKFLOW.md')] = $workflowFile
    }
}

foreach ($targetPath in $expected.Keys) {
    $sourcePath = $expected[$targetPath]
    if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
        $errors.Add("Missing installed file: $targetPath")
        continue
    }
    if ((Get-FileHashValue $sourcePath) -ne (Get-FileHashValue $targetPath)) {
        $errors.Add("Changed installed file: $targetPath")
    }
}

$staleAgents = @('coding-agent.md', 'review-agent.md')
foreach ($name in $staleAgents) {
    $path = Join-Path (Join-Path $Destination 'agents') $name
    if (Test-Path -LiteralPath $path -PathType Leaf) {
        $errors.Add("Stale owned file: $path")
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "OpenCode install parity verified for $Destination"
