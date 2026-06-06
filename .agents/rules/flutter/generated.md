---
name: Flutter generated outputs
description: Never hand-edit generated Dart outputs in flutter_resources2
paths:
  - "**/*.g.dart"
  - "**/*.freezed.dart"
  - "**/*.mocks.dart"
priority: 90
---

# Generated outputs

Do **not** hand-edit:

- `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`

Regenerate with `flutter pub run build_runner build --delete-conflicting-outputs`
or `dart run build.dart`.

Setup: `.agents/skills/flutter-dart/codegen.md`
