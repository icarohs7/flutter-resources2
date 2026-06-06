---
name: flutter-dart
description: >
  Dart and Flutter coding standards and library-specific conventions for
  flutter_resources2. Use when working with .dart files under lib/ or test/.
  Read this SKILL.md first, then the topic file(s) listed in "Topic router"
  for the paths you will touch.
---

## Before you edit

1. Read this file (standards + router).
2. Read every topic file that matches your task before the first `.dart` change.
3. After a long detour (CI, docs-only), re-read this router and re-open relevant topic files.

### Topic router

| Task or path | Read |
|--------------|------|
| Package layout, exports, `pubspec.yaml`, sibling `flutter-resources` deps | [project.md](project.md) |
| `lib/src/widgets/`, form fields, `N*` widgets | [widgets.md](widgets.md) |
| `lib/src/storage/`, persisted fields, Hive | [storage.md](storage.md) |
| `.g.dart`, `.freezed.dart`, build_runner | [codegen.md](codegen.md) |
| Extensions, utils, failure types, adapters | [project.md](project.md) |

**Reference modules:** `widgets/`, `storage/`, `search_resources/` — match patterns in neighboring files.

---

## Project rules (dual format)

Guardrails under `.agents/rules/` (details: [../../rules/README.md](../../rules/README.md)):

| Tool | Files | Frontmatter |
|------|-------|-------------|
| Cursor | `flutter-*.mdc` at rules root | `globs`, `alwaysApply` |
| Kimi Code CLI | `flutter/*.md` | `paths`, `priority` |

When you change a rule, update **both** twins (body must match; frontmatter differs).

Cursor loads `.mdc` via junction `.cursor/rules` → `.agents/rules` — setup in `.cursor/README.md`.

---

## Coding standards

### Dart & Flutter

- **State:** prefer `flutter_hooks` + `HookWidget` over `StatefulWidget` unless the
  surrounding widget already uses `StatefulWidget` or hooks add no benefit.
- **Null safety:** soundly null-safe; avoid `!` unless guaranteed non-null.
- **Arrow functions** for one-liners.
- **Composition** over deep nesting; **private widget classes**, not private methods
  returning `Widget`.
- **`const` constructors** wherever possible.
- **Constructor-promoted fields above the constructor** (static members first, then
  fields, then constructors, then methods).
- No expensive work (network, complex compute) inside `build()`.
- **Validation pipeline:** run `dart format .` first, then `flutter analyze`.

### Naming

- **English** for programmatic identifiers.
- Public widgets/utilities often use the `N` prefix (`NImage`, `NMessenger`) — follow
  existing names in the module you touch.
- User-facing strings may be **pt-BR** when the widget is locale-specific; library
  defaults stay neutral unless an app passes localized text.

### Library boundaries

- No app-specific routes, API URLs, or business rules.
- Re-export carefully from `lib/flutter_resources2.dart` — avoid symbol clashes
  (see existing `hide` clauses).
- Prefer extending existing `core_resources` / sibling resource packages over duplicating.
