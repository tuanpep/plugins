<#
.SYNOPSIS
Installs one or more repository plugins into OpenCode's native directories.

.EXAMPLE
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack -Scope Global
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('cursor-team-kit', 'pstack', 'thermos')]
    [string[]] $Plugin = @('cursor-team-kit', 'pstack', 'thermos'),

    [ValidateSet('Global', 'Project')]
    [string] $Scope = 'Global',

    [string] $Destination
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot

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
}

if ($WhatIfPreference) {
    return
}

Write-Host "Installed $($Plugin -join ', ') in $Destination"
Write-Host 'Restart OpenCode to load the new skills and agents.'
