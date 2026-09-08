# Flutter Resources 2

An app-oriented Flutter utility package that combines the smaller packages
from [Flutter Resources](https://github.com/icarohs7/flutter-resources) and
adds reusable widgets, persistence, dialogs, lists, rendering, and application
helpers.

[![Actions Status](https://github.com/icarohs7/flutter-resources2/workflows/build/badge.svg)](https://github.com/icarohs7/flutter-resources2/actions)
[![GitHub license](https://img.shields.io/github/license/icarohs7/flutter-resources2.svg)](https://github.com/icarohs7/flutter-resources2/blob/master/LICENSE)
[![codecov](https://codecov.io/gh/icarohs7/flutter-resources2/branch/master/graph/badge.svg)](https://codecov.io/gh/icarohs7/flutter-resources2)

This package is intentionally less stable than the smaller packages. Public
APIs may change between releases, so applications that need reproducible
builds should pin a Git ref.

## When to use which package

| Need | Recommended package |
| --- | --- |
| One focused utility, such as search or stream helpers | A package from [`flutter-resources`](https://github.com/icarohs7/flutter-resources) |
| A broad shared toolkit with a single import | `flutter_resources2` |
| The smallest possible dependency graph | A focused package from `flutter-resources` |

## Requirements

- Dart `>=3.13.0 <4.0.0`
- Flutter `3.47.0` (the version used by CI)
- Git access to this repository and its `flutter-resources` dependencies

## Installation

Add the package from Git:

```yaml
dependencies:
  flutter_resources2:
    git:
      url: https://github.com/icarohs7/flutter-resources2.git
```

Then fetch dependencies and import the public entrypoint:

```sh
flutter pub get
```

```dart
import 'package:flutter_resources2/flutter_resources2.dart';
```

The main entrypoint re-exports selected APIs from `core_resources`,
`masked_text_resources`, `reactor_fp_resources`, `search_resources`,
`stream_resources`, and `value_notifier_resources`, in addition to the APIs
listed below.

## Feature map

| Area | Representative APIs | Source |
| --- | --- | --- |
| Form and input widgets | `DateFormField`, `DateTimeFormField`, `TimeFormField`, `PinInput`, `NumericKeyboard` | [`lib/src/widgets`](lib/src/widgets) |
| Common UI | `SpeedDial`, `NBottomNav`, `NImage`, `NProvider`, `DisposeAware` | [`lib/src/widgets`](lib/src/widgets) |
| Persistence | `NPersistedField*`, `NSecurePersistedField*` | [`lib/src/storage`](lib/src/storage) |
| Search and dialogs | `NInputSearchBar`, `NBasicSearchDelegate`, `NSelectionPage`, `DateTimePickerDialog` | [`lib/src/search_resources`](lib/src/search_resources), [`lib/src/dialogs`](lib/src/dialogs) |
| Lists and failures | `NListView`, `NSliverList`, `NException`, `NFailure` | [`lib/src/listresources`](lib/src/listresources), [`lib/src/failure`](lib/src/failure) |
| Rendering and application helpers | `HtmlRender`, `Chat`, `ChatBubble`, `ShareParams`, image utilities | [`lib/src/htmlrenderresources`](lib/src/htmlrenderresources), [`lib/src/chatresources`](lib/src/chatresources), [`lib/src/adapters`](lib/src/adapters) |

## Quick start

For example, `PinInput` renders a PIN from a caller-owned controller:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';

final pinController = TextEditingController();

PinInput(
  controller: pinController,
  length: 6,
  obscureText: true,
)
```

Initialize persisted fields before using them:

```dart
await NPersistedField.init();
```

The caller owns and must dispose `pinController`, as with any
`TextEditingController`.

## Platform-specific entrypoint

The optional [`flutter_resources2_mobile_only.dart`](lib/flutter_resources2_mobile_only.dart)
entrypoint exposes helpers that use `dart:io`:

```dart
import 'package:flutter_resources2/flutter_resources2_mobile_only.dart';
```

Do not import this entrypoint from code that must compile for the web. The
portable APIs are available from `flutter_resources2.dart`.

## Development

From the repository root, run the CI-equivalent workflow:

```sh
dart run build.dart
```

It fetches dependencies, runs code generation, analyzes the package, and runs
tests with coverage. For a focused local cycle:

```sh
flutter pub get
dart run build_runner build
flutter analyze
flutter test
```

Generated files are part of the package's checked-in source. Contributors
should regenerate them after changing Freezed or JSON-serializable models.

## Licensing

See [`LICENSE`](LICENSE) for the repository license and third-party attribution.
