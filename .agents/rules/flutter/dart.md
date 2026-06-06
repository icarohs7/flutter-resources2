---
name: Flutter Dart guardrails
description: flutter_resources2 library guardrails for lib/ and test/
paths:
  - lib/**/*.dart
  - test/**/*.dart
priority: 100
---

# Flutter Dart (flutter_resources2)

Before the **first** `.dart` change in this task:

1. Read `.agents/skills/flutter-dart/SKILL.md`
2. Read every topic file its router lists for paths you will touch
3. After a long non-Dart detour, re-read the router and reopen relevant topic files

## Non-negotiables

- Run `dart format .` first, then `flutter analyze` — never skip formatting
- Prefer `HookWidget` + `flutter_hooks` over `StatefulWidget` for new widgets
- No network or heavy work inside `build()`
- **English** identifiers; **pt-BR** only for user-facing strings when appropriate
- **Private widget classes**, not private methods returning `Widget`
- **Constructor-promoted fields** declared above the constructor
- Keep APIs library-generic — no app routes, URLs, or business rules
- Export new public APIs through module barrels and `flutter_resources2.dart` when needed

Depth: `.agents/skills/flutter-dart/` topic files per the skill router.
