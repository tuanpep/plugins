# Set up pstack

In this page you install the plugin, pick which models pstack uses, and run your first task. Setup is one command plus a short conversation.

## Install the plugin

From the [repository root](../../../README.md#install-opencode-plugins):

| OS | Command |
|----|---------|
| Windows (PowerShell) | `pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack` |
| Windows (Git Bash) | `bash ./scripts/install-opencode.sh --plugin pstack` |
| macOS / Linux | `bash ./scripts/install-opencode.sh --plugin pstack` |

Install `cursor-team-kit` alongside pstack for `/deslop`, `control-cli`, and `control-ui`. Restart OpenCode after installing. For a project install, add `-Scope Project` in PowerShell or `--scope project` in Bash.

See also the [pstack README](../../README.md) and the full [pstack guide](./README.md).

## Pick your models
