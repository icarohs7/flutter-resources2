---
name: planning-workflow
description: >
  Plan and execute non-trivial work in bounded vertical slices. Use for
  multi-file or behavioral changes, architecture or feature work, written
  user plans, design or approach discussions, or when updating .memory/
  plan.md, verify.md, or progress.md for a task.
disable-model-invocation: true
---

## Gate

Load this skill for **non-trivial** work: multi-file edits, behavioral changes,
architectural choices, or anything beyond an obvious one- or two-line fix.

For trivial fixes, execute directly and verify — no formal plan.

When the user provides a **written plan**, follow it step by step. Do not
redesign unless there is a real blocker; flag the blocker and wait.

## Planning workflow

Plan in this order:

1. **Context** — map the relevant code and existing patterns.
2. **Questions** — surface ambiguous requirements and tradeoffs.
3. **Structure** — update `.memory/plan.md` and `.memory/verify.md`.
4. **Tasks** — add atomic steps to `.memory/progress.md`.
5. **Execution** — implement the next bounded slice.

For `.memory/` file definitions, initialization, and handoff, use the
`persistent-state` skill — do not duplicate that protocol here.

**Plan-only:** when asked only to plan, think, review, or assess first, output
the plan and do **not** edit files until the user approves execution.

**After approval:** execute the next slice without repeating the full plan.

## Execution limits

Agents degrade when they batch too much work without feedback. Keep each pass
bounded:

- Execute one small **vertical slice** at a time.
- Avoid broad refactors mixed with feature work.
- Keep a phase to roughly **five touched files** unless the change is purely
  mechanical.
- For large independent areas, split the work and verify each area separately.

## Risk and verification

- If a change is **risky** and there is no obvious recovery point, offer to
  checkpoint first (commit, stash, or branch — per user preference).
- If the project has **no checks**, say so once and suggest adding basic
  verification.
