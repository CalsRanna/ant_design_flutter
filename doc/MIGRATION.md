# Migration Guide: 1.x → 2.0

> Status: **draft skeleton**. Full migration guide will be completed before
> the 2.0.0 stable release.

## Breaking: complete API redesign

2.0 is a full rewrite. 1.x and 2.x share no API surface. Projects on 1.x
should stay on `ant_design_flutter: ^0.0.1+5` (tag `v1-legacy`) until they
are ready for the rewrite.

## What changed at a glance

| Area | 1.x | 2.0 |
| --- | --- | --- |
| Package name | `ant_design_flutter` | `ant_design_flutter` (same) |
| Version | `0.0.1+x` | `2.0.0+` |
| Minimum SDK | Flutter 1.17 | Flutter 3.38 / Dart 3.10 |
| Widget naming | `Button`, `Icon`, `Table`, ... | `AntButton`, `AntIcon`, `AntTable`, ... |
| Library export | `export 'package:flutter/widgets.dart' hide ...` (hijacks Flutter namespace) | Only exports this library's symbols |
| Theme | Hard-coded `Colors.blue_6` etc. | `AntTheme.of(context).alias.colorPrimary` via token system |
| Form | Each widget self-manages state | `AntFormController` + `AntFormItem` |
| Icons | Material Icons aliased | Bundled AntD icon font (`AntIcons.*`) |

## Component-by-component changes

_TODO: populate once components land starting Phase 3._

## Manual migration steps

_TODO: write when the component mapping above is concrete._

## Dropped features

_TODO: list widgets that did not make the MVP 17 and their 2.1+ timeline._
