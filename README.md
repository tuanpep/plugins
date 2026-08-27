# Agent plugins

A plugin marketplace for [Claude Code](https://code.claude.com) and [OpenCode](https://opencode.ai): developer team workflows, deep code review, and rigorous engineering skills. Each plugin is a standalone directory at the repository root with its own `.claude-plugin/plugin.json` manifest.

## Plugins

| `name` | Plugin | Author | Description |
|:-------|:-------|:-------|:-------------------------------------|
| `cursor-team-kit` | [Cursor Team Kit](cursor-team-kit/) | tuan.bt | Internal team workflows for CI, code review, shipping, local automation, and verification. |
| `thermos` | [Thermos](thermos/) | tuan.bt | Thermo-nuclear branch review: deep security/correctness audits, harsh code-quality rubrics, parallel subagents, thermos orchestration, and optional merge-ready PR flows. |
| `pstack` | [pstack](pstack/) | Lauren Tan | if you want to go fast, go deep first. pstack helps you write less, but higher quality code. rigorous agent workflows you can parallelize with confidence. |

## Installing in Claude Code

Add this repository as a plugin marketplace, then install whichever plugin you want:

```bash
claude plugin marketplace add <your-github-user>/<this-repo>
/plugin install cursor-team-kit
/plugin install thermos
/plugin install pstack
```

Or test a plugin locally without installing:

```bash
claude --plugin-dir ./pstack
```

## Install in OpenCode

OpenCode discovers skills from `~/.config/opencode/skills/` and agents from `~/.config/opencode/agents/`. Use the installer from the repository root:

```powershell
# Install every plugin for every project.
pwsh -File ./scripts/install-opencode.ps1

# Install one plugin in the current project's .opencode directory.
pwsh -File ./scripts/install-opencode.ps1 -Plugin pstack -Scope Project
```

The installer is safe to rerun. It updates only the selected plugins' `skills/` and OpenCode-native `agents/` files. It does not edit `opencode.json` because OpenCode loads these directories automatically. Quit and restart OpenCode after installing.

To copy files yourself, copy each plugin's `skills/*` folders to `.opencode/skills/` or `~/.config/opencode/skills/`. Copy `opencode/agent/*.md` to `.opencode/agents/` when the plugin includes agents. OpenCode also supports singular directory names for older configurations, but its current documentation uses plural names.

Run the repository check after changing a plugin:

```powershell
pwsh -File ./scripts/verify-opencode.ps1
```

## Repository structure

```
.
├── .claude-plugin/
│   └── marketplace.json       # Marketplace manifest (lists all plugins)
├── plugin-name/
│   ├── .claude-plugin/
│   │   └── plugin.json        # Per-plugin manifest
│   ├── skills/                # Agent skills (SKILL.md with frontmatter) — portable to OpenCode
│   ├── agents/                # Claude Code subagent definitions
│   ├── hooks/                 # Claude Code hook definitions (if present)
│   ├── README.md
│   └── LICENSE
└── ...
```

## License

MIT
