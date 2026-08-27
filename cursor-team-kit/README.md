# Cursor Team Kit plugin

Internal-style workflows for CI, code review, shipping, and test reliability. The kit is designed to be plug and play without requiring third-party service integrations.

## Install

From the [repository root](../README.md#quick-install-all-plugins):

| OS | Claude Code | OpenCode |
|----|-------------|----------|
| Windows (PowerShell) | `pwsh -File ./scripts/install-claude.ps1 -Plugin cursor-team-kit` | `pwsh -File ./scripts/install-opencode.ps1 -Plugin cursor-team-kit` |
| Windows (Git Bash) | `bash ./scripts/install-claude.sh --plugin cursor-team-kit` | `bash ./scripts/install-opencode.sh --plugin cursor-team-kit` |
| macOS / Linux | `bash ./scripts/install-claude.sh --plugin cursor-team-kit` | `bash ./scripts/install-opencode.sh --plugin cursor-team-kit` |

Project-local OpenCode install: add `-Scope Project` (PowerShell) or `--scope project` (Bash).

Restart your agent host after installing.

## Components

### Skills

| Skill | Description |
|:------|:------------|
| `loop-on-ci` | Watch CI runs and iterate on failures until checks pass |
| `review-and-ship` | Run a structured review, commit changes, and open a PR |
| `pr-review-canvas` | Generate an interactive HTML PR walkthrough with annotated, categorized diffs |
| `verify-this` | Prove or disprove claims with baseline/treatment artifacts and a clear verdict |
| `control-cli` | Build or adapt a local harness to drive and profile interactive CLIs or TUIs |
| `control-ui` | Build or adapt a local browser/CDP harness for web or Electron UIs |
| `make-pr-easy-to-review` | Clean noisy PR history, improve descriptions, and add reviewer guidance |
| `run-smoke-tests` | Run Playwright smoke tests and triage failures |
| `fix-ci` | Find failing CI jobs, inspect logs, and apply focused fixes |
| `new-branch-and-pr` | Create a fresh branch, complete work, and open a pull request |
| `get-pr-comments` | Fetch and summarize review comments from the active pull request |
| `check-compiler-errors` | Run compile and type-check commands and report failures |
| `what-did-i-get-done` | Summarize authored commits over a given time period into a concise status update |
| `weekly-review` | Generate a weekly recap of shipped work with bugfix/tech-debt/net-new highlights |
| `fix-merge-conflicts` | Resolve merge conflicts, validate build/tests, and summarize decisions |
| `deslop` | Remove AI-generated code slop and clean up code style |
| `workflow-from-chats` | Extract durable working preferences from chats into skills, rules, or docs |

### Agents

| Agent | Description |
|:------|:------------|
| `ci-watcher` | Monitor GitHub Actions runs and return concise pass/fail summaries |

For the strict maintainability review previously shipped here as `thermo-nuclear-code-quality-review`, install the [`thermos`](../thermos/) plugin instead — it now owns that skill and agent.

### OpenCode

Mention `@ci-watcher` after install.

## License

MIT. Derived from [cursor/plugins](https://github.com/cursor/plugins) — Copyright (c) 2026 Cursor.
