# Thermos plugin

Thermo-nuclear branch review: deep correctness and security audits, harsh maintainability rubrics, and parallel subagent orchestration.

## Installation

```bash
/plugin install thermos
```

## Architecture

```mermaid
flowchart TB
  subgraph L2["Orchestrator"]
    TH[thermos]
  end

  subgraph L1["Subagents"]
    SNR[thermo-nuclear-review-subagent]
    SNCQ[thermo-nuclear-code-quality-review-subagent]
  end

  DIFF[git diff + file contents]

  subgraph L0["Skills"]
    TNR[thermo-nuclear-review]
    TNCQ[thermo-nuclear-code-quality-review]
  end

  TH --> SNR
  TH --> SNCQ
  SNR --> TNR
  SNR --> DIFF
  SNCQ --> TNCQ
  SNCQ --> DIFF
```

## Skills

| Skill | Description |
|:------|:------------|
| `thermo-nuclear-review` | Deep branch audit (bugs, breakages, security, devex, feature-gate leaks). |
| `thermo-nuclear-code-quality-review` | Strict maintainability audit (code-judo, 1k-line rule, spaghetti, boundaries). |
| `thermos` | Run both review subagents in parallel and synthesize findings. |

## Agents

| Agent | Description |
|:------|:------------|
| `thermo-nuclear-review-subagent` | Task subagent for deep review rubric (diff-scoped). |
| `thermo-nuclear-code-quality-review-subagent` | Task subagent for code-quality rubric (diff-scoped). |

## Typical usage

**Double review (thermos):**

1. Gather `git diff main...HEAD` and full contents of changed files.
2. Invoke both subagents in one message with `run_in_background: true`.
3. Synthesize prioritized, deduped findings.

**Single skill:** invoke `thermo-nuclear-review` or `thermo-nuclear-code-quality-review` in the main agent, or the matching subagent after gathering diff context.

## Using this plugin with OpenCode

OpenCode discovers skills and agents from its own configuration directories. From the repository root, install Thermos globally:

```powershell
pwsh -File ./scripts/install-opencode.ps1 -Plugin thermos
```

Add `-Scope Project` to install into `.opencode/` in the current project. The installer copies skills into OpenCode's native `skills/` directory and both review agents into `agents/`. Quit and restart OpenCode after installing.

`skills/*/SKILL.md` files use the shared [Agent Skills](https://agentskills.io) open standard and work unmodified. The `opencode/agent/` directory ships OpenCode-native versions of both subagents. Mention them directly with `@thermo-nuclear-review-subagent` or `@thermo-nuclear-code-quality-review-subagent` after gathering a diff.

## License

MIT
