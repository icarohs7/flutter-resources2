# Project reference

Shared Flutter utility library for reuse across Flutter apps. Single package —
not a monorepo.

## Repository layout

```
lib/
  flutter_resources2.dart          # main barrel export
  flutter_resources2_mobile_only.dart
  src/
    adapters/          # wrapper types
    animationresources/
    chatresources/     # freezed models
    classes/           # NMessenger, NWrapper, Disposable
    dialogs/
    extensions/        # String, Map, Iterable, Context, Widget, FP, ...
    failure/             # NFailure, NException
    htmlrenderresources/
    listresources/
    searchresources/   # extends search_resources package
    storage/             # Hive persisted fields
    types/
    utils/
    widgets/             # reusable form fields and UI helpers
test/                    # mirrors lib/src structure
build.dart               # CI: pub get, build_runner, analyze, test --coverage
```

## Key conventions

- 100-char lines (`analysis_options.yaml` → `formatter.page_width: 100`).
- `prefer_relative_imports` within `lib/src/`.
- Each feature folder has a barrel file (e.g. `widgets/widgets.dart`) — export new
  public APIs from the barrel and from `flutter_resources2.dart` when appropriate.
- Depends on sibling git packages under `icarohs7/flutter-resources` (`core_resources`,
  `search_resources`, `reactor_fp_resources`, etc.).

## Verification

```bash
dart format .
flutter analyze
flutter test
# or full CI script:
dart run build.dart
```

## Public API changes

Breaking changes affect all consuming apps. When renaming or removing exports:

1. Search this repo (`lib/`, `test/`).
2. Search downstream repos for imports from `package:flutter_resources2/`.
3. Prefer deprecation over hard removal when possible.
