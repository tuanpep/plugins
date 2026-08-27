# Set up pstack

In this page you install the plugin, pick which models pstack uses, and run your first task. Setup is one command plus a short conversation.

## Install the plugin

From the [repository root](../../../README.md#quick-install-all-plugins):

| OS | Claude Code | OpenCode |
|----|-------------|----------|
| Windows (PowerShell) | `pwsh -File ./scripts/install-claude.ps1 -Plugin pstack` | `pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack` |
| Windows (Git Bash) | `bash ./scripts/install-claude.sh --plugin pstack` | `bash ./scripts/install-opencode.sh --plugin pstack` |
| macOS / Linux | `bash ./scripts/install-claude.sh --plugin pstack` | `bash ./scripts/install-opencode.sh --plugin pstack` |

Install `cursor-team-kit` alongside pstack for `/deslop`, `control-cli`, and `control-ui`. Restart your agent host after installing.

See also the [pstack README](../../README.md) and the full [pstack guide](./README.md).

## Pick your models