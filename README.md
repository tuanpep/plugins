# OpenCode agent plugins

An OpenCode plugin collection for CI workflows, code review, rigorous engineering skills, and branch audits.

## Plugins

| Name | Folder | What it adds |
|------|--------|--------------|
| `cursor-team-kit` | [cursor-team-kit/](cursor-team-kit/) | CI, shipping, PR review, verification, and CLI/UI control skills |
| `pstack` | [pstack/](pstack/) | Poteto Mode, engineering principles, and multi-agent workflows |
| `thermos` | [thermos/](thermos/) | Deep branch review for correctness, security, and maintainability |
| `opencode-workflow` | [opencode-workflow/](opencode-workflow/) | Primary agents, slash commands, `WORKFLOW.md`, `/compat`, and `/learn` |

## Prerequisites

- [OpenCode](https://opencode.ai)
- PowerShell 7 or later for the PowerShell installer and verification script. On macOS or Linux, you can use the Bash installer instead.

## Install OpenCode plugins

Clone the repository and run the installer from its root.

```bash
git clone https://github.com/tuanpep/plugins.git
cd plugins
```

| OS | Command |
|----|---------|
| Windows, PowerShell | `pwsh -File ./scripts/install-opencode.ps1` |
| Windows, Git Bash | `bash ./scripts/install-opencode.sh` |
| macOS or Linux | `bash ./scripts/install-opencode.sh` |

The installer adds all plugins to `~/.config/opencode/` by default. Restart OpenCode when it finishes.

To install one plugin, pass its name:

```bash
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack
bash ./scripts/install-opencode.sh --plugin thermos
```

To install into the current project's `.opencode/` directory instead:

```bash
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack -Scope Project
bash ./scripts/install-opencode.sh --plugin pstack --scope project
```

`opencode-workflow` merges `opencode.json.template` into the selected destination's `opencode.json`, installs `WORKFLOW.md`, and sets `default_agent` to `code`. The destination is `~/.config/opencode/` for a global install and `.opencode/` for a project install. It does not configure a provider, API key, or model. Configure a provider in OpenCode, copy the applicable entries from `opencode-workflow/opencode-model-routing.example.jsonc` into `opencode.json`, then run `/setup-pstack` to assign available models to pstack roles.

## Use the installed agents

Use Tab to select the `code`, `review`, or `rigor` primary agent. `code` is the default. Use `@` mentions for installed subagents, including `@ci-watcher`, `@poteto-worker`, and the thermos review agents.

Pstack supplies hidden Task targets: `poteto-research` for bounded evidence gathering, `poteto-worker` for implementation and focused review, and `poteto-expert` for trace-backed performance work and high-risk reasoning. Run `/setup-pstack` after installation to configure their models.

Available workflow commands include `/review`, `/rigor`, `/compat`, `/learn`, `/ship`, `/verify`, `/how`, and `/why`. See [pstack/docs/guide/](pstack/docs/guide/README.md) for a pstack walkthrough.

## Verify repository changes

Run this from the repository root after editing OpenCode skills, agents, or commands:

```bash
pwsh -File ./scripts/verify-opencode.ps1
pwsh -File ./scripts/check-opencode-docs.ps1
```

## Update

After `git pull`, rerun the OpenCode installer and restart OpenCode:

```bash
pwsh -File ./scripts/install-opencode.ps1
```

## Copyright and provenance

`cursor-team-kit` and `thermos` are derived from [Cursor plugins](https://github.com/cursor/plugins). `pstack` is derived from work by Lauren Tan. See each plugin's `LICENSE` file.

The OpenCode adaptations, installation scripts, and `opencode-workflow` are MIT licensed by tuanpep. See [LICENSE](LICENSE).
