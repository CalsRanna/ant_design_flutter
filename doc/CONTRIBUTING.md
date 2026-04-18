# Contributing

Thanks for wanting to help! A full guide is under construction — below is the
working scaffold that reflects current state (Phase 0).

## Development setup

1. Flutter 3.38+ / Dart 3.10+ installed and on PATH
2. Clone the repo, then run from the repo root:
   ```bash
   flutter pub get
   flutter analyze --fatal-infos
   flutter test
   ```
3. To run the widgetbook gallery:
   ```bash
   cd gallery
   flutter pub get
   flutter run -d chrome
   ```

## Before you submit a PR

- `flutter analyze --fatal-infos` must be clean
- `flutter test` must pass
- `dart format --set-exit-if-changed .` must pass
- If your change affects the gallery, run `flutter analyze` in `gallery/` too
- CI will enforce all of the above

## Design alignment

Before proposing a new component or widget, check
[docs/superpowers/specs/2026-04-18-antdf-2.0-design.md](../docs/superpowers/specs/2026-04-18-antdf-2.0-design.md).
Components outside the MVP 17 belong on the 2.1+ roadmap and need a
design discussion before implementation.

## Phased development

Work is tracked in [doc/PROGRESS.md](PROGRESS.md) against the plans under
`docs/superpowers/plans/`. Each Phase has its own plan — ask before starting
cross-phase work.

## Commit style

Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `ci:`, `refactor:`,
`test:`). Scope with the affected area, e.g. `feat(button):`, `chore(pubspec):`.
