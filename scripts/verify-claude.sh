#!/usr/bin/env bash
# Validates Claude Code skill and agent assets. Requires PowerShell 7+.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v pwsh >/dev/null 2>&1; then
  exec pwsh -File "${script_dir}/verify-claude.ps1" "$@"
fi

echo "PowerShell 7 (pwsh) is required to run verify-claude. Install it from https://learn.microsoft.com/powershell/scripting/install/installing-powershell" >&2
exit 1
