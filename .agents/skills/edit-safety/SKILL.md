---
name: edit-safety
description: >
  Safe file edits, renames, deletes, and dependency changes. Use when
  renaming or moving files, changing public APIs or signatures, deleting
  code, structural refactors, searching references, or adding a new
  package or library dependency.
disable-model-invocation: true
---

## Gate

Load this skill before **risky code structure changes** — not for every
one-line fix. For large-file reading and truncated tool output, use
`persistent-state`.

## Before and after edits

- **Re-read** a file immediately before editing and again after editing.
- Do not rely on an earlier read from a long conversation.

## Rename and signature changes

Search **separately** for each kind of reference; one search is not enough:

- Direct calls and imports
- Type references and implements/extends
- String literals (routes, keys, serialization names)
- Dynamic imports and reflection
- Barrel files and re-exports (`lib/flutter_resources2.dart`, module `*.dart` barrels)
- Test mocks and fakes
- Downstream apps that consume this package (search for `package:flutter_resources2/` imports when changing public API)

Update all hits before considering the change complete.

## Delete files

**Never** delete a file without verifying references first (ripgrep, IDE
references, or project search). If anything still references it, update or
remove those references first.

## Large-file refactors

Before structural refactors in large files, remove only dead code that is
**directly in the way** or that **your change creates** — do not scope-creep
unrelated cleanup.

## Dependencies

Prefer existing libs and utilities in the repository. When adding a **new**
dependency, justify it in the PR or summary: problem solved, why existing
options are insufficient.

Do not commit dependency changes unless the user asked to commit; use the
`git-commit` skill when they do.
