## 2.0.0-dev.3

Phase 2 delivery: Primitives (Interaction / Portal / Overlay).

### Added
- `AntInteractionDetector`: unifies hover / focus / pressed / disabled into `Set<WidgetState>`, exposes `onTap` / `onHover`, supports Enter/Space keyboard activation and disabled-aware cursor. Widget tree `Shortcuts > Actions > Focus > MouseRegion > GestureDetector` (deliberate deviation from spec's suggested order — Shortcuts-outermost is the Flutter idiom for Intent dispatch).
- `AntPlacement` enum with 12 placements and `AntPlacementAnchors` table aligned to AntD v5 `Tooltip`.
- `AntPortal`: anchored overlay primitive backed by Flutter 3.10+ `OverlayPortal` with `schedulerPhase`-aware show/hide. Once-per-mount placement flip when `autoAdjustOverflow: true`.
- `AntOverlaySlot` + `OverlayEntryHandle` + `AntOverlayManager`: per-(Overlay × slot) host model. `message` / `notification` are list slots with FIFO vertical stacking (8 px gap, 24 px margin); `modal` / `drawer` are singletons sharing a translucent barrier (`Color(0x80000000)`).

### Deviations from plan
- Portal lifecycle uses `OverlayPortal` instead of manual `OverlayEntry` management — plan's naive `didChangeDependencies → Overlay.insert` hit `setState during build`. `OverlayPortal` + post-frame scheduling is the robust Flutter-3.10+ pattern.
- Plan Task 7 `overlay removed on dispose` test reused `_host` closure in a way that broke `initialEntries` semantics; revised to replace the full widget tree.
- Placement geometry implementation: `Positioned(left:0, top:0)` wrapping the follower (so follower sizes to its child) instead of `Positioned.fill + Align` (which would stretch follower to full screen and break anchor math).

### Constraints
- Primitives do not consume `AntTheme` / tokens. Visuals (colors, shadows, animations, arrows, dismiss triggers) are Phase 3+ component responsibility.
- Overlay slots ship without entry/exit animations; animations land with Phase 4 feedback components.
- `AntPortal.onDismiss` is a reserved hook — no built-in tap-outside / ESC / scroll-away.

### Reference
- Spec: `docs/superpowers/specs/2026-04-18-phase-2-primitives-design.md`
- Plan: `docs/superpowers/plans/2026-04-18-phase-2-primitives.md`

---

## 2.0.0-dev.2

Phase 1 delivery: Design Token system.

### Added
- `AntSeedToken` / `AntMapToken` / `AntAliasToken` three-layer tokens (14 / 19 / 25 fields).
- `AntThemeAlgorithm` interface and `DefaultAlgorithm` implementation.
- `AntThemeData` aggregate with eager map/alias computation (factory constructor).
- `AntConfigProvider` InheritedWidget + `AntTheme` syntax sugar.
- `AntApp` minimal shell (WidgetsApp + AntConfigProvider).
- Foundation color utilities (HSV conversion, weighted mix, 10-shade palette generation). Palette output matches `@ant-design/colors` v7 for `#1677FF` / `#52C41A` / `#FAAD14` within 1 RGB unit per channel.
- `example/main.dart` renders a primary color demo.

### Naming convention
- All public fields use full English words (`Background`, `Small`, `Large`, `ExtraLarge`) rather than AntD's abbreviated forms (`Bg`, `SM`, `LG`, `XL`). dartdoc on each alias / map field cross-references the original AntD name.

### API surface (new Color API)
- Implementation uses Flutter 3.38's new Color API (`.r/.g/.b/.a` double + `.toARGB32()`). No `.red/.green/.blue/.alpha/.value` usage.

### Reference
- Spec: `docs/superpowers/specs/2026-04-18-phase-1-token-system-design.md`
- Plan: `docs/superpowers/plans/2026-04-18-phase-1-token-system.md`

---

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
