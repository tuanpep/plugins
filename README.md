# Agent plugins

Plugin marketplace for [Claude Code](https://code.claude.com) and [OpenCode](https://opencode.ai): CI workflows, code review, rigorous engineering skills, and deep branch audits.

Adapted from the official [Cursor plugins](https://github.com/cursor/plugins) (`cursor-team-kit`, `pstack`, `thermos`). This fork adds Claude Code subagents, OpenCode primary agents, and install/verify scripts.

Skills use the shared [Agent Skills](https://agentskills.io) format and work in both tools. Agent definitions are host-specific:

| Host | Agent location | Role |
|------|----------------|------|
| Claude Code | `agents/*.md` | Subagents invoked via the Task tool |
| OpenCode | `opencode/agent/*.md` | Primary agents (Tab) and subagents (@mention) |

## Plugins

| Name | Folder | What it adds |
|------|--------|--------------|
| `cursor-team-kit` | [cursor-team-kit/](cursor-team-kit/) | CI, shipping, PR review, verification, CLI/UI harness skills |
| `pstack` | [pstack/](pstack/) | Poteto Mode, principles, architect/interrogate/swarm workflows |
| `thermos` | [thermos/](thermos/) | Thermo-nuclear branch review (security + code quality) |

---

## Prerequisites

| Tool | Claude Code | OpenCode |
|------|-------------|----------|
| CLI | [`claude`](https://code.claude.com) | [`opencode`](https://opencode.ai) |
| Windows | PowerShell 7+ (`pwsh`) or Git Bash | PowerShell 7+ (`pwsh`) or Git Bash |
| macOS / Linux | Bash (default shell) | Bash (default shell) |

Optional on any OS: [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) for `.ps1` installers and verify scripts.

On macOS/Linux, run Bash installers with `bash ./scripts/...` (or `chmod +x scripts/*.sh` first).

---

## Clone from source

### Upstream (Cursor)

Official plugin source and Cursor marketplace:

```bash
git clone https://github.com/cursor/plugins.git
cd plugins
```

Install via Cursor's plugin marketplace or copy individual plugin folders into your project. See the [upstream README](https://github.com/cursor/plugins/blob/main/README.md) for the full plugin catalog.

### This fork (Claude Code + OpenCode)

```bash
git clone https://github.com/tuanpep/plugins.git
cd plugins
```

Then follow [Quick install](#quick-install-all-plugins) below.

---

## Quick install (all plugins)

Clone this fork, `cd` into it, then run **one** row for your host and OS.

### Claude Code

| OS | Command |
|----|---------|
| **Windows** (PowerShell) | `pwsh -File ./scripts/install-claude.ps1` |
| **Windows** (Git Bash) | `bash ./scripts/install-claude.sh` |
| **macOS / Linux** | `bash ./scripts/install-claude.sh` |

Manual equivalent (any OS):

```bash
# Local clone
claude plugin marketplace add /path/to/this/repo

# GitHub
claude plugin marketplace add tuanpep/plugins

claude plugin install cursor-team-kit@agent-plugins
claude plugin install pstack@agent-plugins
claude plugin install thermos@agent-plugins
```

The marketplace id is `agent-plugins` (from `.claude-plugin/marketplace.json`).

### OpenCode

| OS | Command |
|----|---------|
| **Windows** (PowerShell) | `pwsh -File ./scripts/install-opencode.ps1` |
| **Windows** (Git Bash) | `bash ./scripts/install-opencode.sh` |
| **macOS / Linux** | `bash ./scripts/install-opencode.sh` |

Install location:

| Scope | Path |
|-------|------|
| Global (default) | `~/.config/opencode/` |
| Project | `./.opencode/` in the current directory |

Project scope example:

```bash
# PowerShell
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack -Scope Project

# Bash
bash ./scripts/install-opencode.sh --plugin pstack --scope project
```

**Restart the host** after installing (Claude Code or OpenCode).

---

## Post-install

1. **Restart** Claude Code or OpenCode.
2. **Claude Code:** if you previously used `cursor-plugins-mirror`, disable the old copies in `~/.claude/settings.json` to avoid duplicate skill catalogs:
   ```json
   "cursor-team-kit@cursor-plugins-mirror": false,
   "pstack@cursor-plugins-mirror": false
   ```
3. **OpenCode (optional):** set a default primary agent in `~/.config/opencode/opencode.json`:
   ```json
   {
     "default_agent": "coding-agent"
   }
   ```
4. **OpenCode:** the installer copies and merges files; it does not delete renamed/removed agents. After agent renames, remove stale `*.md` files from `~/.config/opencode/agents/` manually.

---

## Install one plugin

### Claude Code

```bash
# Bash / macOS / Linux / Git Bash
bash ./scripts/install-claude.sh --plugin pstack

# Windows PowerShell
pwsh -File ./scripts/install-claude.ps1 -Plugin pstack
```

### OpenCode

```bash
bash ./scripts/install-opencode.sh --plugin thermos
pwsh -File ./scripts/install-opencode.ps1 -Plugin thermos
```

---

## Verify before you ship changes

Run from the repository root after editing skills or agents.

| OS | Claude Code | OpenCode |
|----|-------------|----------|
| **Windows** | `pwsh -File ./scripts/verify-claude.ps1` | `pwsh -File ./scripts/verify-opencode.ps1` |
| **macOS / Linux / Git Bash** | `bash ./scripts/verify-claude.sh` | `bash ./scripts/verify-opencode.sh` |

Bash verify scripts delegate to PowerShell 7 when available.

Verification checks skill frontmatter, required agent files, and naming conventions. OpenCode expects four pstack agents (`coding-agent`, `review-agent`, `poteto-mode`, `comment-sicko`); Claude Code also includes legacy `poteto-agent`. Claude agent `comment-sicko` uses `name: Comment Sicko` (not kebab-case) by design.

---

## Agents at a glance

### pstack (Claude Code — Task subagents)

| Subagent | Use for |
|----------|---------|
| `coding-agent` | Default coding delegate |
| `poteto-mode` | Full Poteto Mode workflow |
| `review-agent` | Read-only review |
| `poteto-agent` | Legacy alias for `poteto-mode` |
| `comment-sicko` | Comment cleanup (`Comment Sicko`) |

### pstack (OpenCode — primary agents, Tab to switch)

| Agent | Use for |
|-------|---------|
| `coding-agent` | Default coding (Cursor Agent-style) |
| `poteto-mode` | Rigorous Poteto Mode |
| `review-agent` | Read-only review |

OpenCode subagents: `@comment-sicko`, `@ci-watcher`, thermo review subagents.

### thermos + cursor-team-kit

| Host | Agents |
|------|--------|
| Claude Code | `thermo-nuclear-review-subagent`, `thermo-nuclear-code-quality-review-subagent`, `ci-watcher` |
| OpenCode | Same names as `@`-mention subagents |

See each plugin's README for skill lists and usage. For a guided pstack walkthrough, see [pstack/docs/guide/](pstack/docs/guide/README.md).

---

## Try without installing (Claude Code)

```bash
claude --plugin-dir ./pstack
claude --plugin-dir ./thermos
```

---

## Update after `git pull`

Re-run the installer for your host. Both installers are idempotent.

```bash
bash ./scripts/install-claude.sh
bash ./scripts/install-opencode.sh
```

Then restart Claude Code / OpenCode.

---

## Repository layout

```
.
├── .claude-plugin/marketplace.json   # Claude Code marketplace manifest
├── scripts/
│   ├── install-claude.ps1 / .sh
│   ├── install-opencode.ps1 / .sh
│   ├── verify-claude.ps1
│   └── verify-opencode.ps1
└── <plugin>/
    ├── .claude-plugin/plugin.json
    ├── skills/                       # shared skills (both hosts)
    ├── agents/                       # Claude Code subagents
    └── opencode/agent/               # OpenCode agents
```

---

## Copyright

| Component | Copyright holder | License |
|-----------|------------------|---------|
| `cursor-team-kit`, `thermos` | [Cursor](https://cursor.com) | MIT — see plugin `LICENSE` |
| `pstack` | Lauren Tan | MIT — see [pstack/LICENSE](pstack/LICENSE) |
| Install scripts, Claude/OpenCode agent adaptations | tuanpep | MIT — see [LICENSE](LICENSE) |

Upstream source: [github.com/cursor/plugins](https://github.com/cursor/plugins)

---

## License

MIT. See [LICENSE](LICENSE) and each plugin's `LICENSE` file.
