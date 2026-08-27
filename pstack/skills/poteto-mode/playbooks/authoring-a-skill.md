### Authoring or modifying a skill

**You own the skill's voice.** Agent-facing prose has a higher bar than human prose; unhelpful sentences become instructions.

1. Write the SKILL.md:
   - YAML frontmatter between `---` markers with `name` (lowercase, hyphenated, matches the directory name) and `description` (specific enough that an agent can tell when to invoke it — this is the single most important field, since it drives auto-invocation). Keep `description` as one YAML scalar: quote it, or use `description: >-` with indented continuation lines, whenever punctuation or line wrapping would otherwise break it.
   - Body: step-by-step instructions written as agent-facing prose — imperative, precise, no filler. Same bar as the rest of this playbook: an unhelpful sentence becomes an instruction some future agent follows.
   - Save it to `.claude/skills/<name>/SKILL.md` (project) or `~/.claude/skills/<name>/SKILL.md` (personal) for Claude Code; `.opencode/skills/<name>/SKILL.md` or `~/.config/opencode/skills/<name>/SKILL.md` for OpenCode.
2. Validate the skill: frontmatter has `name` and `description`, referenced files exist, cross-skill links resolve.
3. Test cases if structural; skip if subjective.
4. Run **Opening a PR**.

When in doubt, delete; prose earns its keep by changing a decision. Tell it to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config); hardcoded details go stale (the **encode-lessons-in-structure** principle skill). Delegate to other skills by path; don't restate. A workflow you keep hitting but isn't captured → propose a new skill.

**Reply:** summary of the skill, key design decisions, validation notes.
