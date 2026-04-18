# Phase 1：Foundation + Theme（Token 系统）设计文档

- **Spec 日期**：2026-04-18
- **父 Spec**：[2026-04-18-antdf-2.0-design.md](./2026-04-18-antdf-2.0-design.md) 第 3 节
- **覆盖范围**：总设计中的 L0 Foundation、L1 Theme、L5 AntApp 的极小壳
- **预计工时**：30h / 4 周（业余 7.5h/周）
- **状态**：Draft，等待用户 review

---

## 0. 决策摘要

| 维度 | 决策 |
| --- | --- |
| Phase 1 边界 | Spec 对齐版：三层 Token + DefaultAlgorithm + AntConfigProvider + AntApp 极小壳 |
| 色板算法 | 移植 TinyColor2 核心能力 + 自写 generate，对拍 `@ant-design/colors` |
| InheritedWidget 粒度 | 单一 `AntConfigProvider`（装 AntThemeData，seed/map/alias 聚合） |
| 不可变实现 | 手写 `const` + `copyWith` + `==` + `hashCode`，零依赖 |
| 嵌套覆盖语义 | 完全替换（内层 theme 直接覆盖外层；部分覆盖由用户用 `copyWith` 自拼） |
| AntApp 范围 | 极小壳 = `AntConfigProvider` + `WidgetsApp`；不含 Navigator / Localizations / Overlay host |
| Alias 字段数量 | MVP 子集约 25 个，覆盖 17 组件真实消费 |
| Dark/Compact 算法 | 只定接口，不写空壳实现（推迟至 2.1） |
| 色板暴露形态 | `List<Color>` 长度 10，dartdoc 注明索引 0 最浅 / 5 主色 / 9 最深 |
| map/alias 缓存 | `AntThemeData` 构造时立即算一次，存为 `final` 字段 |
| 命名规则 | 完整英文单词，禁用 Bg/SM/LG/XL；公认缩写（ID/RGB/HSV）可保留 |

---

## 1. 架构总览

Phase 1 覆盖 L0（Foundation）、L1（Theme）、L5（AntApp 极小壳）。依赖方向：

```
foundation/        零 Flutter 依赖（仅 dart:ui + flutter/widgets.dart 的 Color/BoxShadow）
    ↑
theme/             Seed/Map/Alias + Algorithm 接口 + DefaultAlgorithm
    ↑
app/               AntConfigProvider (InheritedWidget) + AntApp 极小壳
```

硬约束：

- `theme/` 不 import `components/`（components Phase 2+ 才出现）
- `foundation/` 不 import `theme/`
- `app/` 不 import `components/`
- 反向违反靠 code review 守护；Phase 2 再考虑 analyzer 规则

---

## 2. 项目结构

```
lib/
├── ant_design_flutter.dart              # barrel，导出 Phase 1 公开符号
└── src/
    ├── foundation/
    │   ├── color/
    │   │   ├── hsv.dart                 # Color ⇄ HSV 换算
    │   │   ├── mix.dart                 # 颜色加权混合
    │   │   └── generate.dart            # AntD generate 算法，输出 10 阶
    │   └── typography.dart              # 字号 / 行高常量
    ├── theme/
    │   ├── seed_token.dart
    │   ├── map_token.dart
    │   ├── alias_token.dart
    │   ├── theme_data.dart              # AntThemeData（构造时立即算 map/alias）
    │   └── algorithm/
    │       ├── theme_algorithm.dart     # abstract interface AntThemeAlgorithm
    │       └── default_algorithm.dart
    └── app/
        ├── ant_config_provider.dart     # InheritedWidget + AntTheme 语法糖
        └── ant_app.dart                 # WidgetsApp + AntConfigProvider 的壳

test/
├── unit/
│   ├── foundation/
│   │   ├── hsv_test.dart
│   │   ├── mix_test.dart
│   │   └── generate_test.dart           # 对拍 AntD JS golden
│   └── theme/
│       ├── default_algorithm_test.dart
│       └── theme_data_test.dart
└── widget/
    ├── ant_config_provider_test.dart    # of(context) / 嵌套覆盖 / updateShouldNotify
    └── ant_app_test.dart

example/
└── main.dart                            # 主色背景 + 主色文字 demo
```

**barrel 导出清单**：

```
AntSeedToken
AntMapToken
AntAliasToken
AntThemeData
AntThemeAlgorithm
DefaultAlgorithm
AntConfigProvider
AntTheme                     // 语法糖静态类
AntApp
```

`foundation/color/*` 的 `Hsv` / `mixColor` / `generatePalette` 为内部工具，不导出。

---

## 3. Design Token 系统

### 3.1 AntSeedToken（14 字段）

```dart
@immutable
class AntSeedToken {
  const AntSeedToken({
    this.colorPrimary  = const Color(0xFF1677FF),
    this.colorSuccess  = const Color(0xFF52C41A),
    this.colorWarning  = const Color(0xFFFAAD14),
    this.colorError    = const Color(0xFFFF4D4F),
    this.colorInfo     = const Color(0xFF1677FF),
    this.colorTextBase = const Color(0xFF000000),
    this.colorBackgroundBase = const Color(0xFFFFFFFF),
    this.fontFamily,
    this.fontSize      = 14,
    this.borderRadius  = 6,
    this.sizeUnit      = 4,
    this.sizeStep      = 4,
    this.wireframe     = false,
    this.motion        = true,
  });

  final Color colorPrimary;
  final Color colorSuccess;
  final Color colorWarning;
  final Color colorError;
  final Color colorInfo;
  final Color colorTextBase;
  final Color colorBackgroundBase;   // 对应 AntD colorBgBase
  final String? fontFamily;
  final double fontSize;
  final double borderRadius;
  final double sizeUnit;
  final double sizeStep;
  final bool wireframe;
  final bool motion;

  AntSeedToken copyWith({...});
  @override bool operator ==(Object other);
  @override int get hashCode;
}
```

### 3.2 AntMapToken（算法派生，19 字段）

```dart
@immutable
class AntMapToken {
  const AntMapToken({
    required this.colorPrimary,          // List<Color> length == 10
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,
    required this.colorNeutral,          // 灰阶 13 阶
    required this.controlHeight,         // 32
    required this.controlHeightSmall,    // 24  对应 AntD controlHeightSM
    required this.controlHeightLarge,    // 40  对应 AntD controlHeightLG
    required this.fontSize,              // 14
    required this.fontSizeSmall,         // 12  对应 AntD fontSizeSM
    required this.fontSizeLarge,         // 16  对应 AntD fontSizeLG
    required this.fontSizeExtraLarge,    // 20  对应 AntD fontSizeXL
    required this.lineHeight,            // 1.5714
    required this.borderRadius,          // 6
    required this.borderRadiusSmall,     // 4   对应 AntD borderRadiusSM
    required this.borderRadiusLarge,     // 8   对应 AntD borderRadiusLG
    required this.boxShadow,             // List<BoxShadow>
    required this.boxShadowSecondary,
  });

  // ... 19 final 字段 + copyWith + == + hashCode
}
```

**列表字段相等性**：`colorPrimary` 等 `List<Color>` / `boxShadow` 用 `flutter/foundation.dart` 的 `listEquals`，哈希用 `Object.hashAll`。

**索引约定（dartdoc 固化）**：

- `colorPrimary[0]` = primary-1（最浅）
- `colorPrimary[5]` = primary-6（主色，与 seed 一致）
- `colorPrimary[9]` = primary-10（最深）

### 3.3 AntAliasToken（MVP 子集，25 字段）

组件只消费此层。

```dart
@immutable
class AntAliasToken {
  const AntAliasToken({
    // primary 衍生态（Button / Checkbox / Switch / Tag）
    required this.colorPrimary,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorPrimaryBackground,        // 对应 AntD colorPrimaryBg
    required this.colorPrimaryBackgroundHover,   // 对应 AntD colorPrimaryBgHover
    required this.colorPrimaryBorder,

    // 语义色
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,

    // 文本 4 级
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextTertiary,
    required this.colorTextDisabled,

    // 背景 3 级
    required this.colorBackgroundContainer,      // 对应 AntD colorBgContainer
    required this.colorBackgroundElevated,       // 对应 AntD colorBgElevated
    required this.colorBackgroundLayout,         // 对应 AntD colorBgLayout

    // 边框 2 级
    required this.colorBorder,
    required this.colorBorderSecondary,

    // 填充 / split
    required this.colorFill,
    required this.colorFillSecondary,
    required this.colorSplit,

    // 尺寸 & 字体（从 map 直穿）
    required this.controlHeight,
    required this.borderRadius,
    required this.fontSize,
  });

  // ... 25 final 字段 + copyWith + == + hashCode
}
```

每个字段 dartdoc 必带一行 `/// 对应 AntD v5 \`<原字段名>\`。`，便于对照官网文档。

### 3.4 Algorithm 接口

```dart
abstract interface class AntThemeAlgorithm {
  AntMapToken mapFromSeed(AntSeedToken seed);
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map);
}

class DefaultAlgorithm implements AntThemeAlgorithm {
  const DefaultAlgorithm();

  @override
  AntMapToken mapFromSeed(AntSeedToken seed) { /* ... */ }

  @override
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map) { /* ... */ }
}
```

Dark / Compact 不在 Phase 1 实现，**也不写空壳**，dartdoc 注明 "Planned for 2.1"。

### 3.5 AntThemeData（聚合）

```dart
@immutable
class AntThemeData {
  AntThemeData({
    this.seed = const AntSeedToken(),
    this.algorithm = const DefaultAlgorithm(),
  })  : map = algorithm.mapFromSeed(seed),
        alias = algorithm.aliasFromMap(seed, map);

  final AntSeedToken seed;
  final AntThemeAlgorithm algorithm;
  final AntMapToken map;
  final AntAliasToken alias;

  AntThemeData copyWith({AntSeedToken? seed, AntThemeAlgorithm? algorithm});
  @override bool operator ==(Object other);
  @override int get hashCode;
}
```

构造立即算；相同 `seed + algorithm` 必出相同 `map + alias`（算法纯函数）。不搞懒求值。

**注意**：`AntThemeData` 的构造体调了 `algorithm.mapFromSeed` 方法，**无法标为 `const`**。这意味着无法写 `const AntThemeData()`；`AntApp` / `AntConfigProvider` 的默认值要用 nullable + 懒初始化（参见 § 5.3）。

### 3.6 消费规约

组件侧只读 alias：

```dart
final alias = AntTheme.aliasOf(context);
DecoratedBox(
  decoration: BoxDecoration(
    color: alias.colorPrimaryBackground,
    border: Border.all(color: alias.colorBorder),
    borderRadius: BorderRadius.circular(alias.borderRadius),
  ),
);
```

不允许组件直接访问 `AntTheme.of(ctx).seed` 或 `.map`；若 alias 缺字段，优先补 alias 而不是绕过。

### 3.7 嵌套覆盖

完全替换：

```dart
AntConfigProvider(
  theme: AntThemeData(
    seed: outer.seed.copyWith(colorPrimary: Colors.purple),
  ),
  child: SomeSubtree(),
);
```

不提供 merge API；部分覆盖由用户用 `copyWith` 自拼。

---

## 4. 色板算法

### 4.1 参照

对拍 `@ant-design/colors` 的 `generate(color)` 函数。算法核心：HSV 空间按固定 hue/saturation/value 偏移表输出 10 阶。

### 4.2 底层工具

```dart
// foundation/color/hsv.dart
class Hsv {
  const Hsv(this.hue, this.saturation, this.value);
  final double hue;         // [0, 360)
  final double saturation;  // [0, 1]
  final double value;       // [0, 1]

  factory Hsv.fromColor(Color c);
  Color toColor({double alpha = 1});
}

// foundation/color/mix.dart
Color mixColor(Color base, Color mixed, double weight);  // weight ∈ [0, 100]
```

### 4.3 generate 主流程

AntD JS 的常量在 Dart 端照抄：

```dart
// foundation/color/generate.dart
const _hueStep = 2;
const _saturationStepLight = 16;
const _saturationStepDark = 5;
const _saturationStep2Dark = 15;
const _brightnessStep1 = 5;
const _brightnessStep2 = 15;
const _lightColorCount = 5;
const _darkColorCount = 4;

/// 返回长度 10 的色板：[0] 最浅 → [5] seed 主色 → [9] 最深。
List<Color> generatePalette(Color seed) { /* ... */ }
```

内部 `_getShade(hsv, index, {required bool light})` 按偏移表调 H/S/V 再 clamp。

### 4.4 对拍测试（Golden）

每个 seed 取 `@ant-design/colors` 的输出为 golden：

```dart
// test/unit/foundation/generate_test.dart
test('generatePalette matches @ant-design/colors for #1677FF', () {
  const expected = <int>[
    0xE6F4FF, 0xBAE0FF, 0x91CAFF, 0x69B1FF, 0x4096FF,
    0x1677FF, 0x0958D9, 0x003EB3, 0x002C8C, 0x001D66,
  ];
  final actual = generatePalette(const Color(0xFF1677FF))
      .map((c) => c.value & 0xFFFFFF).toList();
  for (var i = 0; i < 10; i++) {
    expect(_deltaRgb(actual[i], expected[i]), lessThanOrEqualTo(1),
        reason: 'index $i mismatch');
  }
});
```

覆盖 5 个 seed：primary `#1677FF`、success `#52C41A`、warning `#FAAD14`、error `#FF4D4F`、info `#1677FF`。每阶 RGB 差 ≤ 1 通过。Golden 数组来源：

```bash
node -e "console.log(require('@ant-design/colors').generate('#1677FF'))"
```

### 4.5 灰阶

AntD 灰阶不走 generate，是独立 13 阶固定常量（`#FFFFFF` → `#000000` 之间预设值）。直接写进 `DefaultAlgorithm`，不动态计算。

---

## 5. AntConfigProvider & AntApp

### 5.1 AntConfigProvider（InheritedWidget）

```dart
class AntConfigProvider extends InheritedWidget {
  const AntConfigProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  final AntThemeData theme;

  static AntThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AntConfigProvider>();
    assert(widget != null,
        'No AntConfigProvider found. Wrap your app in AntApp or AntConfigProvider.');
    return widget!.theme;
  }

  static AntThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AntConfigProvider>()?.theme;

  @override
  bool updateShouldNotify(AntConfigProvider old) => theme != old.theme;
}
```

### 5.2 AntTheme 语法糖

```dart
abstract final class AntTheme {
  static AntThemeData of(BuildContext context) => AntConfigProvider.of(context);
  static AntAliasToken aliasOf(BuildContext context) => of(context).alias;
}
```

组件调用侧：

```dart
final alias = AntTheme.aliasOf(context);
```

### 5.3 AntApp 极小壳

```dart
class AntApp extends StatelessWidget {
  const AntApp({
    super.key,
    this.theme,
    required this.home,
    this.title = '',
    this.color,
  });

  /// 传 `null` 时使用 `AntThemeData()`（默认 seed + DefaultAlgorithm）。
  /// 注意 `AntThemeData` 不能是 const，故默认值以 nullable 形式表达。
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
          pageBuilder: (ctx, _, _) => builder(ctx),
        ),
      ),
    );
  }
}
```

不含：Navigator routes、`onGenerateRoute`、Localizations、全局 Overlay host。多页场景请直接用 `WidgetsApp` + `AntConfigProvider`。

### 5.4 Phase 1 交付 demo

```dart
// example/main.dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) => AntApp(
    home: Builder(builder: (ctx) {
      final alias = AntTheme.aliasOf(ctx);
      return ColoredBox(
        color: alias.colorPrimaryBackground,
        child: Center(
          child: Text(
            'Hello Ant',
            style: TextStyle(color: alias.colorPrimary, fontSize: 24),
          ),
        ),
      );
    }),
  );
}
```

跑出蓝底 + 主色字 = Phase 1 视觉交付达成。

---

## 6. 测试策略

### 6.1 单元测试（必覆盖）

| 模块 | 文件 | 覆盖点 |
| --- | --- | --- |
| foundation/color | hsv_test.dart | `Color → Hsv → Color` 往返 RGB 差 ≤ 1；纯黑 / 纯白 / 纯饱和边界 |
| foundation/color | mix_test.dart | weight=0 / 50 / 100 三点；alpha 不丢 |
| foundation/color | generate_test.dart | 5 seed × 10 阶 × 对拍 JS golden |
| theme | default_algorithm_test.dart | mapFromSeed 输出长度 / 关键字段；aliasFromMap 25 字段全非 null |
| theme | theme_data_test.dart | 构造即算；==/hashCode 一致；copyWith 行为 |

### 6.2 Widget 测试（必覆盖）

| 文件 | 覆盖点 |
| --- | --- |
| ant_config_provider_test.dart | 无祖先时 `AntTheme.of` assert 抛错；有祖先时正确取值；嵌套覆盖内层优先；`updateShouldNotify` 仅在 theme 真变时触发 |
| ant_app_test.dart | 默认 seed 渲染不崩溃；自定义 seed 时子树能读到派生后的 alias |

### 6.3 覆盖率门槛

Phase 1 预计 ~600 LOC，门槛收紧：

- Unit ≥ 95%
- Widget ≥ 80%
- 总体 ≥ 90%

CI 仅报警不 block（延续父 spec 决策）。

### 6.4 不做

- Golden widget test（推迟 2.1）
- Dark/Compact algorithm 对比
- 性能 benchmark

---

## 7. Phase 1 完成定义（DoD）

- [ ] `lib/src/foundation/color/{hsv,mix,generate}.dart` 实现 + 5 seed 单测对拍 AntD JS golden
- [ ] `lib/src/foundation/typography.dart` 常量占位
- [ ] `lib/src/theme/{seed,map,alias}_token.dart` 三份不可变 Token（14/19/25 字段）+ copyWith + == + hashCode
- [ ] `lib/src/theme/algorithm/theme_algorithm.dart` 抽象接口
- [ ] `lib/src/theme/algorithm/default_algorithm.dart` 实现
- [ ] `lib/src/theme/theme_data.dart` `AntThemeData`（构造即算）
- [ ] `lib/src/app/ant_config_provider.dart` InheritedWidget + `AntTheme` 语法糖
- [ ] `lib/src/app/ant_app.dart` 极小壳
- [ ] `lib/ant_design_flutter.dart` 导出 § 2 列出的全部公开符号
- [ ] `example/main.dart` 跑出主色背景 + 主色文字
- [ ] `flutter analyze --fatal-infos` 通过
- [ ] `flutter test` 全部通过；覆盖率达 § 6.3
- [ ] 每个公开类 / 字段有 dartdoc；Alias / Map 字段注明对应 AntD 原字段名
- [ ] 字段命名遵循「完整单词」规则（Background / Small / Large / ExtraLarge 等）
- [ ] `doc/PROGRESS.md` Phase 1 行改为 complete，追加 session note
- [ ] `CHANGELOG.md` 追加 2.0.0-dev.2 条目

---

## 8. 时间预算

业余 7.5h/周，共 4 周：

| 子任务 | 预计工时 |
| --- | --- |
| foundation/color（HSV + mix + generate + 对拍测试） | 8h |
| 三层 Token 类（14 + 19 + 25 字段 + copyWith + ==） | 6h |
| Algorithm 接口 + DefaultAlgorithm（含灰阶常量） | 6h |
| AntConfigProvider + AntTheme 语法糖 + widget 测试 | 4h |
| AntApp 极小壳 + example | 3h |
| 覆盖率补测 + dartdoc 收尾 | 3h |
| **合计** | **30h ≈ 4 周** |

---

## 9. 风险与缓解

| 风险 | 级别 | 缓解 |
| --- | --- | --- |
| AntD JS generate 在特定 seed（纯灰 / 纯白 / 纯黑）输出与 Dart 移植偏差 | 中 | golden 覆盖 5 种彩色 seed；dartdoc 标注 "彩色 seed 行为与 AntD 一致，灰度 seed 为未定义行为" |
| 25 字段 copyWith 手写易漏 | 中 | 每个字段做一次 `copyWith(xxx: newValue)` 后 == 比对；漏字段直接 fail |
| `List<Color>` / `List<BoxShadow>` 默认 == 为 identity | 低 | 统一用 `flutter/foundation.dart` 的 `listEquals` + `Object.hashAll`，零依赖 |
| 用户在 Phase 1 想要多页路由，AntApp 不支持 | 低 | MIGRATION.md / dartdoc 明示 "Phase 1 AntApp 仅 home；多页直接用 WidgetsApp + AntConfigProvider" |
| Dark/Compact 接口留空后续收紧 API 造成 breaking | 低 | `AntThemeAlgorithm` 只返回 map/alias 两个方法，2.1 引入 Dark 时只新增实现类，不改接口 |

---

## 10. 与父 Spec 的关系

本 spec 是父 spec（`2026-04-18-antdf-2.0-design.md`）第 3 节 "Design Token 系统" 的落地细化，不新增父 spec 没有的架构约束。Phase 2（Primitives）开始后若发现 alias 字段不足，按父 spec 第 3.4 节 "消费规约" 的原则**增补 alias**，不允许组件绕过 alias 直接读 map/seed。

---

## 11. 后续

Phase 1 完成后下一步：回到 brainstorming（或直接 writing-plans，视情况）为 Phase 2（Primitives: Interaction / Portal / Overlay）做设计细化。
