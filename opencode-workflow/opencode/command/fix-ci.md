---
description: Inspect failing CI or local checks and apply a focused fix.
agent: code
---

Load the `fix-ci` skill. If the user is waiting on a PR, also use `@ci-watcher` or `loop-on-ci` as needed. Fix the root cause. Re-run the failing check. Do not commit unless asked.

Task:
$ARGUMENTS
