# Storage

Applies to `lib/src/storage/`.

## Persisted fields

- `NBasePersistedField<T>` — abstract Hive-backed field with serialize/deserialize hooks.
- `NPersistedField<T>` — standard Hive box storage.
- `NSecurePersistedField<T>` — `flutter_secure_storage` variant.

## Patterns

- Fields expose `listenable` (reactive container) for UI binding.
- Use `reactor_fp_resources` / `stream_resources` patterns already in the base class.
- Keys must be stable — changing a key orphans stored data for app users.

## Tests

- Tests under `test/storage/` use mocks for box/storage implementations.
- Run `flutter test test/storage/` after storage changes.
