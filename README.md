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

## Installing in OpenCode

OpenCode has no marketplace/plugin-install concept for skill bundles — it reads `SKILL.md` files directly from known directories. Copy or symlink the skill folders you want into one of:

```
.opencode/skills/<name>/       # project-local
~/.config/opencode/skills/<name>/   # global
```

For example, to pull in every skill from `pstack`:

```bash
cp -r pstack/skills/* .opencode/skills/
```

Each `SKILL.md` follows the shared [Agent Skills](https://agentskills.io) open standard (`name` + `description` frontmatter), so skill bodies work unmodified in both tools. `agents/` (subagents) and `hooks/` are Claude Code-specific and are not loaded by OpenCode.

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
