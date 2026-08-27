<#
.SYNOPSIS
Installs one or more repository plugins into Claude Code from the local marketplace.

.EXAMPLE
pwsh -File ./scripts/install-claude.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('cursor-team-kit', 'pstack', 'thermos')]
    [string[]] $Plugin = @('cursor-team-kit', 'pstack', 'thermos'),

    [string] $Marketplace = 'agent-plugins',

    [string] $MarketplacePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
if (-not $MarketplacePath) {
    $MarketplacePath = $repositoryRoot
}

function Invoke-Claude {
    param([string[]] $Arguments)

    & claude @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "claude $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

if ($PSCmdlet.ShouldProcess($MarketplacePath, "Ensure marketplace $Marketplace")) {
    $marketplaces = & claude plugin marketplace list 2>&1
    if ($marketplaces -notmatch [regex]::Escape($Marketplace)) {
        Invoke-Claude @('plugin', 'marketplace', 'add', $MarketplacePath)
    } else {
        Invoke-Claude @('plugin', 'marketplace', 'update', $Marketplace)
    }
}

foreach ($name in $Plugin) {
    $pluginId = "$name@$Marketplace"
    if ($PSCmdlet.ShouldProcess($pluginId, 'Install or update plugin')) {
        $installed = & claude plugin list 2>&1
        if ($installed -match [regex]::Escape($pluginId)) {
            Invoke-Claude @('plugin', 'update', $pluginId)
        } else {
            Invoke-Claude @('plugin', 'install', $pluginId)
        }
    }
}

Write-Host "Installed $($Plugin -join ', ') from $Marketplace."
Write-Host 'Restart Claude Code to load the new skills and agents.'
