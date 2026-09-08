<#
.SYNOPSIS
Installs one or more repository plugins into OpenCode's native directories.

.EXAMPLE
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack -Scope Global
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('cursor-team-kit', 'pstack', 'thermos', 'opencode-workflow')]
    [string[]] $Plugin = @('cursor-team-kit', 'pstack', 'thermos', 'opencode-workflow'),

    [ValidateSet('Global', 'Project')]
    [string] $Scope = 'Global',

    [string] $Destination
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$staleAgents = @('coding-agent.md', 'review-agent.md')

if (-not $Destination) {
    $Destination = if ($Scope -eq 'Global') {
        Join-Path $HOME '.config/opencode'
    } else {
        Join-Path (Get-Location) '.opencode'
    }
}

function Copy-PluginDirectory {
    param(
        [string] $Source,
        [string] $Target,
        [string] $Label
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        return
    }

    if ($PSCmdlet.ShouldProcess($Target, "Install $Label")) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
        Copy-Item -Path (Join-Path $Source '*') -Destination $Target -Recurse -Force
    }
}

function Invoke-JsonMerge {
    param(
        [string] $Template,
        [string] $Dest
    )

    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) {
        $python = Get-Command python3 -ErrorAction SilentlyContinue
    }
    if (-not $python) {
        throw 'python is required to merge opencode.json.template'
    }

    $merger = Join-Path $PSScriptRoot 'merge-opencode-json.py'
    & $python.Source $merger $Template $Dest
    if ($LASTEXITCODE -ne 0) {
        throw "merge-opencode-json.py failed with exit code $LASTEXITCODE"
    }
}

foreach ($name in $Plugin) {
    $pluginRoot = Join-Path $repositoryRoot $name
    if (-not (Test-Path -LiteralPath $pluginRoot -PathType Container)) {
        throw "Unknown plugin directory: $name"
    }

    Copy-PluginDirectory `
        -Source (Join-Path $pluginRoot 'skills') `
        -Target (Join-Path $Destination 'skills') `
        -Label "$name skills"
    Copy-PluginDirectory `
        -Source (Join-Path $pluginRoot 'opencode/agent') `
        -Target (Join-Path $Destination 'agents') `
        -Label "$name agents"
    Copy-PluginDirectory `
        -Source (Join-Path $pluginRoot 'opencode/command') `
        -Target (Join-Path $Destination 'commands') `
        -Label "$name commands"

    $workflow = Join-Path $pluginRoot 'WORKFLOW.md'
    if (Test-Path -LiteralPath $workflow -PathType Leaf) {
        if ($PSCmdlet.ShouldProcess((Join-Path $Destination 'WORKFLOW.md'), "Install $name WORKFLOW.md")) {
            New-Item -ItemType Directory -Force -Path $Destination | Out-Null
            Copy-Item -LiteralPath $workflow -Destination (Join-Path $Destination 'WORKFLOW.md') -Force
        }
    }

    $template = Join-Path $pluginRoot 'opencode.json.template'
    if (Test-Path -LiteralPath $template -PathType Leaf) {
        if ($PSCmdlet.ShouldProcess((Join-Path $Destination 'opencode.json'), "Merge $name opencode.json.template")) {
            Invoke-JsonMerge -Template $template -Dest (Join-Path $Destination 'opencode.json')
        }
    }

    $modelsExample = Join-Path $pluginRoot 'models.conf.example'
    if ($Scope -eq 'Global' -and (Test-Path -LiteralPath $modelsExample -PathType Leaf)) {
        $pstackDir = Join-Path $HOME '.pstack'
        $modelsDest = Join-Path $pstackDir 'models.conf'
        if (-not (Test-Path -LiteralPath $modelsDest -PathType Leaf)) {
            if ($PSCmdlet.ShouldProcess($modelsDest, 'Install pstack models.conf from example')) {
                New-Item -ItemType Directory -Force -Path $pstackDir | Out-Null
                Copy-Item -LiteralPath $modelsExample -Destination $modelsDest
            }
        }
    }
}

$agentsDir = Join-Path $Destination 'agents'
if (Test-Path -LiteralPath $agentsDir -PathType Container) {
    foreach ($stale in $staleAgents) {
        $path = Join-Path $agentsDir $stale
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            if ($PSCmdlet.ShouldProcess($path, 'Remove stale OpenCode agent')) {
                Remove-Item -LiteralPath $path -Force
                Write-Host "Removed stale agent $stale"
            }
        }
    }
}

if ($WhatIfPreference) {
    return
}

Write-Host "Installed $($Plugin -join ', ') in $Destination"
if ($Plugin -contains 'opencode-workflow') {
    Write-Host 'Configure your provider and run /setup-pstack to select models for workflow roles.'
}
Write-Host 'Restart OpenCode to load the new skills, agents, and commands.'
