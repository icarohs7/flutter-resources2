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

For bounded routine changes with established patterns and deterministic
checks, state the acceptance cases and execute within the authorized scope
without creating a canonical plan or selecting new execution models. File count
alone does not require a formal plan. Use the full planning workflow for an
explicitly requested plan, an existing plan being executed, architectural or
high-risk work, unresolved contracts, or work needing durable coordination.
This lightweight path does not bypass explicit review or approval gates.

When the user provides a **written plan**, follow its approved decisions and
steps. Resolve routine implementation obstacles within that approach. If a
blocker requires changing an approved decision or unavailable user input, name
it and pause the dependent work; continue independent authorized work.

## Planning workflow

For work requiring a formal plan, plan in this order. State writes remain
subject to the plan/review-only gate below; otherwise present the plan in the
response without creating files:

1. **Context** — map the relevant code and existing patterns.
2. **Questions** — surface ambiguous requirements and tradeoffs.
3. **Structure** — update `.memory/plan.md` and `.memory/verify.md`.
4. **Tasks** — add atomic steps to `.memory/progress.md`.
5. **Execution** — implement the next bounded slice.

For `.memory/` file definitions, initialization, and handoff, use the
`persistent-state` skill — do not duplicate that protocol here.

**Plan/review-only:** follow the AGENTS.md gate. Do not edit implementation or
configuration until execution is approved. Create only requested planning/state
artifacts allowed by that gate. For a pure read-only review or an explicit
no-file-changes request, report findings in the response without state writes.

**After approval:** execute and verify one bounded slice at a time, continuing
through the authorized scope without repeating the full plan. Slice boundaries
are verification points; ask again only where the user or approved plan sets
a checkpoint. Approval for the next slice alone does not authorize the whole
plan. Do not stop merely because a slice is complete.

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
