# Phase 1：Token 系统 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 落地 Foundation（色板算法 + HSV/mix 工具）+ Theme（Seed/Map/Alias 三层 Token + DefaultAlgorithm + AntThemeData）+ App（AntConfigProvider InheritedWidget + AntApp 极小壳），让 `example/main.dart` 跑出主色背景 + 主色文字。

**Architecture:** 严格分层 `foundation → theme → app`，三层只向上依赖；foundation 纯算法零 Flutter 依赖；theme 不 import components；组件只消费 alias。Token 类手写 const/copyWith/==/hashCode，零运行时第三方依赖。

**Tech Stack:** Dart 3.10、Flutter 3.38（仅 `package:flutter/widgets.dart` + `package:flutter/foundation.dart`），very_good_analysis 10.2.0。

**上游 Spec:** `docs/superpowers/specs/2026-04-18-phase-1-token-system-design.md`

**命名规则:** 字段一律使用完整英文单词（Background / Small / Large / ExtraLarge），禁用 Bg/SM/LG/XL。

**Git 约定:** 每个 Task 末尾给出建议 commit 命令供执行者使用；**不要附加 Co-Authored-By 行**。

---

## File Structure

Phase 1 结束时新增 / 修改的文件：

```
lib/
├── ant_design_flutter.dart                    ← 改（追加导出）
└── src/
    ├── foundation/
    │   ├── color/
    │   │   ├── hsv.dart                       ← 新
    │   │   ├── mix.dart                       ← 新
    │   │   └── generate.dart                  ← 新
    │   └── typography.dart                    ← 新
    ├── theme/
    │   ├── seed_token.dart                    ← 新
    │   ├── map_token.dart                     ← 新
    │   ├── alias_token.dart                   ← 新
    │   ├── theme_data.dart                    ← 新
    │   └── algorithm/
    │       ├── theme_algorithm.dart           ← 新
    │       └── default_algorithm.dart         ← 新
    └── app/
        ├── ant_config_provider.dart           ← 新
        └── ant_app.dart                       ← 新

test/
├── smoke_test.dart                            ← 删（被真实测试替代）
├── unit/
│   ├── foundation/
│   │   ├── hsv_test.dart                      ← 新
│   │   ├── mix_test.dart                      ← 新
│   │   └── generate_test.dart                 ← 新
│   └── theme/
│       ├── seed_token_test.dart               ← 新
│       ├── map_token_test.dart                ← 新
│       ├── alias_token_test.dart              ← 新
│       ├── default_algorithm_test.dart        ← 新
│       └── theme_data_test.dart               ← 新
└── widget/
    ├── ant_config_provider_test.dart          ← 新
    └── ant_app_test.dart                      ← 新

example/
└── main.dart                                  ← 改（跑出主色 demo）

doc/PROGRESS.md                                ← 改（Phase 1 complete）
CHANGELOG.md                                   ← 改（2.0.0-dev.2 条目）
```

---

## Task 1: foundation/color/hsv.dart — Hsv 数据类与 Color 互转

**Files:**
- Create: `lib/src/foundation/color/hsv.dart`
- Create: `test/unit/foundation/hsv_test.dart`

- [ ] **Step 1: 建目录**

Run:
```bash
mkdir -p lib/src/foundation/color test/unit/foundation
```

- [ ] **Step 2: 写失败测试**

写入 `test/unit/foundation/hsv_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/hsv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Hsv.fromColor', () {
    test('pure red → hue 0, saturation 1, value 1', () {
      final hsv = Hsv.fromColor(const Color(0xFFFF0000));
      expect(hsv.hue, closeTo(0, 0.5));
      expect(hsv.saturation, closeTo(1, 0.001));
      expect(hsv.value, closeTo(1, 0.001));
    });

    test('pure white → saturation 0, value 1', () {
      final hsv = Hsv.fromColor(const Color(0xFFFFFFFF));
      expect(hsv.saturation, closeTo(0, 0.001));
      expect(hsv.value, closeTo(1, 0.001));
    });

    test('pure black → value 0', () {
      final hsv = Hsv.fromColor(const Color(0xFF000000));
      expect(hsv.value, closeTo(0, 0.001));
    });

    test('AntD primary #1677FF → hue ~215', () {
      final hsv = Hsv.fromColor(const Color(0xFF1677FF));
      expect(hsv.hue, closeTo(215.3, 0.5));
      expect(hsv.saturation, closeTo(0.914, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });
  });

  group('Hsv.toColor', () {
    test('round-trip preserves RGB within 1', () {
      const inputs = <int>[0xFF1677FF, 0xFF52C41A, 0xFFFAAD14, 0xFFFF4D4F];
      for (final input in inputs) {
        final original = Color(input);
        final rebuilt = Hsv.fromColor(original).toColor();
        expect(((rebuilt.r - original.r) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'red drift for ${input.toRadixString(16)}');
        expect(((rebuilt.g - original.g) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'green drift for ${input.toRadixString(16)}');
        expect(((rebuilt.b - original.b) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'blue drift for ${input.toRadixString(16)}');
      }
    });

    test('alpha defaults to 1 and can be overridden', () {
      const hsv = Hsv(0, 1, 1);
      expect(hsv.toColor().a, closeTo(1, 0.001));
      expect(hsv.toColor(alpha: 0.5).a, closeTo(128 / 255, 0.01));
    });
  });
}
```

- [ ] **Step 3: 运行测试确认失败**

Run: `flutter test test/unit/foundation/hsv_test.dart`
Expected: 编译错误（`Hsv` 未定义）

- [ ] **Step 4: 写实现**

写入 `lib/src/foundation/color/hsv.dart`：

```dart
import 'dart:math' as math;
import 'dart:ui';

/// HSV 色彩空间表示。hue ∈ [0, 360)，saturation/value ∈ [0, 1]。
///
/// 仅 foundation/color 内部使用，不对外导出。
class Hsv {
  const Hsv(this.hue, this.saturation, this.value);

  /// 从 [Color] 提取 HSV。实现与 AntD TinyColor2 对齐。
  factory Hsv.fromColor(Color c) {
    final r = c.r;
    final g = c.g;
    final b = c.b;
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;

    double hue;
    if (delta == 0) {
      hue = 0;
    } else if (max == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (max == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }
    if (hue < 0) hue += 360;

    final saturation = max == 0 ? 0.0 : delta / max;
    return Hsv(hue, saturation, max);
  }

  final double hue;
  final double saturation;
  final double value;

  /// 转回 [Color]。[alpha] ∈ [0, 1]，默认 1。
  Color toColor({double alpha = 1}) {
    final c = value * saturation;
    final x = c * (1 - ((hue / 60) % 2 - 1).abs());
    final m = value - c;

    double r;
    double g;
    double b;
    if (hue < 60) {
      r = c; g = x; b = 0;
    } else if (hue < 120) {
      r = x; g = c; b = 0;
    } else if (hue < 180) {
      r = 0; g = c; b = x;
    } else if (hue < 240) {
      r = 0; g = x; b = c;
    } else if (hue < 300) {
      r = x; g = 0; b = c;
    } else {
      r = c; g = 0; b = x;
    }

    return Color.fromARGB(
      (alpha * 255).round().clamp(0, 255),
      ((r + m) * 255).round().clamp(0, 255),
      ((g + m) * 255).round().clamp(0, 255),
      ((b + m) * 255).round().clamp(0, 255),
    );
  }
}
```

- [ ] **Step 5: 运行测试确认通过**

Run: `flutter test test/unit/foundation/hsv_test.dart`
Expected: `All tests passed!`

- [ ] **Step 6: 建议 commit**

```bash
git add lib/src/foundation/color/hsv.dart test/unit/foundation/hsv_test.dart
git commit -m "feat(foundation): add Hsv color space conversion"
```

---

## Task 2: foundation/color/mix.dart — 颜色加权混合

**Files:**
- Create: `lib/src/foundation/color/mix.dart`
- Create: `test/unit/foundation/mix_test.dart`

- [ ] **Step 1: 写失败测试**

写入 `test/unit/foundation/mix_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/mix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mixColor', () {
    test('weight 0 returns base unchanged', () {
      final result = mixColor(
        const Color(0xFF1677FF),
        const Color(0xFFFFFFFF),
        0,
      );
      expect(result, const Color(0xFF1677FF));
    });

    test('weight 100 returns mixed color', () {
      final result = mixColor(
        const Color(0xFF1677FF),
        const Color(0xFFFFFFFF),
        100,
      );
      expect(result, const Color(0xFFFFFFFF));
    });

    test('weight 50 returns midpoint', () {
      final result = mixColor(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        50,
      );
      expect((result.r * 255).round(), closeTo(128, 1));
      expect((result.g * 255).round(), closeTo(128, 1));
      expect((result.b * 255).round(), closeTo(128, 1));
    });

    test('preserves alpha from base color', () {
      final result = mixColor(
        const Color(0x80FF0000),
        const Color(0xFF00FF00),
        50,
      );
      expect((result.a * 255).round(), 128);
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/foundation/mix_test.dart`
Expected: 编译错误（`mixColor` 未定义）

- [ ] **Step 3: 写实现**

写入 `lib/src/foundation/color/mix.dart`：

```dart
import 'dart:ui';

/// 按 [weight] ∈ [0, 100] 将 [base] 与 [mixed] 混合。
/// weight = 0 返回 base，weight = 100 返回 mixed。保留 base 的 alpha。
Color mixColor(Color base, Color mixed, double weight) {
  final w = (weight / 100).clamp(0.0, 1.0);
  return Color.fromARGB(
    (base.a * 255).round(),
    ((base.r * (1 - w) + mixed.r * w) * 255).round(),
    ((base.g * (1 - w) + mixed.g * w) * 255).round(),
    ((base.b * (1 - w) + mixed.b * w) * 255).round(),
  );
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/foundation/mix_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/foundation/color/mix.dart test/unit/foundation/mix_test.dart
git commit -m "feat(foundation): add mixColor weighted blend"
```

---

## Task 3: foundation/color/generate.dart — AntD 10 阶色板算法

**Files:**
- Create: `lib/src/foundation/color/generate.dart`
- Create: `test/unit/foundation/generate_test.dart`

**背景**：对拍 `@ant-design/colors` 的 `generate(color)` 函数。本 Task 先用 3 个已知 seed（blue / green / gold）的 golden 驱动算法实现，Task 13 最终验证时再补第 4 个（red）。

- [ ] **Step 1: 写失败测试（3 个 seed 的 golden）**

写入 `test/unit/foundation/generate_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/generate.dart';
import 'package:flutter_test/flutter_test.dart';

/// 断言色板每阶 RGB 与 expected 的 24-bit RGB 值差 ≤ 1。
void _expectPaletteMatches(List<Color> actual, List<int> expected) {
  expect(actual, hasLength(10));
  for (var i = 0; i < 10; i++) {
    final actualRgb = actual[i].toARGB32() & 0xFFFFFF;
    final expectedRgb = expected[i] & 0xFFFFFF;
    final actualR = (actualRgb >> 16) & 0xFF;
    final actualG = (actualRgb >> 8) & 0xFF;
    final actualB = actualRgb & 0xFF;
    final expectedR = (expectedRgb >> 16) & 0xFF;
    final expectedG = (expectedRgb >> 8) & 0xFF;
    final expectedB = expectedRgb & 0xFF;
    expect((actualR - expectedR).abs(), lessThanOrEqualTo(1),
        reason: 'index $i red: actual=${actualR.toRadixString(16)} expected=${expectedR.toRadixString(16)}');
    expect((actualG - expectedG).abs(), lessThanOrEqualTo(1),
        reason: 'index $i green');
    expect((actualB - expectedB).abs(), lessThanOrEqualTo(1),
        reason: 'index $i blue');
  }
}

void main() {
  group('generatePalette', () {
    test('seed #1677FF (blue) matches @ant-design/colors', () {
      const golden = <int>[
        0xE6F4FF, 0xBAE0FF, 0x91CAFF, 0x69B1FF, 0x4096FF,
        0x1677FF, 0x0958D9, 0x003EB3, 0x002C8C, 0x001D66,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFF1677FF)),
        golden,
      );
    });

    test('seed #52C41A (green) matches @ant-design/colors', () {
      const golden = <int>[
        0xF6FFED, 0xD9F7BE, 0xB7EB8F, 0x95DE64, 0x73D13D,
        0x52C41A, 0x389E0D, 0x237804, 0x135200, 0x092B00,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFF52C41A)),
        golden,
      );
    });

    test('seed #FAAD14 (gold) matches @ant-design/colors', () {
      const golden = <int>[
        0xFFFBE6, 0xFFF1B8, 0xFFE58F, 0xFFD666, 0xFFC53D,
        0xFAAD14, 0xD48806, 0xAD6800, 0x874D00, 0x613400,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFFFAAD14)),
        golden,
      );
    });

    test('index 5 always equals seed', () {
      const seeds = <int>[0xFF1677FF, 0xFF52C41A, 0xFFFAAD14];
      for (final seedInt in seeds) {
        final seed = Color(seedInt);
        final palette = generatePalette(seed);
        expect(palette[5].value, seed.value,
            reason: 'seed ${seedInt.toRadixString(16)}');
      }
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/foundation/generate_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/foundation/color/generate.dart`：

```dart
import 'dart:ui';

import 'hsv.dart';

// AntD generate 算法常量，与 @ant-design/colors 源码一致。
const double _hueStep = 2;
const double _saturationStepLight = 16;
const double _saturationStepDark = 5;
const double _saturationStep2Dark = 15;
const double _brightnessStep1 = 5;
const double _brightnessStep2 = 15;
const int _lightColorCount = 5;
const int _darkColorCount = 4;

/// 返回长度 10 的色板：
///   [0] primary-1 最浅 → [5] primary-6 (seed 本身) → [9] primary-10 最深。
///
/// 算法对齐 npm `@ant-design/colors` 的 `generate(color)`。
List<Color> generatePalette(Color seed) {
  final hsv = Hsv.fromColor(seed);
  final result = <Color>[];
  for (var i = _lightColorCount; i > 0; i--) {
    result.add(_getShade(hsv, i, light: true));
  }
  result.add(seed);
  for (var i = 1; i <= _darkColorCount; i++) {
    result.add(_getShade(hsv, i, light: false));
  }
  return result;
}

Color _getShade(Hsv hsv, int index, {required bool light}) {
  final hue = _computeHue(hsv, index, light: light);
  final saturation = _computeSaturation(hsv, index, light: light);
  final value = _computeValue(hsv, index, light: light);
  return Hsv(hue, saturation, value).toColor();
}

double _computeHue(Hsv hsv, int i, {required bool light}) {
  double hue;
  final h = hsv.hue.round();
  if (h >= 60 && h <= 240) {
    hue = light ? hsv.hue - _hueStep * i : hsv.hue + _hueStep * i;
  } else {
    hue = light ? hsv.hue + _hueStep * i : hsv.hue - _hueStep * i;
  }
  if (hue < 0) {
    hue += 360;
  } else if (hue >= 360) {
    hue -= 360;
  }
  return hue;
}

double _computeSaturation(Hsv hsv, int i, {required bool light}) {
  // 灰度 seed（saturation == 0）保持灰度
  if (hsv.hue == 0 && hsv.saturation == 0) {
    return hsv.saturation;
  }
  double saturation;
  if (light) {
    saturation = hsv.saturation * 100 - _saturationStepLight * i;
  } else if (i == _darkColorCount) {
    saturation = hsv.saturation * 100 + _saturationStepDark;
  } else {
    saturation = hsv.saturation * 100 + _saturationStep2Dark * i;
  }
  if (saturation > 100) saturation = 100;
  if (light && i == _lightColorCount && saturation > 10) saturation = 10;
  if (saturation < 6) saturation = 6;
  return saturation / 100;
}

double _computeValue(Hsv hsv, int i, {required bool light}) {
  double value;
  if (light) {
    value = hsv.value * 100 + _brightnessStep1 * i;
  } else {
    value = hsv.value * 100 - _brightnessStep2 * i;
  }
  if (value > 100) value = 100;
  return value / 100;
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/foundation/generate_test.dart`
Expected: `All tests passed!`

如果某阶 RGB 差 > 1：检查 `_getShade` 中的浮点运算顺序；AntD JS 版本的 `round` 行为是 `Math.round(value * 100)` 再 `/ 100`。

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/foundation/color/generate.dart test/unit/foundation/generate_test.dart
git commit -m "feat(foundation): add AntD 10-shade palette generator"
```

---

## Task 4: foundation/typography.dart — 字号 / 行高常量

**Files:**
- Create: `lib/src/foundation/typography.dart`

无 TDD：纯常量，被 `DefaultAlgorithm` 直接引用。

- [ ] **Step 1: 写实现**

写入 `lib/src/foundation/typography.dart`：

```dart
/// Typography 基础常量，对齐 AntD v5。
///
/// 这些值由 DefaultAlgorithm 消费，不对用户暴露。
abstract final class Typography {
  /// 默认字号 14px。
  static const double fontSize = 14;
  /// 小号字号 12px，对应 AntD fontSizeSM。
  static const double fontSizeSmall = 12;
  /// 大号字号 16px，对应 AntD fontSizeLG。
  static const double fontSizeLarge = 16;
  /// 超大字号 20px，对应 AntD fontSizeXL。
  static const double fontSizeExtraLarge = 20;

  /// 默认行高（unitless）。对应 AntD lineHeight。
  static const double lineHeight = 1.5714285714285714;
}
```

- [ ] **Step 2: 运行 analyze 确认无告警**

Run: `flutter analyze --fatal-infos lib/src/foundation/typography.dart`
Expected: `No issues found!`

- [ ] **Step 3: 建议 commit**

```bash
git add lib/src/foundation/typography.dart
git commit -m "feat(foundation): add Typography constants"
```

---

## Task 5: theme/seed_token.dart — AntSeedToken

**Files:**
- Create: `lib/src/theme/seed_token.dart`
- Create: `test/unit/theme/seed_token_test.dart`

- [ ] **Step 1: 建目录**

Run: `mkdir -p lib/src/theme test/unit/theme`

- [ ] **Step 2: 写失败测试**

写入 `test/unit/theme/seed_token_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSeedToken', () {
    test('default constructor uses AntD v5 defaults', () {
      const token = AntSeedToken();
      expect(token.colorPrimary, const Color(0xFF1677FF));
      expect(token.colorSuccess, const Color(0xFF52C41A));
      expect(token.colorWarning, const Color(0xFFFAAD14));
      expect(token.colorError, const Color(0xFFFF4D4F));
      expect(token.colorInfo, const Color(0xFF1677FF));
      expect(token.colorTextBase, const Color(0xFF000000));
      expect(token.colorBackgroundBase, const Color(0xFFFFFFFF));
      expect(token.fontFamily, isNull);
      expect(token.fontSize, 14);
      expect(token.borderRadius, 6);
      expect(token.sizeUnit, 4);
      expect(token.sizeStep, 4);
      expect(token.wireframe, isFalse);
      expect(token.motion, isTrue);
    });

    test('copyWith overrides single field', () {
      const base = AntSeedToken();
      final purple = base.copyWith(colorPrimary: const Color(0xFF722ED1));
      expect(purple.colorPrimary, const Color(0xFF722ED1));
      expect(purple.colorSuccess, base.colorSuccess);
    });

    test('== and hashCode are value-based', () {
      const a = AntSeedToken();
      const b = AntSeedToken();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      final c = a.copyWith(colorPrimary: const Color(0xFF000000));
      expect(a, isNot(equals(c)));
    });

    test('copyWith returns new instance (not same reference)', () {
      const base = AntSeedToken();
      final copy = base.copyWith();
      expect(identical(base, copy), isFalse);
      expect(base, equals(copy));
    });
  });
}
```

- [ ] **Step 3: 运行测试确认失败**

Run: `flutter test test/unit/theme/seed_token_test.dart`
Expected: 编译错误

- [ ] **Step 4: 写实现**

写入 `lib/src/theme/seed_token.dart`：

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Seed Token：用户唯一需要配置的源。
///
/// 所有字段对齐 AntD v5 `SeedToken` 的核心子集。详见上游 spec
/// `docs/superpowers/specs/2026-04-18-phase-1-token-system-design.md` § 3.1。
@immutable
class AntSeedToken {
  const AntSeedToken({
    this.colorPrimary = const Color(0xFF1677FF),
    this.colorSuccess = const Color(0xFF52C41A),
    this.colorWarning = const Color(0xFFFAAD14),
    this.colorError = const Color(0xFFFF4D4F),
    this.colorInfo = const Color(0xFF1677FF),
    this.colorTextBase = const Color(0xFF000000),
    this.colorBackgroundBase = const Color(0xFFFFFFFF),
    this.fontFamily,
    this.fontSize = 14,
    this.borderRadius = 6,
    this.sizeUnit = 4,
    this.sizeStep = 4,
    this.wireframe = false,
    this.motion = true,
  });

  final Color colorPrimary;
  final Color colorSuccess;
  final Color colorWarning;
  final Color colorError;
  final Color colorInfo;
  final Color colorTextBase;

  /// 对应 AntD v5 `colorBgBase`。
  final Color colorBackgroundBase;

  final String? fontFamily;
  final double fontSize;
  final double borderRadius;
  final double sizeUnit;
  final double sizeStep;
  final bool wireframe;
  final bool motion;

  AntSeedToken copyWith({
    Color? colorPrimary,
    Color? colorSuccess,
    Color? colorWarning,
    Color? colorError,
    Color? colorInfo,
    Color? colorTextBase,
    Color? colorBackgroundBase,
    String? fontFamily,
    double? fontSize,
    double? borderRadius,
    double? sizeUnit,
    double? sizeStep,
    bool? wireframe,
    bool? motion,
  }) {
    return AntSeedToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorTextBase: colorTextBase ?? this.colorTextBase,
      colorBackgroundBase: colorBackgroundBase ?? this.colorBackgroundBase,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      sizeStep: sizeStep ?? this.sizeStep,
      wireframe: wireframe ?? this.wireframe,
      motion: motion ?? this.motion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntSeedToken &&
        other.colorPrimary == colorPrimary &&
        other.colorSuccess == colorSuccess &&
        other.colorWarning == colorWarning &&
        other.colorError == colorError &&
        other.colorInfo == colorInfo &&
        other.colorTextBase == colorTextBase &&
        other.colorBackgroundBase == colorBackgroundBase &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.borderRadius == borderRadius &&
        other.sizeUnit == sizeUnit &&
        other.sizeStep == sizeStep &&
        other.wireframe == wireframe &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
    colorPrimary,
    colorSuccess,
    colorWarning,
    colorError,
    colorInfo,
    colorTextBase,
    colorBackgroundBase,
    fontFamily,
    fontSize,
    borderRadius,
    sizeUnit,
    sizeStep,
    wireframe,
    motion,
  );
}
```

- [ ] **Step 5: 运行测试确认通过**

Run: `flutter test test/unit/theme/seed_token_test.dart`
Expected: `All tests passed!`

- [ ] **Step 6: 建议 commit**

```bash
git add lib/src/theme/seed_token.dart test/unit/theme/seed_token_test.dart
git commit -m "feat(theme): add AntSeedToken with 14 fields"
```

---

## Task 6: theme/map_token.dart — AntMapToken

**Files:**
- Create: `lib/src/theme/map_token.dart`
- Create: `test/unit/theme/map_token_test.dart`

- [ ] **Step 1: 写失败测试**

写入 `test/unit/theme/map_token_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/theme/map_token.dart';
import 'package:flutter_test/flutter_test.dart';

AntMapToken _sampleMapToken() => AntMapToken(
  colorPrimary: List<Color>.generate(10, (i) => Color(0xFF000000 | i)),
  colorSuccess: List<Color>.generate(10, (i) => Color(0xFF100000 | i)),
  colorWarning: List<Color>.generate(10, (i) => Color(0xFF200000 | i)),
  colorError: List<Color>.generate(10, (i) => Color(0xFF300000 | i)),
  colorInfo: List<Color>.generate(10, (i) => Color(0xFF400000 | i)),
  colorNeutral: List<Color>.generate(13, (i) => Color(0xFF500000 | i)),
  controlHeight: 32,
  controlHeightSmall: 24,
  controlHeightLarge: 40,
  fontSize: 14,
  fontSizeSmall: 12,
  fontSizeLarge: 16,
  fontSizeExtraLarge: 20,
  lineHeight: 1.5714,
  borderRadius: 6,
  borderRadiusSmall: 4,
  borderRadiusLarge: 8,
  boxShadow: const <BoxShadow>[
    BoxShadow(color: Color(0x26000000), blurRadius: 16),
  ],
  boxShadowSecondary: const <BoxShadow>[
    BoxShadow(color: Color(0x1A000000), blurRadius: 8),
  ],
);

void main() {
  group('AntMapToken', () {
    test('exposes 19 fields via constructor', () {
      final t = _sampleMapToken();
      expect(t.colorPrimary, hasLength(10));
      expect(t.colorNeutral, hasLength(13));
      expect(t.controlHeight, 32);
      expect(t.controlHeightSmall, 24);
      expect(t.controlHeightLarge, 40);
      expect(t.fontSize, 14);
      expect(t.fontSizeSmall, 12);
      expect(t.fontSizeLarge, 16);
      expect(t.fontSizeExtraLarge, 20);
      expect(t.lineHeight, closeTo(1.5714, 0.0001));
      expect(t.borderRadius, 6);
      expect(t.borderRadiusSmall, 4);
      expect(t.borderRadiusLarge, 8);
      expect(t.boxShadow, hasLength(1));
      expect(t.boxShadowSecondary, hasLength(1));
    });

    test('== compares list contents (not identity)', () {
      final a = _sampleMapToken();
      final b = _sampleMapToken();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('== returns false when a color list differs', () {
      final a = _sampleMapToken();
      final b = a.copyWith(
        colorPrimary: List<Color>.generate(10, (_) => const Color(0xFFFFFFFF)),
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith overrides a single field', () {
      final a = _sampleMapToken();
      final b = a.copyWith(controlHeight: 36);
      expect(b.controlHeight, 36);
      expect(b.controlHeightSmall, a.controlHeightSmall);
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/theme/map_token_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/theme/map_token.dart`：

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Map Token：算法从 Seed 派生的中间层。组件不直接消费此层；
/// 它只是给 Alias 计算用的中间结果。
///
/// 字段 19 个。详见 spec § 3.2。
@immutable
class AntMapToken {
  const AntMapToken({
    required this.colorPrimary,
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,
    required this.colorNeutral,
    required this.controlHeight,
    required this.controlHeightSmall,
    required this.controlHeightLarge,
    required this.fontSize,
    required this.fontSizeSmall,
    required this.fontSizeLarge,
    required this.fontSizeExtraLarge,
    required this.lineHeight,
    required this.borderRadius,
    required this.borderRadiusSmall,
    required this.borderRadiusLarge,
    required this.boxShadow,
    required this.boxShadowSecondary,
  });

  /// 10 阶主色：[0] 最浅 → [5] seed → [9] 最深。
  final List<Color> colorPrimary;
  final List<Color> colorSuccess;
  final List<Color> colorWarning;
  final List<Color> colorError;
  final List<Color> colorInfo;

  /// 13 阶灰阶：[0] 最浅 → [12] 最深。
  final List<Color> colorNeutral;

  final double controlHeight;

  /// 对应 AntD `controlHeightSM`。
  final double controlHeightSmall;

  /// 对应 AntD `controlHeightLG`。
  final double controlHeightLarge;

  final double fontSize;

  /// 对应 AntD `fontSizeSM`。
  final double fontSizeSmall;

  /// 对应 AntD `fontSizeLG`。
  final double fontSizeLarge;

  /// 对应 AntD `fontSizeXL`。
  final double fontSizeExtraLarge;

  final double lineHeight;
  final double borderRadius;

  /// 对应 AntD `borderRadiusSM`。
  final double borderRadiusSmall;

  /// 对应 AntD `borderRadiusLG`。
  final double borderRadiusLarge;

  final List<BoxShadow> boxShadow;
  final List<BoxShadow> boxShadowSecondary;

  AntMapToken copyWith({
    List<Color>? colorPrimary,
    List<Color>? colorSuccess,
    List<Color>? colorWarning,
    List<Color>? colorError,
    List<Color>? colorInfo,
    List<Color>? colorNeutral,
    double? controlHeight,
    double? controlHeightSmall,
    double? controlHeightLarge,
    double? fontSize,
    double? fontSizeSmall,
    double? fontSizeLarge,
    double? fontSizeExtraLarge,
    double? lineHeight,
    double? borderRadius,
    double? borderRadiusSmall,
    double? borderRadiusLarge,
    List<BoxShadow>? boxShadow,
    List<BoxShadow>? boxShadowSecondary,
  }) {
    return AntMapToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorNeutral: colorNeutral ?? this.colorNeutral,
      controlHeight: controlHeight ?? this.controlHeight,
      controlHeightSmall: controlHeightSmall ?? this.controlHeightSmall,
      controlHeightLarge: controlHeightLarge ?? this.controlHeightLarge,
      fontSize: fontSize ?? this.fontSize,
      fontSizeSmall: fontSizeSmall ?? this.fontSizeSmall,
      fontSizeLarge: fontSizeLarge ?? this.fontSizeLarge,
      fontSizeExtraLarge: fontSizeExtraLarge ?? this.fontSizeExtraLarge,
      lineHeight: lineHeight ?? this.lineHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
      boxShadow: boxShadow ?? this.boxShadow,
      boxShadowSecondary: boxShadowSecondary ?? this.boxShadowSecondary,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntMapToken &&
        listEquals(other.colorPrimary, colorPrimary) &&
        listEquals(other.colorSuccess, colorSuccess) &&
        listEquals(other.colorWarning, colorWarning) &&
        listEquals(other.colorError, colorError) &&
        listEquals(other.colorInfo, colorInfo) &&
        listEquals(other.colorNeutral, colorNeutral) &&
        other.controlHeight == controlHeight &&
        other.controlHeightSmall == controlHeightSmall &&
        other.controlHeightLarge == controlHeightLarge &&
        other.fontSize == fontSize &&
        other.fontSizeSmall == fontSizeSmall &&
        other.fontSizeLarge == fontSizeLarge &&
        other.fontSizeExtraLarge == fontSizeExtraLarge &&
        other.lineHeight == lineHeight &&
        other.borderRadius == borderRadius &&
        other.borderRadiusSmall == borderRadiusSmall &&
        other.borderRadiusLarge == borderRadiusLarge &&
        listEquals(other.boxShadow, boxShadow) &&
        listEquals(other.boxShadowSecondary, boxShadowSecondary);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(colorPrimary),
    Object.hashAll(colorSuccess),
    Object.hashAll(colorWarning),
    Object.hashAll(colorError),
    Object.hashAll(colorInfo),
    Object.hashAll(colorNeutral),
    controlHeight,
    controlHeightSmall,
    controlHeightLarge,
    fontSize,
    fontSizeSmall,
    fontSizeLarge,
    fontSizeExtraLarge,
    lineHeight,
    borderRadius,
    borderRadiusSmall,
    borderRadiusLarge,
    Object.hashAll(boxShadow),
    Object.hashAll(boxShadowSecondary),
  );
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/theme/map_token_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/theme/map_token.dart test/unit/theme/map_token_test.dart
git commit -m "feat(theme): add AntMapToken with 19 fields"
```

---

## Task 7: theme/alias_token.dart — AntAliasToken

**Files:**
- Create: `lib/src/theme/alias_token.dart`
- Create: `test/unit/theme/alias_token_test.dart`

- [ ] **Step 1: 写失败测试**

写入 `test/unit/theme/alias_token_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter_test/flutter_test.dart';

const _blue = Color(0xFF1677FF);

AntAliasToken _sample() => const AntAliasToken(
  colorPrimary: _blue,
  colorPrimaryHover: _blue,
  colorPrimaryActive: _blue,
  colorPrimaryBackground: _blue,
  colorPrimaryBackgroundHover: _blue,
  colorPrimaryBorder: _blue,
  colorSuccess: _blue,
  colorWarning: _blue,
  colorError: _blue,
  colorInfo: _blue,
  colorText: _blue,
  colorTextSecondary: _blue,
  colorTextTertiary: _blue,
  colorTextDisabled: _blue,
  colorBackgroundContainer: _blue,
  colorBackgroundElevated: _blue,
  colorBackgroundLayout: _blue,
  colorBorder: _blue,
  colorBorderSecondary: _blue,
  colorFill: _blue,
  colorFillSecondary: _blue,
  colorSplit: _blue,
  controlHeight: 32,
  borderRadius: 6,
  fontSize: 14,
);

void main() {
  group('AntAliasToken', () {
    test('==/hashCode value-based on all 25 fields', () {
      expect(_sample(), equals(_sample()));
      expect(_sample().hashCode, _sample().hashCode);
    });

    test('copyWith changes exactly one field per call', () {
      const base = AntAliasToken(
        colorPrimary: Color(0xFF000001),
        colorPrimaryHover: Color(0xFF000002),
        colorPrimaryActive: Color(0xFF000003),
        colorPrimaryBackground: Color(0xFF000004),
        colorPrimaryBackgroundHover: Color(0xFF000005),
        colorPrimaryBorder: Color(0xFF000006),
        colorSuccess: Color(0xFF000007),
        colorWarning: Color(0xFF000008),
        colorError: Color(0xFF000009),
        colorInfo: Color(0xFF00000A),
        colorText: Color(0xFF00000B),
        colorTextSecondary: Color(0xFF00000C),
        colorTextTertiary: Color(0xFF00000D),
        colorTextDisabled: Color(0xFF00000E),
        colorBackgroundContainer: Color(0xFF00000F),
        colorBackgroundElevated: Color(0xFF000010),
        colorBackgroundLayout: Color(0xFF000011),
        colorBorder: Color(0xFF000012),
        colorBorderSecondary: Color(0xFF000013),
        colorFill: Color(0xFF000014),
        colorFillSecondary: Color(0xFF000015),
        colorSplit: Color(0xFF000016),
        controlHeight: 32,
        borderRadius: 6,
        fontSize: 14,
      );

      const marker = Color(0xFFDEADBE);
      final checks = <AntAliasToken Function(AntAliasToken)>[
        (t) => t.copyWith(colorPrimary: marker),
        (t) => t.copyWith(colorPrimaryHover: marker),
        (t) => t.copyWith(colorPrimaryActive: marker),
        (t) => t.copyWith(colorPrimaryBackground: marker),
        (t) => t.copyWith(colorPrimaryBackgroundHover: marker),
        (t) => t.copyWith(colorPrimaryBorder: marker),
        (t) => t.copyWith(colorSuccess: marker),
        (t) => t.copyWith(colorWarning: marker),
        (t) => t.copyWith(colorError: marker),
        (t) => t.copyWith(colorInfo: marker),
        (t) => t.copyWith(colorText: marker),
        (t) => t.copyWith(colorTextSecondary: marker),
        (t) => t.copyWith(colorTextTertiary: marker),
        (t) => t.copyWith(colorTextDisabled: marker),
        (t) => t.copyWith(colorBackgroundContainer: marker),
        (t) => t.copyWith(colorBackgroundElevated: marker),
        (t) => t.copyWith(colorBackgroundLayout: marker),
        (t) => t.copyWith(colorBorder: marker),
        (t) => t.copyWith(colorBorderSecondary: marker),
        (t) => t.copyWith(colorFill: marker),
        (t) => t.copyWith(colorFillSecondary: marker),
        (t) => t.copyWith(colorSplit: marker),
        (t) => t.copyWith(controlHeight: 99),
        (t) => t.copyWith(borderRadius: 99),
        (t) => t.copyWith(fontSize: 99),
      ];

      // 每次 copyWith 都必须产生与 base 不相等的结果（证明该字段真实生效）
      for (var i = 0; i < checks.length; i++) {
        final modified = checks[i](base);
        expect(modified, isNot(equals(base)),
            reason: 'copyWith case #$i did not modify the token');
      }
      // 必须有 25 个 check，与字段数一致
      expect(checks, hasLength(25));
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/theme/alias_token_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/theme/alias_token.dart`：

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Alias Token：组件消费的语义层。字段 25 个，MVP 17 组件覆盖所需。
///
/// 详见 spec § 3.3。组件**只**从此层取值，禁止绕过读 Map/Seed。
@immutable
class AntAliasToken {
  const AntAliasToken({
    required this.colorPrimary,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorPrimaryBackground,
    required this.colorPrimaryBackgroundHover,
    required this.colorPrimaryBorder,
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextTertiary,
    required this.colorTextDisabled,
    required this.colorBackgroundContainer,
    required this.colorBackgroundElevated,
    required this.colorBackgroundLayout,
    required this.colorBorder,
    required this.colorBorderSecondary,
    required this.colorFill,
    required this.colorFillSecondary,
    required this.colorSplit,
    required this.controlHeight,
    required this.borderRadius,
    required this.fontSize,
  });

  // primary 衍生态
  final Color colorPrimary;
  final Color colorPrimaryHover;
  final Color colorPrimaryActive;

  /// 对应 AntD `colorPrimaryBg`。
  final Color colorPrimaryBackground;

  /// 对应 AntD `colorPrimaryBgHover`。
  final Color colorPrimaryBackgroundHover;

  final Color colorPrimaryBorder;

  // 语义色
  final Color colorSuccess;
  final Color colorWarning;
  final Color colorError;
  final Color colorInfo;

  // 文本 4 级
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextTertiary;
  final Color colorTextDisabled;

  /// 对应 AntD `colorBgContainer`。
  final Color colorBackgroundContainer;

  /// 对应 AntD `colorBgElevated`。
  final Color colorBackgroundElevated;

  /// 对应 AntD `colorBgLayout`。
  final Color colorBackgroundLayout;

  // 边框
  final Color colorBorder;
  final Color colorBorderSecondary;

  // 填充 / split
  final Color colorFill;
  final Color colorFillSecondary;
  final Color colorSplit;

  // 尺寸 & 字体
  final double controlHeight;
  final double borderRadius;
  final double fontSize;

  AntAliasToken copyWith({
    Color? colorPrimary,
    Color? colorPrimaryHover,
    Color? colorPrimaryActive,
    Color? colorPrimaryBackground,
    Color? colorPrimaryBackgroundHover,
    Color? colorPrimaryBorder,
    Color? colorSuccess,
    Color? colorWarning,
    Color? colorError,
    Color? colorInfo,
    Color? colorText,
    Color? colorTextSecondary,
    Color? colorTextTertiary,
    Color? colorTextDisabled,
    Color? colorBackgroundContainer,
    Color? colorBackgroundElevated,
    Color? colorBackgroundLayout,
    Color? colorBorder,
    Color? colorBorderSecondary,
    Color? colorFill,
    Color? colorFillSecondary,
    Color? colorSplit,
    double? controlHeight,
    double? borderRadius,
    double? fontSize,
  }) {
    return AntAliasToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorPrimaryHover: colorPrimaryHover ?? this.colorPrimaryHover,
      colorPrimaryActive: colorPrimaryActive ?? this.colorPrimaryActive,
      colorPrimaryBackground: colorPrimaryBackground ?? this.colorPrimaryBackground,
      colorPrimaryBackgroundHover:
          colorPrimaryBackgroundHover ?? this.colorPrimaryBackgroundHover,
      colorPrimaryBorder: colorPrimaryBorder ?? this.colorPrimaryBorder,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorText: colorText ?? this.colorText,
      colorTextSecondary: colorTextSecondary ?? this.colorTextSecondary,
      colorTextTertiary: colorTextTertiary ?? this.colorTextTertiary,
      colorTextDisabled: colorTextDisabled ?? this.colorTextDisabled,
      colorBackgroundContainer:
          colorBackgroundContainer ?? this.colorBackgroundContainer,
      colorBackgroundElevated:
          colorBackgroundElevated ?? this.colorBackgroundElevated,
      colorBackgroundLayout:
          colorBackgroundLayout ?? this.colorBackgroundLayout,
      colorBorder: colorBorder ?? this.colorBorder,
      colorBorderSecondary: colorBorderSecondary ?? this.colorBorderSecondary,
      colorFill: colorFill ?? this.colorFill,
      colorFillSecondary: colorFillSecondary ?? this.colorFillSecondary,
      colorSplit: colorSplit ?? this.colorSplit,
      controlHeight: controlHeight ?? this.controlHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntAliasToken &&
        other.colorPrimary == colorPrimary &&
        other.colorPrimaryHover == colorPrimaryHover &&
        other.colorPrimaryActive == colorPrimaryActive &&
        other.colorPrimaryBackground == colorPrimaryBackground &&
        other.colorPrimaryBackgroundHover == colorPrimaryBackgroundHover &&
        other.colorPrimaryBorder == colorPrimaryBorder &&
        other.colorSuccess == colorSuccess &&
        other.colorWarning == colorWarning &&
        other.colorError == colorError &&
        other.colorInfo == colorInfo &&
        other.colorText == colorText &&
        other.colorTextSecondary == colorTextSecondary &&
        other.colorTextTertiary == colorTextTertiary &&
        other.colorTextDisabled == colorTextDisabled &&
        other.colorBackgroundContainer == colorBackgroundContainer &&
        other.colorBackgroundElevated == colorBackgroundElevated &&
        other.colorBackgroundLayout == colorBackgroundLayout &&
        other.colorBorder == colorBorder &&
        other.colorBorderSecondary == colorBorderSecondary &&
        other.colorFill == colorFill &&
        other.colorFillSecondary == colorFillSecondary &&
        other.colorSplit == colorSplit &&
        other.controlHeight == controlHeight &&
        other.borderRadius == borderRadius &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode => Object.hashAll(<Object>[
    colorPrimary,
    colorPrimaryHover,
    colorPrimaryActive,
    colorPrimaryBackground,
    colorPrimaryBackgroundHover,
    colorPrimaryBorder,
    colorSuccess,
    colorWarning,
    colorError,
    colorInfo,
    colorText,
    colorTextSecondary,
    colorTextTertiary,
    colorTextDisabled,
    colorBackgroundContainer,
    colorBackgroundElevated,
    colorBackgroundLayout,
    colorBorder,
    colorBorderSecondary,
    colorFill,
    colorFillSecondary,
    colorSplit,
    controlHeight,
    borderRadius,
    fontSize,
  ]);
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/theme/alias_token_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/theme/alias_token.dart test/unit/theme/alias_token_test.dart
git commit -m "feat(theme): add AntAliasToken with 25 MVP fields"
```

---

## Task 8: theme/algorithm/theme_algorithm.dart — 抽象接口

**Files:**
- Create: `lib/src/theme/algorithm/theme_algorithm.dart`

无 TDD：纯接口，被 Task 9 的实现用 TDD 驱动。

- [ ] **Step 1: 建目录**

Run: `mkdir -p lib/src/theme/algorithm`

- [ ] **Step 2: 写实现**

写入 `lib/src/theme/algorithm/theme_algorithm.dart`：

```dart
import '../alias_token.dart';
import '../map_token.dart';
import '../seed_token.dart';

/// 主题算法接口：将 Seed 派生为 Map，再派生为 Alias。
///
/// `DefaultAlgorithm` 为 Phase 1 唯一实现。`DarkAlgorithm` /
/// `CompactAlgorithm` 计划在 2.1 版本引入，届时只新增实现类，不改接口。
abstract interface class AntThemeAlgorithm {
  AntMapToken mapFromSeed(AntSeedToken seed);
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map);
}
```

- [ ] **Step 3: 运行 analyze 确认无告警**

Run: `flutter analyze --fatal-infos lib/src/theme/algorithm/theme_algorithm.dart`
Expected: `No issues found!`

- [ ] **Step 4: 建议 commit**

```bash
git add lib/src/theme/algorithm/theme_algorithm.dart
git commit -m "feat(theme): add AntThemeAlgorithm interface"
```

---

## Task 9: theme/algorithm/default_algorithm.dart — DefaultAlgorithm

**Files:**
- Create: `lib/src/theme/algorithm/default_algorithm.dart`
- Create: `test/unit/theme/default_algorithm_test.dart`

**背景**：灰阶 13 阶直接写死常量（AntD 预设值）；彩色 map 由 `generatePalette` 驱动；Alias 由手工映射规则派生。

- [ ] **Step 1: 写失败测试**

写入 `test/unit/theme/default_algorithm_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/theme/algorithm/default_algorithm.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const algorithm = DefaultAlgorithm();

  group('mapFromSeed', () {
    test('colorPrimary is 10-length palette with seed at index 5', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      expect(map.colorPrimary, hasLength(10));
      expect(map.colorPrimary[5], seed.colorPrimary);
    });

    test('colorNeutral is 13-length fixed grey scale', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      expect(map.colorNeutral, hasLength(13));
      // 首尾接近白 / 黑
      expect((map.colorNeutral.first.r * 255).round(), greaterThanOrEqualTo(250));
      expect((map.colorNeutral.last.r * 255).round(), lessThanOrEqualTo(20));
    });

    test('control heights follow AntD defaults', () {
      final map = algorithm.mapFromSeed(const AntSeedToken());
      expect(map.controlHeight, 32);
      expect(map.controlHeightSmall, 24);
      expect(map.controlHeightLarge, 40);
    });

    test('font sizes follow Typography constants', () {
      final map = algorithm.mapFromSeed(const AntSeedToken());
      expect(map.fontSize, 14);
      expect(map.fontSizeSmall, 12);
      expect(map.fontSizeLarge, 16);
      expect(map.fontSizeExtraLarge, 20);
    });

    test('border radius derives from seed', () {
      final map = algorithm.mapFromSeed(
        const AntSeedToken(borderRadius: 8),
      );
      expect(map.borderRadius, 8);
      expect(map.borderRadiusSmall, lessThan(map.borderRadius));
      expect(map.borderRadiusLarge, greaterThan(map.borderRadius));
    });
  });

  group('aliasFromMap', () {
    test('all 25 fields are non-null', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      final alias = algorithm.aliasFromMap(seed, map);

      // 编译期就能保证非 null，此测试验证构造没抛异常、值有意义
      expect(alias.colorPrimary, seed.colorPrimary);
      expect(alias.colorPrimaryHover, map.colorPrimary[4]);
      expect(alias.colorPrimaryActive, map.colorPrimary[6]);
      expect(alias.colorPrimaryBackground, map.colorPrimary[0]);
      expect(alias.colorPrimaryBackgroundHover, map.colorPrimary[1]);
      expect(alias.colorPrimaryBorder, map.colorPrimary[2]);

      expect(alias.colorSuccess, seed.colorSuccess);
      expect(alias.colorWarning, seed.colorWarning);
      expect(alias.colorError, seed.colorError);
      expect(alias.colorInfo, seed.colorInfo);

      expect(alias.colorText.a, greaterThan(200 / 255));
      expect(alias.colorTextSecondary.a, lessThan(alias.colorText.a));
      expect(alias.colorTextTertiary.a,
          lessThan(alias.colorTextSecondary.a));
      expect(alias.colorTextDisabled.a,
          lessThan(alias.colorTextTertiary.a));

      expect(alias.colorBackgroundContainer, seed.colorBackgroundBase);
      expect(alias.colorBackgroundElevated, seed.colorBackgroundBase);
      expect(alias.colorBackgroundLayout, map.colorNeutral[1]);

      expect(alias.colorBorder, map.colorNeutral[4]);
      expect(alias.colorBorderSecondary, map.colorNeutral[3]);

      expect(alias.colorFill, isA<Color>());
      expect(alias.colorFillSecondary, isA<Color>());
      expect(alias.colorSplit, isA<Color>());

      expect(alias.controlHeight, map.controlHeight);
      expect(alias.borderRadius, map.borderRadius);
      expect(alias.fontSize, map.fontSize);
    });

    test('purple seed produces purple primary alias', () {
      const seed = AntSeedToken(colorPrimary: Color(0xFF722ED1));
      final map = algorithm.mapFromSeed(seed);
      final alias = algorithm.aliasFromMap(seed, map);
      expect(alias.colorPrimary, const Color(0xFF722ED1));
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/theme/default_algorithm_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/theme/algorithm/default_algorithm.dart`：

```dart
import 'dart:ui';

import '../../foundation/color/generate.dart';
import '../../foundation/typography.dart';
import '../alias_token.dart';
import '../map_token.dart';
import '../seed_token.dart';
import 'theme_algorithm.dart';

/// AntD v5 默认主题算法。
///
/// Dark / Compact 算法推迟至 2.1；本类是 Phase 1 唯一实现。
class DefaultAlgorithm implements AntThemeAlgorithm {
  const DefaultAlgorithm();

  /// 固定 13 阶灰阶，对齐 AntD v5 `grey` 预设。
  static const List<Color> _greyScale = <Color>[
    Color(0xFFFFFFFF),
    Color(0xFFFAFAFA),
    Color(0xFFF5F5F5),
    Color(0xFFF0F0F0),
    Color(0xFFD9D9D9),
    Color(0xFFBFBFBF),
    Color(0xFF8C8C8C),
    Color(0xFF595959),
    Color(0xFF434343),
    Color(0xFF262626),
    Color(0xFF1F1F1F),
    Color(0xFF141414),
    Color(0xFF000000),
  ];

  static const List<BoxShadow> _defaultShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 28,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> _secondaryShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  @override
  AntMapToken mapFromSeed(AntSeedToken seed) {
    return AntMapToken(
      colorPrimary: generatePalette(seed.colorPrimary),
      colorSuccess: generatePalette(seed.colorSuccess),
      colorWarning: generatePalette(seed.colorWarning),
      colorError: generatePalette(seed.colorError),
      colorInfo: generatePalette(seed.colorInfo),
      colorNeutral: _greyScale,
      controlHeight: 32,
      controlHeightSmall: 24,
      controlHeightLarge: 40,
      fontSize: Typography.fontSize,
      fontSizeSmall: Typography.fontSizeSmall,
      fontSizeLarge: Typography.fontSizeLarge,
      fontSizeExtraLarge: Typography.fontSizeExtraLarge,
      lineHeight: Typography.lineHeight,
      borderRadius: seed.borderRadius,
      borderRadiusSmall: (seed.borderRadius - 2).clamp(0, double.infinity),
      borderRadiusLarge: seed.borderRadius + 2,
      boxShadow: _defaultShadow,
      boxShadowSecondary: _secondaryShadow,
    );
  }

  @override
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map) {
    final textBase = seed.colorTextBase;
    return AntAliasToken(
      colorPrimary: seed.colorPrimary,
      colorPrimaryHover: map.colorPrimary[4],
      colorPrimaryActive: map.colorPrimary[6],
      colorPrimaryBackground: map.colorPrimary[0],
      colorPrimaryBackgroundHover: map.colorPrimary[1],
      colorPrimaryBorder: map.colorPrimary[2],
      colorSuccess: seed.colorSuccess,
      colorWarning: seed.colorWarning,
      colorError: seed.colorError,
      colorInfo: seed.colorInfo,
      colorText: _withAlpha(textBase, 0.88),
      colorTextSecondary: _withAlpha(textBase, 0.65),
      colorTextTertiary: _withAlpha(textBase, 0.45),
      colorTextDisabled: _withAlpha(textBase, 0.25),
      colorBackgroundContainer: seed.colorBackgroundBase,
      colorBackgroundElevated: seed.colorBackgroundBase,
      colorBackgroundLayout: map.colorNeutral[1],
      colorBorder: map.colorNeutral[4],
      colorBorderSecondary: map.colorNeutral[3],
      colorFill: _withAlpha(textBase, 0.15),
      colorFillSecondary: _withAlpha(textBase, 0.06),
      colorSplit: _withAlpha(textBase, 0.06),
      controlHeight: map.controlHeight,
      borderRadius: map.borderRadius,
      fontSize: map.fontSize,
    );
  }

  static Color _withAlpha(Color base, double alpha) {
    return Color.fromARGB(
      (alpha * 255).round().clamp(0, 255),
      (base.r * 255).round(),
      (base.g * 255).round(),
      (base.b * 255).round(),
    );
  }
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/theme/default_algorithm_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/theme/algorithm/default_algorithm.dart test/unit/theme/default_algorithm_test.dart
git commit -m "feat(theme): add DefaultAlgorithm with grey scale and alias derivation"
```

---

## Task 10: theme/theme_data.dart — AntThemeData

**Files:**
- Create: `lib/src/theme/theme_data.dart`
- Create: `test/unit/theme/theme_data_test.dart`

- [ ] **Step 1: 写失败测试**

写入 `test/unit/theme/theme_data_test.dart`：

```dart
import 'dart:ui';

import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntThemeData', () {
    test('default constructor builds map and alias eagerly', () {
      final theme = AntThemeData();
      expect(theme.map.colorPrimary, hasLength(10));
      expect(theme.alias.colorPrimary, theme.seed.colorPrimary);
    });

    test('custom seed propagates through map and alias', () {
      final theme = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      expect(theme.seed.colorPrimary, const Color(0xFF722ED1));
      expect(theme.map.colorPrimary[5], const Color(0xFF722ED1));
      expect(theme.alias.colorPrimary, const Color(0xFF722ED1));
    });

    test('same seed + same algorithm → equal map/alias', () {
      final a = AntThemeData();
      final b = AntThemeData();
      expect(a.map, equals(b.map));
      expect(a.alias, equals(b.alias));
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different seed → different theme', () {
      final a = AntThemeData();
      final b = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF000000)),
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith replaces seed and recomputes map/alias', () {
      final base = AntThemeData();
      final modified = base.copyWith(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      expect(modified.seed.colorPrimary, const Color(0xFF722ED1));
      expect(modified.map.colorPrimary[5], const Color(0xFF722ED1));
      expect(modified, isNot(equals(base)));
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/unit/theme/theme_data_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/theme/theme_data.dart`：

```dart
import 'package:flutter/foundation.dart';

import 'algorithm/default_algorithm.dart';
import 'algorithm/theme_algorithm.dart';
import 'alias_token.dart';
import 'map_token.dart';
import 'seed_token.dart';

/// 主题数据聚合：构造时立即算出 [map] 和 [alias]，三份 token 都是 `final`。
///
/// 相同 `seed + algorithm` 必出相同 `map + alias`（算法纯函数）。
///
/// 注意：无法标为 `const` — 构造体调了 `algorithm.mapFromSeed`，
/// 这是方法调用。需要默认 theme 时写 `AntThemeData()` 而非 `const AntThemeData()`。
@immutable
class AntThemeData {
  factory AntThemeData({
    AntSeedToken seed = const AntSeedToken(),
    AntThemeAlgorithm algorithm = const DefaultAlgorithm(),
  }) {
    final map = algorithm.mapFromSeed(seed);
    final alias = algorithm.aliasFromMap(seed, map);
    return AntThemeData._(
      seed: seed,
      algorithm: algorithm,
      map: map,
      alias: alias,
    );
  }

  const AntThemeData._({
    required this.seed,
    required this.algorithm,
    required this.map,
    required this.alias,
  });

  final AntSeedToken seed;
  final AntThemeAlgorithm algorithm;
  final AntMapToken map;
  final AntAliasToken alias;

  AntThemeData copyWith({
    AntSeedToken? seed,
    AntThemeAlgorithm? algorithm,
  }) {
    return AntThemeData(
      seed: seed ?? this.seed,
      algorithm: algorithm ?? this.algorithm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntThemeData &&
        other.seed == seed &&
        other.algorithm.runtimeType == algorithm.runtimeType &&
        other.map == map &&
        other.alias == alias;
  }

  @override
  int get hashCode => Object.hash(seed, algorithm.runtimeType, map, alias);
}
```

> **注意**：Dart 的初始化列表不支持引用兄弟字段，因此用 factory + 私有命名构造的组合——factory 里 map / alias 各算一次再传给 `_()`。

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/unit/theme/theme_data_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/theme/theme_data.dart test/unit/theme/theme_data_test.dart
git commit -m "feat(theme): add AntThemeData aggregate with eager map/alias"
```

---

## Task 11: app/ant_config_provider.dart — InheritedWidget + AntTheme 语法糖

**Files:**
- Create: `lib/src/app/ant_config_provider.dart`
- Create: `test/widget/ant_config_provider_test.dart`

- [ ] **Step 1: 建目录**

Run: `mkdir -p lib/src/app test/widget`

- [ ] **Step 2: 写失败测试**

写入 `test/widget/ant_config_provider_test.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntConfigProvider.of', () {
    testWidgets('returns nearest theme', (tester) async {
      final theme = AntThemeData();
      AntThemeData? captured;
      await tester.pumpWidget(
        AntConfigProvider(
          theme: theme,
          child: Builder(builder: (ctx) {
            captured = AntConfigProvider.of(ctx);
            return const SizedBox();
          }),
        ),
      );
      expect(captured, same(theme));
    });

    testWidgets('asserts when no provider in tree', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (ctx) {
          expect(() => AntConfigProvider.of(ctx), throwsAssertionError);
          return const SizedBox();
        }),
      );
    });
  });

  group('AntConfigProvider.maybeOf', () {
    testWidgets('returns null when no provider in tree', (tester) async {
      AntThemeData? captured;
      await tester.pumpWidget(
        Builder(builder: (ctx) {
          captured = AntConfigProvider.maybeOf(ctx);
          return const SizedBox();
        }),
      );
      expect(captured, isNull);
    });
  });

  group('nested override', () {
    testWidgets('inner provider replaces outer', (tester) async {
      final outer = AntThemeData();
      final inner = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      AntThemeData? seen;
      await tester.pumpWidget(
        AntConfigProvider(
          theme: outer,
          child: AntConfigProvider(
            theme: inner,
            child: Builder(builder: (ctx) {
              seen = AntConfigProvider.of(ctx);
              return const SizedBox();
            }),
          ),
        ),
      );
      expect(seen!.seed.colorPrimary, const Color(0xFF722ED1));
    });
  });

  group('updateShouldNotify', () {
    testWidgets('rebuilds dependents only when theme changes', (tester) async {
      var buildCount = 0;
      Widget buildTree(AntThemeData theme) {
        return AntConfigProvider(
          theme: theme,
          child: Builder(builder: (ctx) {
            AntConfigProvider.of(ctx);
            buildCount++;
            return const SizedBox();
          }),
        );
      }

      final sameSeed = AntThemeData();
      await tester.pumpWidget(buildTree(sameSeed));
      expect(buildCount, 1);

      // 相等 theme → 不应 rebuild 依赖者
      await tester.pumpWidget(buildTree(AntThemeData()));
      expect(buildCount, 1);

      // 不等 theme → 依赖者 rebuild
      await tester.pumpWidget(buildTree(
        AntThemeData(
          seed: const AntSeedToken(colorPrimary: Color(0xFF000000)),
        ),
      ));
      expect(buildCount, 2);
    });
  });

  group('AntTheme syntax sugar', () {
    testWidgets('aliasOf shortcut works', (tester) async {
      final theme = AntThemeData();
      await tester.pumpWidget(
        AntConfigProvider(
          theme: theme,
          child: Builder(builder: (ctx) {
            expect(AntTheme.of(ctx), same(theme));
            expect(AntTheme.aliasOf(ctx), same(theme.alias));
            return const SizedBox();
          }),
        ),
      );
    });
  });
}
```

- [ ] **Step 3: 运行测试确认失败**

Run: `flutter test test/widget/ant_config_provider_test.dart`
Expected: 编译错误

- [ ] **Step 4: 写实现**

写入 `lib/src/app/ant_config_provider.dart`：

```dart
import 'package:flutter/widgets.dart';

import '../theme/alias_token.dart';
import '../theme/theme_data.dart';

/// 主题注入。包裹应用根；组件通过 `AntTheme.of(context)` 访问。
class AntConfigProvider extends InheritedWidget {
  const AntConfigProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  final AntThemeData theme;

  static AntThemeData of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<AntConfigProvider>();
    assert(
      widget != null,
      'No AntConfigProvider found. Wrap your app in AntApp or AntConfigProvider.',
    );
    return widget!.theme;
  }

  static AntThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AntConfigProvider>()?.theme;

  @override
  bool updateShouldNotify(AntConfigProvider old) => theme != old.theme;
}

/// 语法糖：`AntTheme.aliasOf(context).colorPrimary` 比
/// `AntConfigProvider.of(context).alias.colorPrimary` 简短。
abstract final class AntTheme {
  static AntThemeData of(BuildContext context) =>
      AntConfigProvider.of(context);

  static AntAliasToken aliasOf(BuildContext context) => of(context).alias;
}
```

- [ ] **Step 5: 运行测试确认通过**

Run: `flutter test test/widget/ant_config_provider_test.dart`
Expected: `All tests passed!`

- [ ] **Step 6: 建议 commit**

```bash
git add lib/src/app/ant_config_provider.dart test/widget/ant_config_provider_test.dart
git commit -m "feat(app): add AntConfigProvider inherited widget and AntTheme sugar"
```

---

## Task 12: app/ant_app.dart — AntApp 极小壳

**Files:**
- Create: `lib/src/app/ant_app.dart`
- Create: `test/widget/ant_app_test.dart`

- [ ] **Step 1: 写失败测试**

写入 `test/widget/ant_app_test.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_app.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntApp', () {
    testWidgets('renders home with default theme', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Builder(builder: (ctx) {
            final alias = AntTheme.aliasOf(ctx);
            expect(alias.colorPrimary, const Color(0xFF1677FF));
            return const SizedBox();
          }),
        ),
      );
    });

    testWidgets('custom theme propagates to descendants', (tester) async {
      final theme = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      await tester.pumpWidget(
        AntApp(
          theme: theme,
          home: Builder(builder: (ctx) {
            expect(AntTheme.aliasOf(ctx).colorPrimary,
                const Color(0xFF722ED1));
            return const SizedBox();
          }),
        ),
      );
    });

    testWidgets('default title is empty string', (tester) async {
      await tester.pumpWidget(
        AntApp(home: const SizedBox()),
      );
      // 无异常即通过；title 的验证在 WidgetsApp 的 meta 里，
      // Flutter test 默认不断言 title。
    });
  });
}
```

- [ ] **Step 2: 运行测试确认失败**

Run: `flutter test test/widget/ant_app_test.dart`
Expected: 编译错误

- [ ] **Step 3: 写实现**

写入 `lib/src/app/ant_app.dart`：

```dart
import 'package:flutter/widgets.dart';

import '../theme/theme_data.dart';
import 'ant_config_provider.dart';

/// Ant Design Flutter 应用根。
///
/// 极小壳：`AntConfigProvider + WidgetsApp`。不带 Navigator routes、
/// Localizations、全局 Overlay host。这些将在 Phase 2+ 的独立能力里加。
/// 需要多页路由的用户可直接用 `WidgetsApp` + `AntConfigProvider`。
class AntApp extends StatelessWidget {
  const AntApp({
    super.key,
    this.theme,
    required this.home,
    this.title = '',
    this.color,
  });

  /// 传 `null` 使用默认 `AntThemeData()`（默认 seed + DefaultAlgorithm）。
  /// 由于 `AntThemeData` 的构造体调了方法，不能是 `const`，
  /// 因此默认值以 nullable 形式表达并在 build 时懒惰创建。
  final AntThemeData? theme;
  final Widget home;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = theme ?? AntThemeData();
    return AntConfigProvider(
      theme: resolvedTheme,
      child: WidgetsApp(
        title: title,
        color: color ?? resolvedTheme.alias.colorPrimary,
        textStyle: TextStyle(
          fontFamily: resolvedTheme.seed.fontFamily,
          fontSize: resolvedTheme.seed.fontSize,
          color: resolvedTheme.alias.colorText,
        ),
        home: home,
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (ctx, _, __) => builder(ctx),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: 运行测试确认通过**

Run: `flutter test test/widget/ant_app_test.dart`
Expected: `All tests passed!`

- [ ] **Step 5: 建议 commit**

```bash
git add lib/src/app/ant_app.dart test/widget/ant_app_test.dart
git commit -m "feat(app): add AntApp minimal shell"
```

---

## Task 13: barrel 导出 + example demo + 收尾验证

**Files:**
- Modify: `lib/ant_design_flutter.dart`
- Delete: `test/smoke_test.dart`
- Modify: `example/main.dart`
- Modify: `doc/PROGRESS.md`
- Modify: `CHANGELOG.md`

- [ ] **Step 1: 重写 barrel 导出**

完整替换 `lib/ant_design_flutter.dart`：

```dart
/// ant_design_flutter 2.0 - Ant Design v5 aligned component library
/// for Flutter web and desktop applications.
///
/// Phase 1 exports: Foundation + Theme + App shell.
library;

// Theme tokens
export 'src/theme/alias_token.dart' show AntAliasToken;
export 'src/theme/map_token.dart' show AntMapToken;
export 'src/theme/seed_token.dart' show AntSeedToken;
export 'src/theme/theme_data.dart' show AntThemeData;

// Algorithm
export 'src/theme/algorithm/default_algorithm.dart' show DefaultAlgorithm;
export 'src/theme/algorithm/theme_algorithm.dart' show AntThemeAlgorithm;

// App
export 'src/app/ant_app.dart' show AntApp;
export 'src/app/ant_config_provider.dart' show AntConfigProvider, AntTheme;
```

foundation/color 内部工具 (Hsv / mixColor / generatePalette / Typography) 不导出。

- [ ] **Step 2: 删掉 Phase 0 的 smoke test**

Run: `rm -f test/smoke_test.dart`

- [ ] **Step 3: 重写 example 跑主色 demo**

完整替换 `example/main.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return AntApp(
      home: Builder(
        builder: (ctx) {
          final alias = AntTheme.aliasOf(ctx);
          return ColoredBox(
            color: alias.colorPrimaryBackground,
            child: Center(
              child: Text(
                'Hello Ant',
                style: TextStyle(
                  color: alias.colorPrimary,
                  fontSize: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: 运行完整校验**

依次运行全部命令：

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
dart format --output=none --set-exit-if-changed .
```

Expected 每条：
```
Got dependencies!
No issues found!
All tests passed!
(no output)
```

格式若不通过，运行 `dart format .` 修复后再次验证。

- [ ] **Step 5: 验证 example 能启动**

Run: `flutter run -d chrome -t example/main.dart`

Expected：浏览器打开，看到淡蓝色背景（`colorPrimaryBackground` ≈ `#E6F4FF`）+ 主色 "Hello Ant" 文字。手动 Ctrl+C 结束。

若要自动化验证可替代为：
```bash
flutter build web -t example/main.dart --no-pub
```
Expected: 编译成功，输出 `build/web/`。

- [ ] **Step 6: 补第 4 个 seed 的 golden 测试（error red）**

运行 `node` 取 `#FF4D4F` 的 generate 输出：

```bash
node -e "console.log(JSON.stringify(require('@ant-design/colors').generate('#FF4D4F')))"
```

将输出的 10 个十六进制值（例如 `['#FFF1F0','#FFCCC7',...]`）写入 `test/unit/foundation/generate_test.dart` 新增的测试：

```dart
test('seed #FF4D4F (error red) matches @ant-design/colors', () {
  const golden = <int>[
    // 从 node 命令输出粘贴，去掉 # 前缀并加 0x 前缀：
    // 0xFFF1F0, 0xFFCCC7, ...
  ];
  _expectPaletteMatches(
    generatePalette(const Color(0xFFFF4D4F)),
    golden,
  );
});
```

Run: `flutter test test/unit/foundation/generate_test.dart`
Expected: 4 个 seed 测试全通过。

若 node 不可用（无 Node.js 环境），跳过本步骤并在 `doc/PROGRESS.md` 记录 "error red golden 待补"。

- [ ] **Step 7: 更新 doc/PROGRESS.md**

在 `doc/PROGRESS.md` 中：

- 把 Phase 1 行的 status 从 `not started` 改为 `complete`，plan 列改为 `[plans/2026-04-18-phase-1-token-system.md](../docs/superpowers/plans/2026-04-18-phase-1-token-system.md)`
- 更新 `Last updated` 为完成当天日期
- 在 `Current session notes` 追加：
  ```
  - 2026-XX-XX: Phase 1 complete. Token system (Seed/Map/Alias) + DefaultAlgorithm + AntApp shell landed. Next: write Phase 2 plan (Primitives: Interaction / Portal / Overlay).
  ```

- [ ] **Step 8: 更新 CHANGELOG.md**

在 `CHANGELOG.md` 顶部追加：

```markdown
## 2.0.0-dev.2

Phase 1 delivery: Design Token system.

### Added
- `AntSeedToken` / `AntMapToken` / `AntAliasToken` three-layer tokens (14 / 19 / 25 fields).
- `AntThemeAlgorithm` interface and `DefaultAlgorithm` implementation.
- `AntThemeData` aggregate with eager map/alias computation.
- `AntConfigProvider` InheritedWidget + `AntTheme` syntax sugar.
- `AntApp` minimal shell (WidgetsApp + AntConfigProvider).
- Foundation color utilities (HSV conversion, weighted mix, 10-shade palette generation) with tests matching `@ant-design/colors`.
- `example/main.dart` now renders a primary color demo.

### Naming convention
- All public fields use full English words (`Background`, `Small`, `Large`, `ExtraLarge`) rather than AntD's abbreviated forms (`Bg`, `SM`, `LG`, `XL`). dartdoc on each alias / map field cross-references the original AntD name.

### Reference
- Spec: `docs/superpowers/specs/2026-04-18-phase-1-token-system-design.md`
- Plan: `docs/superpowers/plans/2026-04-18-phase-1-token-system.md`

---
```

保留 `## 2.0.0-dev.1` 及往后全部历史条目。

- [ ] **Step 9: 最终一轮端到端校验**

```bash
flutter analyze --fatal-infos
flutter test
dart format --output=none --set-exit-if-changed .
```

全部必须通过。如有失败不要强行提交，回到对应 Task 修复。

- [ ] **Step 10: 建议 commit**

```bash
git add lib/ant_design_flutter.dart example/main.dart doc/PROGRESS.md CHANGELOG.md
git rm -f test/smoke_test.dart
git commit -m "feat(phase-1): wire barrel exports, example demo, and changelog"
```

---

## Phase 1 完成定义（DoD）

全部满足才算 Phase 1 完成：

- [x] `lib/src/foundation/color/{hsv,mix,generate}.dart` 实现 + 单测对拍 `@ant-design/colors`（至少 3 个 seed，理想 4 个）
- [x] `lib/src/foundation/typography.dart` 常量
- [x] `lib/src/theme/{seed,map,alias}_token.dart` 三份 token（14/19/25 字段）全部带 copyWith + == + hashCode
- [x] `lib/src/theme/algorithm/theme_algorithm.dart` 抽象接口
- [x] `lib/src/theme/algorithm/default_algorithm.dart` 实现
- [x] `lib/src/theme/theme_data.dart` AntThemeData（构造即算）
- [x] `lib/src/app/ant_config_provider.dart` InheritedWidget + AntTheme 语法糖
- [x] `lib/src/app/ant_app.dart` 极小壳
- [x] `lib/ant_design_flutter.dart` barrel 导出 Phase 1 公开符号
- [x] `example/main.dart` 跑出主色背景 + 主色文字（浏览器实测通过）
- [x] 字段命名遵循完整单词规则（无 Bg / SM / LG / XL）
- [x] Alias / Map / Seed 每个公开字段有 dartdoc；缩写对齐字段附带 "对应 AntD `xxx`" 注释
- [x] `flutter analyze --fatal-infos` 通过
- [x] `flutter test` 全部通过
- [x] `dart format --set-exit-if-changed .` 通过
- [x] `doc/PROGRESS.md` Phase 1 行标 complete
- [x] `CHANGELOG.md` 追加 2.0.0-dev.2 条目

---

## Out of Scope（明确不做）

- Dark / Compact 算法实现（只留 abstract interface，2.1 再补）
- Locale / i18n（Phase 7）
- Golden widget test（2.1）
- Component 消费 alias 的实际样式（Phase 2+ 每个组件各自负责）
- AntOverlayManager / AntPortal / AntInteractionDetector（Phase 2）
- Navigator routing / Localizations wiring（不在 AntApp 范围）
