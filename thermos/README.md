# thermos for OpenCode

`thermos` runs deep branch reviews for correctness, security, and maintainability through parallel OpenCode subagents.

## Install

From the [repository root](../README.md#install-opencode-plugins), run one command:

| OS | Command |
|----|---------|
| Windows, PowerShell | `pwsh -File ./scripts/install-opencode.ps1 -Plugin thermos` |
| Windows, Git Bash | `bash ./scripts/install-opencode.sh --plugin thermos` |
| macOS or Linux | `bash ./scripts/install-opencode.sh --plugin thermos` |

Restart OpenCode after installation.

## Skills

| Skill | Description |
|:------|:------------|
| `thermo-nuclear-review` | Audit a branch for bugs, breaking changes, security issues, developer-experience regressions, and feature-gate leaks |
| `thermo-nuclear-code-quality-review` | Audit maintainability, file size, boundaries, and condition complexity |
| `thermos` | Run both review subagents in parallel and combine their findings |

## Agents

Mention either agent after gathering the diff and full contents of changed files:

| Agent | Description |
|:------|:------------|
| `@thermo-nuclear-review-subagent` | Diff-scoped correctness and security review |
| `@thermo-nuclear-code-quality-review-subagent` | Diff-scoped maintainability review |

For a full thermos pass, invoke both agents in parallel. Use the `thermos` skill when you want it to coordinate the two reviews and combine their findings.

## License and provenance

MIT. Derived from [cursor/plugins](https://github.com/cursor/plugins). Copyright (c) 2026 Cursor.
