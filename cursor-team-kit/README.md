# cursor-team-kit for OpenCode

`cursor-team-kit` adds workflows for CI, code review, shipping, and test reliability to OpenCode. It works without third-party service integrations.

## Install

From the [repository root](../README.md#install-opencode-plugins), run one command:

| OS | Command |
|----|---------|
| Windows, PowerShell | `pwsh -File ./scripts/install-opencode.ps1 -Plugin cursor-team-kit` |
| Windows, Git Bash | `bash ./scripts/install-opencode.sh --plugin cursor-team-kit` |
| macOS or Linux | `bash ./scripts/install-opencode.sh --plugin cursor-team-kit` |

For a project install, add `-Scope Project` in PowerShell or `--scope project` in Bash. Restart OpenCode after installation.

## Components

### Skills

| Skill | Description |
|:------|:------------|
| `loop-on-ci` | Watch CI runs and iterate on failures until checks pass |
| `review-and-ship` | Review changes, commit them, and open a PR |
| `pr-review-canvas` | Generate an HTML PR walkthrough with categorized, annotated diffs |
| `verify-this` | Prove or disprove a claim with baseline and treatment artifacts |
| `control-cli` | Build or adapt a local control tool for interactive CLIs or TUIs |
| `control-ui` | Build or adapt a browser/CDP control tool for web or Electron UIs |
| `make-pr-easy-to-review` | Clean PR history and improve reviewer guidance |
| `run-smoke-tests` | Run Playwright smoke tests and investigate failures |
| `fix-ci` | Find failing CI jobs, inspect logs, and apply focused fixes |
| `new-branch-and-pr` | Create a branch, complete work, and open a PR |
| `get-pr-comments` | Fetch and summarize active PR comments |
| `check-compiler-errors` | Run compile and type checks and report failures |
| `what-did-i-get-done` | Summarize authored commits for a time period |
| `weekly-review` | Generate a weekly work summary |
| `fix-merge-conflicts` | Resolve merge conflicts and validate the result |
| `deslop` | Remove AI-generated code slop and clean up code style |
| `workflow-from-chats` | Extract durable preferences from chats into skills, rules, or docs |

### Agent

Mention `@ci-watcher` to monitor GitHub Actions runs and receive a concise pass or fail summary.

For strict maintainability review, install [thermos](../thermos/). It owns `thermo-nuclear-code-quality-review` and its review agent.

## License and provenance

MIT. Derived from [cursor/plugins](https://github.com/cursor/plugins). Copyright (c) 2026 Cursor.
