# Cursor Team Kit plugin

Internal-style workflows for CI, code review, shipping, and test reliability. The kit is designed to be plug and play without requiring third-party service integrations.

## Installation

```bash
/plugin install cursor-team-kit
```

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

## Using this plugin with OpenCode

OpenCode discovers skills and agents from its own configuration directories. From the repository root, install Cursor Team Kit globally:

```powershell
pwsh -File ./scripts/install-opencode.ps1 -Plugin cursor-team-kit
```

Add `-Scope Project` to install into `.opencode/` in the current project. The installer copies skills into OpenCode's native `skills/` directory and the `ci-watcher` agent into `agents/`. Quit and restart OpenCode after installing.

`skills/*/SKILL.md` files use the shared [Agent Skills](https://agentskills.io) open standard and work unmodified. The `opencode/agent/` directory in this plugin ships an OpenCode-native version of `ci-watcher`.

## License

MIT
