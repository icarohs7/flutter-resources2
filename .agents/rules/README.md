# Project rules (dual format)

Flutter guardrails are maintained in two shapes for tool compatibility:

| Cursor | Kimi Code CLI |
|--------|----------------|
| `*.mdc` at this folder root (`globs`, `alwaysApply`) | `flutter/*.md` (`paths`, `priority`) |

| Cursor file | Kimi twin | Kimi rule id |
|-------------|-----------|--------------|
| `flutter-dart.mdc` | `flutter/dart.md` | `flutter/dart` |
| `flutter-generated.mdc` | `flutter/generated.md` | `flutter/generated` |

When you change a rule, update **both** the `.mdc` and the matching `.md` body
(frontmatter fields differ; content should match).

Cursor: junction `.cursor/rules` → `.agents/rules` — see `.cursor/README.md`.

Kimi: discovers `flutter/*.md` under `.agents/rules/` (path-based activation via `/rules`).
Full depth: `.agents/skills/flutter-dart/SKILL.md` and topic files.
