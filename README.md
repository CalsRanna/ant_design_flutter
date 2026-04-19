<p align="center">
  <a href="https://github.com/CalsRanna/ant_design_flutter">
    <img width="200" src="https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg">
  </a>
</p>

<h1 align="center">Ant Design Flutter 2.0</h1>

<div align="center">

A Flutter component library aligned with **Ant Design v5**, designed for web
and desktop applications. Pure Dart, zero runtime dependencies.

![Status](https://img.shields.io/badge/STATUS-2.0--dev-orange?style=for-the-badge&color=orange)
![Pub Version](https://img.shields.io/pub/v/ant_design_flutter?style=for-the-badge&include_prereleases)
![GitHub](https://img.shields.io/github/license/CalsRanna/ant_design_flutter?style=for-the-badge)

</div>

---

> **⚠️ Development status**
>
> 2.0 is a full rewrite. The `main` branch targets `2.0.0-dev.x` releases —
> no components have landed yet. For a stable (but unmaintained) 1.x release
> see tag `v1-legacy` or version `0.0.1+5`.
>
> Roadmap and design live in
> [`docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`](docs/superpowers/specs/2026-04-18-antdf-2.0-design.md).

## ✨ Features (MVP goals)

- 🎯 Aligned with Ant Design v5 design language
- 🖥 Web + desktop first (Windows / macOS / Linux / Web); mobile out of scope
- 🎨 Token-based theming (Seed → Map → Alias) compatible with `theme.algorithm` extension
- 📦 Zero runtime dependencies — pure Dart on top of `package:flutter/widgets.dart`
- 🌐 Built-in `zh_CN` and `en_US` locales
- 🧩 17 core components in MVP (Button, Input, Select, DatePicker, Form, Table, and more)

## 📦 Installation

**Not yet on pub.dev for 2.0.** While 2.0 is in development, pin to git:

```yaml
dependencies:
  ant_design_flutter:
    git:
      url: https://github.com/CalsRanna/ant_design_flutter
      ref: main
```

Once `2.0.0-dev.2` ships (Phase 3 complete) it will be published to pub.dev.

## 🔨 Usage

Components land in subsequent phases — see
[`doc/PROGRESS.md`](doc/PROGRESS.md) for current status.

## 🎨 Using icon fonts

`ant_design_flutter` **does not bundle an icon font**. `AntIcon` accepts any
`IconData` you pass in. Two common options:

- Install a community icon package — e.g. `ant_icons_plus`:

  ```yaml
  dependencies:
    ant_design_flutter: ^2.0.0-dev.4
    ant_icons_plus: ^x.y.z
  ```

  ```dart
  import 'package:ant_icons_plus/ant_icons_plus.dart';

  AntIcon(AntIcons.home);
  ```

- Author your own `IconData` constants against a custom TrueType subset and
  pass them to `AntIcon`. Remember to set `fontPackage` on the `IconData`
  so your package's font ships to downstream users.

This trade-off is intentional: shipping a frozen icon subset turned out to
be maintenance-heavy for the project's spare-time budget. See
[`docs/superpowers/specs/2026-04-19-phase-3-atoms-design.md`](docs/superpowers/specs/2026-04-19-phase-3-atoms-design.md)
§4 for the full decision record.

## 🖥 Requirements

- Flutter `>= 3.38.0`
- Dart `>= 3.10.0`

## 🗺 Migration from 1.x

2.0 is a breaking rewrite. See
[`doc/MIGRATION.md`](doc/MIGRATION.md). If you are on 1.x and do not plan to
migrate, pin to `ant_design_flutter: 0.0.1+5` (tag `v1-legacy`).

## 🤝 Contributing

See [`doc/CONTRIBUTING.md`](doc/CONTRIBUTING.md).

## 📄 License

[MIT](LICENSE)
