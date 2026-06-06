# Code generation

Never edit generated files. Suffixes: `.g.dart`, `.freezed.dart`.

| Tool | Purpose | Output |
|------|---------|--------|
| `freezed` | Immutable models, sealed unions | `*.freezed.dart` |
| `json_serializable` | JSON serialization | `*.g.dart` |
| `mockito` | Test mocks | `*.mocks.dart` |

Regenerate:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
# or: dart run build.dart (full CI pipeline)
```

Current freezed models: `chat_message`, `n_search_suggestion` — follow their
`@freezed` / `part` file layout when adding new models.
