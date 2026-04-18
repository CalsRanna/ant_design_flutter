## 2.0.0-dev.1

Phase 0 scaffold. No components yet — this release delivers the rewrite's
engineering ground truth.

### Breaking (vs 1.x)
- Complete API redesign; 1.x users should stay on `0.0.1+5` (tag `v1-legacy`).
- Library no longer re-exports `package:flutter/widgets.dart` — consumers import
  Flutter widgets directly.
- Minimum Flutter raised to 3.38 / Dart to 3.10.

### Added
- 2.0 design document at `docs/superpowers/specs/`.
- `very_good_analysis` strict lint profile.
- GitHub Actions CI (analyze, format, test).
- widgetbook gallery subproject scaffold at `gallery/`.
- Scaffolded docs: `doc/DESIGN.md`, `MIGRATION.md`, `CONTRIBUTING.md`, `PROGRESS.md`.

### Removed
- All 1.x component sources (`lib/src/`).
- Runtime dependencies `dotted_border` and `flutter_spinkit`.
- Legacy `.packages` file.

### Reference
- Design: `docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`
- Phase 0 plan: `docs/superpowers/plans/2026-04-18-phase-0-scaffold.md`

---

## 0.0.1+5

- Redesign color of button

## 0.0.1+4

- Upgrade flutter_lints to 2.0
- Some feature of Button widget

## 0.0.1+3

- Hide raw MenuItem to avoid comflict since Flutter 3.0 brings PlatformMenuBar
- Some feature of widgets

## 0.0.1+2

- Remove 'Ant' prefix of some widgets and hide the same name raw widget to avoid comflict.

## 0.0.1+1

- Update README.md.

## 0.0.1

- Build some common widgets.
