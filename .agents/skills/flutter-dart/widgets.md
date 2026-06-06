# Widgets

Applies to `lib/src/widgets/` and widget-heavy modules (`chatresources/`, `listresources/`).

## Patterns

- Form fields (`DateFormField`, `ItemSelectFormField`, etc.) wrap Material inputs with
  shared validation and styling — match siblings when adding new fields.
- `NProvider<T>` injects values down the tree; `DisposeAware` handles lifecycle cleanup.
- `NImage` wraps `extended_image` with project load-state handling — reuse its patterns
  for image widgets.
- Prefer `HookWidget` for new widgets unless matching an existing `StatefulWidget` base.

## Tests

- Widget tests live under `test/widgets/` (or the matching module folder).
- Use `flutter_test` + `mocktail` / `mockito` as neighboring tests do.
- Pump widgets with minimal scaffolding; avoid pulling in full app DI.

## Exports

New public widgets: add to `widgets/widgets.dart` and consider exporting from
`flutter_resources2.dart` if broadly useful.
