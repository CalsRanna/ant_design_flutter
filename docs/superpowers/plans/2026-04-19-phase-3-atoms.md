# Phase 3 Round 1+2 原子组件实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 交付 8 个 Round 1+2 原子组件（AntIcon / AntTitle / AntText / AntParagraph / AntLink / AntButton / AntInput / AntCheckbox+Group / AntRadio+Group / AntSwitch / AntTag+CheckableTag）到 `lib/src/components/`，每组件 widget + style 两文件拆分，含共享 `_shared/` 工具、Gallery 24 故事、example 表单演示页、README 字体章节与 `2.0.0-dev.4` 发布。

**Architecture:** 组件层只消费 `AntTheme.aliasOf(context)` 的 AntAliasToken；Round 2 复用 Phase 2 的 `AntInteractionDetector` 做 hover/focus/pressed/disabled 合成；每个组件 `ant_<name>.dart`（widget）+ `<name>_style.dart`（纯函数：alias + properties → 视觉派生值）；共享 `AntComponentSize` / `AntStatus` / `resolveControlHeight()` / `LoadingSpinner` 放 `components/_shared/`；不引入 `package:flutter/material.dart`，Input 用 `package:flutter/widgets.dart` 的 `EditableText`；不打包字体，AntIcon 仅接受用户传入的 IconData。

**Tech Stack:** Flutter 3.38+ / Dart 3.10+、`package:flutter/widgets.dart`（含 `EditableText` / `WidgetStatesController` / `AnimationController` / `CustomPaint` / `FocusNode` / `MouseRegion`）、`flutter_test`、`widgetbook: ^3.11.0`（gallery 子项目）。零第三方运行时依赖。

**上游 Spec：**
- 父 spec：[`docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`](../specs/2026-04-18-antdf-2.0-design.md) §6
- Phase 3 补充 spec：[`docs/superpowers/specs/2026-04-19-phase-3-atoms-design.md`](../specs/2026-04-19-phase-3-atoms-design.md)

**时间预算：** 7 周 / 约 53h（业余 7.5h/周）。

**commit 规则：** conventional commits 风格（`type(scope): subject`）；**不得**出现任何 AI 水印（`Co-Authored-By: Claude` / "Generated with Claude Code" 等）。分支策略：直接在 `main` 上线性推进，Phase 收尾打 tag `v2.0.0-dev.4`。

---

## File Structure

Phase 3 结束时新增 / 改动的文件（完整树见 spec §2）：

```
lib/
├── ant_design_flutter.dart                                    ← 修改（追加导出）
└── src/
    └── components/                                            ← 新目录
        ├── _shared/
        │   ├── component_size.dart                            AntComponentSize 枚举
        │   ├── component_status.dart                          AntStatus 枚举
        │   ├── control_height.dart                            resolveControlHeight()
        │   └── loading_spinner.dart                           LoadingSpinner（库内私有）
        ├── icon/ant_icon.dart
        ├── typography/
        │   ├── ant_title.dart
        │   ├── ant_text.dart
        │   ├── ant_paragraph.dart
        │   └── ant_link.dart
        ├── button/
        │   ├── ant_button.dart
        │   └── button_style.dart
        ├── input/
        │   ├── ant_input.dart
        │   ├── input_style.dart
        │   └── _clear_icon.dart
        ├── checkbox/
        │   ├── ant_option.dart                                AntOption<T>（Radio Group 也复用）
        │   ├── ant_checkbox.dart
        │   ├── ant_checkbox_group.dart
        │   └── checkbox_style.dart
        ├── radio/
        │   ├── ant_radio.dart
        │   ├── ant_radio_group.dart
        │   └── radio_style.dart
        ├── switch/
        │   ├── ant_switch.dart
        │   └── switch_style.dart
        └── tag/
            ├── ant_tag.dart
            └── tag_style.dart

example/main.dart                                              ← 重写为注册表单
gallery/lib/main.dart                                          ← 重写为按组件分类的 widgetbook 树
gallery/lib/components/                                        ← 新目录，8 个 *_stories.dart
CHANGELOG.md                                                   ← 新增 2.0.0-dev.4 条目
doc/PROGRESS.md                                                ← Phase 3 → complete
README.md                                                      ← 新增"使用图标字体"章节
pubspec.yaml                                                   ← version → 2.0.0-dev.4

test/
├── unit/components/{button,input,checkbox,radio,switch,tag}/*_style_test.dart
└── widget/components/{icon,typography,button,input,checkbox,radio,switch,tag}/*_test.dart
```

**职责切分：**
- `_shared/` 是**库内公用工具**：enum、尺寸映射、LoadingSpinner。不对外导出（LoadingSpinner 完全 library private；enum 与函数通过 barrel 导出）
- 每个组件目录独立，只依赖 `theme/`、`primitives/`、`_shared/`
- `*_style.dart` 是纯数据派生层，可 unit-test，不含 Widget
- `ant_*.dart` 是 Widget 层，组装 style + InteractionDetector
- `AntOption<T>` 放 `checkbox/ant_option.dart`，`radio_group.dart` 显式 `import '../checkbox/ant_option.dart'`（spec §2 的例外条款）

**硬规则：**
- `lib/src/components/**` 不得 `import 'package:flutter/material.dart'`
- 组件之间不得互相 import（除 AntOption 的例外）
- 组件只能从 `AntTheme.aliasOf(context)` 读 alias；禁止读 seed / map

---

## Task 1：_shared/ 目录 + 枚举 + 尺寸映射函数

**目的：** 落地 Round 2 所有组件共享的 `AntComponentSize`、`AntStatus` 枚举，以及把 size 档位映射到 controlHeight 的纯函数，为后续组件铺路。

**Files:**
- Create: `lib/src/components/_shared/component_size.dart`
- Create: `lib/src/components/_shared/component_status.dart`
- Create: `lib/src/components/_shared/control_height.dart`
- Create: `test/unit/components/shared/control_height_test.dart`
- Modify: `lib/ant_design_flutter.dart`（末尾追加两条导出）

- [ ] **Step 1：创建 `AntComponentSize` 枚举**

写入 `lib/src/components/_shared/component_size.dart`：

```dart
/// 组件尺寸档位。
///
/// 对齐 AntD v5 `size` 属性。三档分别对应 controlHeight 24 / 32 / 40。
enum AntComponentSize {
  /// 紧凑场景：控件高度 24、字号 -2。
  small,

  /// 默认档位：控件高度来自 `AntAliasToken.controlHeight`（=32）、默认字号。
  middle,

  /// 宽松场景：控件高度 40、字号 +2。
  large,
}
```

- [ ] **Step 2：创建 `AntStatus` 枚举**

写入 `lib/src/components/_shared/component_status.dart`：

```dart
/// 组件状态（主要被 `AntInput` / 未来 `AntSelect` 等表单控件消费）。
///
/// 值对应 AntD v5 `status` 属性。`default` 是 Dart 关键字，故重命名为
/// `defaultStatus`。
enum AntStatus {
  /// 默认中立状态。
  defaultStatus,

  /// 校验失败，视觉上 border / icon 用 colorError。
  error,

  /// 警告，视觉上 border / icon 用 colorWarning。
  warning,
}
```

- [ ] **Step 3：写失败测试 — resolveControlHeight**

写入 `test/unit/components/shared/control_height_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveControlHeight', () {
    final alias = AntThemeData().alias;

    test('small returns 24', () {
      expect(resolveControlHeight(alias, AntComponentSize.small), 24);
    });

    test('middle returns alias.controlHeight (32 for default theme)', () {
      expect(
        resolveControlHeight(alias, AntComponentSize.middle),
        alias.controlHeight,
      );
      expect(alias.controlHeight, 32);
    });

    test('large returns 40', () {
      expect(resolveControlHeight(alias, AntComponentSize.large), 40);
    });
  });
}
```

- [ ] **Step 4：运行测试确认失败**

Run: `flutter test test/unit/components/shared/control_height_test.dart`
Expected: 失败，`resolveControlHeight` / `AntComponentSize` 未定义 / 未导出。

- [ ] **Step 5：实现 `resolveControlHeight`**

写入 `lib/src/components/_shared/control_height.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';

/// 根据 [size] 从 [alias] 派生控件高度。
///
/// Alias 目前仅持有 middle 档位（`controlHeight`）。small / large 档位
/// 在 Phase 3 用常量给出（24 / 40），待 2.1 引入 alias 小 / 大字段后改读 alias，
/// 调用方零改动。
double resolveControlHeight(AntAliasToken alias, AntComponentSize size) {
  return switch (size) {
    AntComponentSize.small => 24,
    AntComponentSize.middle => alias.controlHeight,
    AntComponentSize.large => 40,
  };
}
```

- [ ] **Step 6：把枚举加入 barrel 导出**

Edit `lib/ant_design_flutter.dart` —— 在现有 `export 'src/primitives/...'` 行块之前（保持字母顺序可读性），追加：

```dart
export 'src/components/_shared/component_size.dart' show AntComponentSize;
export 'src/components/_shared/component_status.dart' show AntStatus;
```

> `control_height.dart` **不**导出 —— `resolveControlHeight` 是库内工具，不对用户公开。

- [ ] **Step 7：运行测试确认通过 + analyze 通过**

Run: `flutter test test/unit/components/shared/control_height_test.dart`
Expected: 3 tests pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 8：提交**

```bash
git add lib/src/components/_shared/ \
        lib/ant_design_flutter.dart \
        test/unit/components/shared/
git commit -m "feat(components): add shared component size / status enums"
```

---

## Task 2：LoadingSpinner（共享的旋转指示器）

**目的：** 提供 `AntButton.loading` 与 `AntSwitch.loading` 共用的 270° 旋转弧。库内私有（不导出），由组件内部构造。

**Files:**
- Create: `lib/src/components/_shared/loading_spinner.dart`
- Create: `test/widget/components/shared/loading_spinner_test.dart`

- [ ] **Step 1：写失败测试 — 基础渲染**

写入 `test/widget/components/shared/loading_spinner_test.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingSpinner', () {
    testWidgets('renders at given size and drives an animation', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: LoadingSpinner(color: Color(0xFFFFFFFF), size: 16),
          ),
        ),
      );

      // 初始帧渲染 16×16 的方框（SizedBox）。
      final sized = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );
      expect(sized.width, 16);
      expect(sized.height, 16);

      // 推进 250ms，AnimationController 应仍在 ticking（widget 还存在）。
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(LoadingSpinner), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/shared/loading_spinner_test.dart`
Expected: 失败，`LoadingSpinner` 未定义。

- [ ] **Step 3：实现 LoadingSpinner**

写入 `lib/src/components/_shared/loading_spinner.dart`：

```dart
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 270° 旋转弧（库内私有）。
///
/// 用于 `AntButton.loading` 与 `AntSwitch.loading`。不对外导出。
///
/// 实现：`AnimationController(duration: 1s, repeat)` 驱动 `CustomPainter`
/// 画一段起始角随时间增加、固定扫过 270° 的弧。stroke 宽度固定为 `size / 8`。
class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({
    required this.color,
    required this.size,
    super.key,
  });

  final Color color;
  final double size;

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _SpinnerPainter(
            color: widget.color,
            progress: _controller.value,
            strokeWidth: widget.size / 8,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  final Color color;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);
    final startAngle = progress * 2 * math.pi;
    const sweepAngle = 1.5 * math.pi; // 270°
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) {
    return old.progress != progress ||
        old.color != color ||
        old.strokeWidth != strokeWidth;
  }
}
```

- [ ] **Step 4：运行测试确认通过**

Run: `flutter test test/widget/components/shared/loading_spinner_test.dart`
Expected: 1 test pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 5：提交**

```bash
git add lib/src/components/_shared/loading_spinner.dart \
        test/widget/components/shared/loading_spinner_test.dart
git commit -m "feat(components): add shared LoadingSpinner (library private)"
```

---

## Task 3：AntIcon

**目的：** 最轻量的组件：包装 Flutter `Icon` + 三档 size 映射 + 默认继承 `IconTheme.color`。不打包字体，完全透传用户传入的 `IconData`。

**Files:**
- Create: `lib/src/components/icon/ant_icon.dart`
- Create: `test/widget/components/icon/ant_icon_test.dart`
- Modify: `lib/ant_design_flutter.dart`（追加导出）

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/icon/ant_icon_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// 测试用 IconData：跟 Flutter 内置 Icons.check 同码点，避免依赖 material。
const IconData _testIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

void main() {
  group('AntIcon', () {
    testWidgets('default middle size renders 16px', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(_testIcon),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 16);
    });

    testWidgets('small renders 14px, large renders 20px', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntIcon(_testIcon, size: AntComponentSize.small),
              AntIcon(_testIcon, size: AntComponentSize.large),
            ],
          ),
        ),
      );
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons[0].size, 14);
      expect(icons[1].size, 20);
    });

    testWidgets('color is passed through', (tester) async {
      const red = Color(0xFFFF0000);
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(_testIcon, color: red),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, red);
    });

    testWidgets('color null defers to IconTheme.color', (tester) async {
      const blue = Color(0xFF0000FF);
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: IconTheme(
            data: IconThemeData(color: blue),
            child: AntIcon(_testIcon),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, isNull); // AntIcon 不强制 color
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/icon/ant_icon_test.dart`
Expected: 失败，`AntIcon` 未定义。

- [ ] **Step 3：实现 AntIcon**

写入 `lib/src/components/icon/ant_icon.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 的图标组件。
///
/// **字体不随包打包**：用户需自带图标字体（例如社区包 `ant_icons_plus`，
/// 或自行制作 TrueType 子集）。`AntIcon` 只负责尺寸 / 颜色 / 语义标签；
/// 字形渲染交给 Flutter 内置 `Icon` 完成。
///
/// 三档 size 映射：small=14、middle=16、large=20（像素）。
class AntIcon extends StatelessWidget {
  const AntIcon(
    this.icon, {
    super.key,
    this.size = AntComponentSize.middle,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final AntComponentSize size;

  /// null 时由 `IconTheme.of(context).color` 回落。
  final Color? color;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final pixelSize = switch (size) {
      AntComponentSize.small => 14.0,
      AntComponentSize.middle => 16.0,
      AntComponentSize.large => 20.0,
    };
    return Icon(
      icon,
      size: pixelSize,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart`，在 `AntStatus` 导出之后追加：

```dart
export 'src/components/icon/ant_icon.dart' show AntIcon;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/components/icon/ant_icon_test.dart`
Expected: 4 tests pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/components/icon/ \
        test/widget/components/icon/ \
        lib/ant_design_flutter.dart
git commit -m "feat(icon): add AntIcon (IconData wrapper, no bundled font)"
```

---

## Task 4：AntTypography（Title / Text / Paragraph / Link 四子类）

**目的：** 交付 Typography 命名空间下的 4 个独立 Widget。Title / Text / Paragraph 不用 InteractionDetector；Link 是整个 Typography 唯一带交互的，hover/focus 变色、下划线。

### Task 4a：AntTitle

**Files:**
- Create: `lib/src/components/typography/ant_title.dart`
- Create: `test/widget/components/typography/ant_title_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/typography/ant_title_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTitle', () {
    testWidgets('h1 renders 38px bold', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('Hello')),
      );
      final text = tester.widget<Text>(find.text('Hello'));
      expect(text.style?.fontSize, 38);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('h5 renders 16px bold', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('H5', level: AntTitleLevel.h5)),
      );
      final text = tester.widget<Text>(find.text('H5'));
      expect(text.style?.fontSize, 16);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('uses alias.colorText', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('Color')),
      );
      final context = tester.element(find.text('Color'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('Color'));
      expect(text.style?.color, alias.colorText);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/typography/ant_title_test.dart`
Expected: 失败，`AntTitle` / `AntTitleLevel` 未定义。

- [ ] **Step 3：实现 AntTitle**

写入 `lib/src/components/typography/ant_title.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// AntTitle 的级别。对齐 AntD v5，只到 h5。
enum AntTitleLevel { h1, h2, h3, h4, h5 }

/// 标题组件。
///
/// 字号 / 行高 / 粗细对齐 AntD v5：
/// h1=38, h2=30, h3=24, h4=20, h5=16；lineHeight 分别 1.23/1.33/1.33/1.4/1.5；
/// 全部 w600。颜色取 `alias.colorText`。
class AntTitle extends StatelessWidget {
  const AntTitle(
    this.text, {
    super.key,
    this.level = AntTitleLevel.h1,
    this.textAlign,
  });

  final String text;
  final AntTitleLevel level;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final (fontSize, lineHeight) = switch (level) {
      AntTitleLevel.h1 => (38.0, 1.23),
      AntTitleLevel.h2 => (30.0, 1.33),
      AntTitleLevel.h3 => (24.0, 1.33),
      AntTitleLevel.h4 => (20.0, 1.4),
      AntTitleLevel.h5 => (16.0, 1.5),
    };
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: alias.colorText,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
```

- [ ] **Step 4：追加导出**

Edit `lib/ant_design_flutter.dart` 在 `AntIcon` 之后追加：

```dart
export 'src/components/typography/ant_title.dart' show AntTitle, AntTitleLevel;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/components/typography/ant_title_test.dart`
Expected: 3 tests pass。

- [ ] **Step 6：提交**

```bash
git add lib/src/components/typography/ant_title.dart \
        test/widget/components/typography/ant_title_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(typography): add AntTitle (h1-h5)"
```

### Task 4b：AntText

**Files:**
- Create: `lib/src/components/typography/ant_text.dart`
- Create: `test/widget/components/typography/ant_text_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/typography/ant_text_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntText', () {
    testWidgets('default normal type uses colorText', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('hello')),
      );
      final context = tester.element(find.text('hello'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, alias.colorText);
    });

    testWidgets('danger type uses colorError', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('danger', type: AntTextType.danger)),
      );
      final context = tester.element(find.text('danger'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('danger'));
      expect(text.style?.color, alias.colorError);
    });

    testWidgets('strong makes fontWeight w600', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('b', strong: true)),
      );
      final text = tester.widget<Text>(find.text('b'));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('italic / underline / delete propagate', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntText('styled', italic: true, underline: true, delete: true),
        ),
      );
      final text = tester.widget<Text>(find.text('styled'));
      expect(text.style?.fontStyle, FontStyle.italic);
      expect(text.style?.decoration, TextDecoration.combine(const [
        TextDecoration.underline,
        TextDecoration.lineThrough,
      ]));
    });

    testWidgets('size small uses alias.fontSize - 2', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('s', size: AntComponentSize.small)),
      );
      final context = tester.element(find.text('s'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('s'));
      expect(text.style?.fontSize, alias.fontSize - 2);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/typography/ant_text_test.dart`
Expected: 失败，`AntText` / `AntTextType` 未定义。

- [ ] **Step 3：实现 AntText**

写入 `lib/src/components/typography/ant_text.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// AntText 的语义类型（决定颜色）。
enum AntTextType {
  normal,
  secondary,
  tertiary,
  disabled,
  success,
  warning,
  danger,
}

/// 通用文字。对齐 AntD v5 `Typography.Text`。
class AntText extends StatelessWidget {
  const AntText(
    this.text, {
    super.key,
    this.type = AntTextType.normal,
    this.size = AntComponentSize.middle,
    this.strong = false,
    this.italic = false,
    this.underline = false,
    this.delete = false,
    this.code = false,
  });

  final String text;
  final AntTextType type;
  final AntComponentSize size;
  final bool strong;
  final bool italic;
  final bool underline;
  final bool delete;

  /// 等宽字体 + 浅灰背景（code 片段样式）。
  final bool code;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final color = _resolveColor(alias, type);
    final fontSize = switch (size) {
      AntComponentSize.small => alias.fontSize - 2,
      AntComponentSize.middle => alias.fontSize,
      AntComponentSize.large => alias.fontSize + 2,
    };

    final decorations = <TextDecoration>[
      if (underline) TextDecoration.underline,
      if (delete) TextDecoration.lineThrough,
    ];

    final style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: strong ? FontWeight.w600 : null,
      fontStyle: italic ? FontStyle.italic : null,
      fontFamily: code ? 'monospace' : null,
      decoration: decorations.isEmpty
          ? null
          : TextDecoration.combine(decorations),
    );

    final textWidget = Text(text, style: style);
    if (!code) return textWidget;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: alias.colorFillSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: textWidget,
      ),
    );
  }

  Color _resolveColor(AntAliasToken alias, AntTextType type) {
    return switch (type) {
      AntTextType.normal => alias.colorText,
      AntTextType.secondary => alias.colorTextSecondary,
      AntTextType.tertiary => alias.colorTextTertiary,
      AntTextType.disabled => alias.colorTextDisabled,
      AntTextType.success => alias.colorSuccess,
      AntTextType.warning => alias.colorWarning,
      AntTextType.danger => alias.colorError,
    };
  }
}
```

- [ ] **Step 4：追加导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/typography/ant_text.dart' show AntText, AntTextType;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/components/typography/ant_text_test.dart`
Expected: 5 tests pass。

- [ ] **Step 6：提交**

```bash
git add lib/src/components/typography/ant_text.dart \
        test/widget/components/typography/ant_text_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(typography): add AntText (7 semantic types)"
```

### Task 4c：AntParagraph

**Files:**
- Create: `lib/src/components/typography/ant_paragraph.dart`
- Create: `test/widget/components/typography/ant_paragraph_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/typography/ant_paragraph_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AntParagraph renders text with 1em bottom padding',
      (tester) async {
    await tester.pumpWidget(
      const AntApp(home: AntParagraph('body')),
    );
    expect(find.text('body'), findsOneWidget);
    final padding = tester.widget<Padding>(
      find
          .ancestor(of: find.text('body'), matching: find.byType(Padding))
          .first,
    );
    final context = tester.element(find.text('body'));
    final alias = AntTheme.aliasOf(context);
    expect(
      (padding.padding as EdgeInsets).bottom,
      alias.fontSize, // 1em
    );
  });

  testWidgets('AntParagraph danger type propagates to AntText',
      (tester) async {
    await tester.pumpWidget(
      const AntApp(home: AntParagraph('err', type: AntTextType.danger)),
    );
    final context = tester.element(find.text('err'));
    final alias = AntTheme.aliasOf(context);
    final text = tester.widget<Text>(find.text('err'));
    expect(text.style?.color, alias.colorError);
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/typography/ant_paragraph_test.dart`
Expected: 失败，`AntParagraph` 未定义。

- [ ] **Step 3：实现 AntParagraph**

写入 `lib/src/components/typography/ant_paragraph.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/typography/ant_text.dart';
import 'package:flutter/widgets.dart';

/// 段落文字：视觉等同 `AntText`，但底部带 1em `Padding` 用于段间距。
///
/// MVP 不支持 ellipsis / copyable / editable（推迟 2.1）。
class AntParagraph extends StatelessWidget {
  const AntParagraph(this.text, {super.key, this.type = AntTextType.normal});

  final String text;
  final AntTextType type;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: alias.fontSize),
      child: AntText(text, type: type),
    );
  }
}
```

- [ ] **Step 4：追加导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/typography/ant_paragraph.dart' show AntParagraph;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/components/typography/ant_paragraph_test.dart`
Expected: 2 tests pass。

- [ ] **Step 6：提交**

```bash
git add lib/src/components/typography/ant_paragraph.dart \
        test/widget/components/typography/ant_paragraph_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(typography): add AntParagraph with 1em bottom spacing"
```

### Task 4d：AntLink

**Files:**
- Create: `lib/src/components/typography/ant_link.dart`
- Create: `test/widget/components/typography/ant_link_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/typography/ant_link_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntLink', () {
    testWidgets('renders with colorPrimary by default', (tester) async {
      await tester.pumpWidget(
        AntApp(home: AntLink('click', onPressed: () {})),
      );
      final context = tester.element(find.text('click'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('click'));
      expect(text.style?.color, alias.colorPrimary);
    });

    testWidgets('hover switches to colorPrimaryHover', (tester) async {
      await tester.pumpWidget(
        AntApp(home: Center(child: AntLink('h', onPressed: () {}))),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('h')));
      await tester.pump();

      final context = tester.element(find.text('h'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('h'));
      expect(text.style?.color, alias.colorPrimaryHover);
    });

    testWidgets('disabled uses colorTextDisabled and swallows taps',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        AntApp(
          home: AntLink(
            'd',
            onPressed: () => tapped = true,
            disabled: true,
          ),
        ),
      );
      await tester.tap(find.text('d'));
      await tester.pump();
      expect(tapped, isFalse);

      final context = tester.element(find.text('d'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('d'));
      expect(text.style?.color, alias.colorTextDisabled);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/typography/ant_link_test.dart`
Expected: 失败，`AntLink` 未定义。

- [ ] **Step 3：实现 AntLink**

写入 `lib/src/components/typography/ant_link.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 链接样式文字：唯一一个 `AntTypography` 子类走 `AntInteractionDetector`。
///
/// 视觉：normal=colorPrimary / hover=colorPrimaryHover / disabled=colorTextDisabled；
/// focus 时加下划线（键盘导航可见性）。
class AntLink extends StatelessWidget {
  const AntLink(
    this.text, {
    required this.onPressed,
    super.key,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: onPressed,
      builder: (context, states) {
        final Color color;
        if (states.contains(WidgetState.disabled)) {
          color = alias.colorTextDisabled;
        } else if (states.contains(WidgetState.hovered)) {
          color = alias.colorPrimaryHover;
        } else {
          color = alias.colorPrimary;
        }
        final focused = states.contains(WidgetState.focused);
        return Text(
          text,
          style: TextStyle(
            color: color,
            decoration: focused ? TextDecoration.underline : null,
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4：追加导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/typography/ant_link.dart' show AntLink;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/components/typography/ant_link_test.dart`
Expected: 3 tests pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/components/typography/ant_link.dart \
        test/widget/components/typography/ant_link_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(typography): add AntLink with hover / focus / disabled states"
```

---

## Task 5：AntButton（视觉派生最复杂的组件，先 style，再 widget）

### Task 5a：ButtonStyle 纯函数派生 + 全面 unit test

**目的：** 把 `type × danger × ghost × states` 多维映射抽成纯函数 `ButtonStyle.resolve()`，先全覆盖 unit test，再接 widget。

**Files:**
- Create: `lib/src/components/button/button_style.dart`
- Create: `test/unit/components/button/button_style_test.dart`

- [ ] **Step 1：写失败测试 — 全覆盖派生表**

写入 `test/unit/components/button/button_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/button/button_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('ButtonStyle.resolve — primary', () {
    test('normal', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimary);
      expect(s.foreground, const Color(0xFFFFFFFF));
      expect(s.borderColor, isNull);
    });
    test('hover', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimaryHover);
    });
    test('pressed', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {WidgetState.pressed},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimaryActive);
    });
  });

  group('ButtonStyle.resolve — default', () {
    test('normal has border=colorBorder, background=colorBackgroundContainer', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.defaultStyle,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorBackgroundContainer);
      expect(s.foreground, alias.colorText);
      expect(s.borderColor, alias.colorBorder);
    });
    test('hover: border=primaryHover, foreground=primaryHover', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.defaultStyle,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
      expect(s.foreground, alias.colorPrimaryHover);
    });
  });

  group('ButtonStyle.resolve — text', () {
    test('normal transparent', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.text,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, const Color(0x00000000));
      expect(s.foreground, alias.colorText);
    });
    test('hover uses colorFillSecondary', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.text,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorFillSecondary);
    });
  });

  group('ButtonStyle.resolve — link', () {
    test('foreground=colorPrimary normal', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.link,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.foreground, alias.colorPrimary);
      expect(s.background, const Color(0x00000000));
    });
  });

  group('ButtonStyle.resolve — dashed', () {
    test('flags dashedBorder true', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.dashed,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.dashedBorder, isTrue);
      expect(s.borderColor, alias.colorBorder);
    });
  });

  group('ButtonStyle.resolve — danger', () {
    test('primary danger swaps to colorError', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: true,
        ghost: false,
      );
      expect(s.background, alias.colorError);
    });
  });

  group('ButtonStyle.resolve — ghost', () {
    test('primary ghost: transparent background, primary foreground', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: false,
        ghost: true,
      );
      expect(s.background, const Color(0x00000000));
      expect(s.foreground, alias.colorPrimary);
    });
  });

  group('ButtonStyle.resolve — disabled', () {
    test('overrides all types', () {
      for (final type in AntButtonType.values) {
        final s = ButtonStyle.resolve(
          alias: alias,
          type: type,
          states: const {WidgetState.disabled},
          danger: false,
          ghost: false,
        );
        expect(s.background, alias.colorFillSecondary,
            reason: 'disabled background for $type');
        expect(s.foreground, alias.colorTextDisabled,
            reason: 'disabled foreground for $type');
      }
    });
  });

  group('ButtonStyle.padding / fontSize', () {
    test('small: padding 7, fontSize 14', () {
      final s = ButtonStyle.sizeSpec(alias: alias, size: AntComponentSize.small);
      expect(s.horizontalPadding, 7);
      expect(s.fontSize, 14);
      expect(s.height, 24);
    });
    test('middle: padding 15, fontSize 14, height=alias.controlHeight', () {
      final s = ButtonStyle.sizeSpec(alias: alias, size: AntComponentSize.middle);
      expect(s.horizontalPadding, 15);
      expect(s.fontSize, 14);
      expect(s.height, alias.controlHeight);
    });
    test('large: padding 15, fontSize 16, height=40', () {
      final s = ButtonStyle.sizeSpec(alias: alias, size: AntComponentSize.large);
      expect(s.horizontalPadding, 15);
      expect(s.fontSize, 16);
      expect(s.height, 40);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/button/button_style_test.dart`
Expected: 失败，`ButtonStyle` / `AntButtonType` 未定义。

- [ ] **Step 3：实现 ButtonStyle**

写入 `lib/src/components/button/button_style.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// AntButton 的类型。对齐 AntD v5（`default` 关键字冲突 → `defaultStyle`）。
enum AntButtonType { primary, defaultStyle, dashed, text, link }

/// AntButton 的形状。
enum AntButtonShape { rectangle, round, circle }

/// Button 视觉派生（纯数据，可 unit-test）。
///
/// 由 `resolve` + `sizeSpec` 两个静态方法产出，widget 层只负责拼装。
@immutable
class ButtonStyle {
  const ButtonStyle({
    required this.background,
    required this.foreground,
    required this.borderColor,
    required this.dashedBorder,
  });

  /// 填充色（透明用 `Color(0x00000000)`）。
  final Color background;

  /// 文字 / icon 颜色。
  final Color foreground;

  /// 实线 / 虚线时的边框色；null 表示无 border。
  final Color? borderColor;

  /// 是否采用虚线边框（dashed type）。
  final bool dashedBorder;

  /// 根据 [type] / [states] / [danger] / [ghost] 派生 background / foreground / border。
  static ButtonStyle resolve({
    required AntAliasToken alias,
    required AntButtonType type,
    required Set<WidgetState> states,
    required bool danger,
    required bool ghost,
  }) {
    if (states.contains(WidgetState.disabled)) {
      return ButtonStyle(
        background: alias.colorFillSecondary,
        foreground: alias.colorTextDisabled,
        borderColor: alias.colorBorder,
        dashedBorder: type == AntButtonType.dashed,
      );
    }

    // 选主色通道：danger=true 时走 error；否则走 primary。
    final primary = danger ? alias.colorError : alias.colorPrimary;
    final primaryHover = danger ? alias.colorError : alias.colorPrimaryHover;
    final primaryActive = danger ? alias.colorError : alias.colorPrimaryActive;

    final hovered = states.contains(WidgetState.hovered);
    final pressed = states.contains(WidgetState.pressed);

    switch (type) {
      case AntButtonType.primary:
        if (ghost) {
          return ButtonStyle(
            background: const Color(0x00000000),
            foreground: pressed
                ? primaryActive
                : hovered
                    ? primaryHover
                    : primary,
            borderColor: pressed
                ? primaryActive
                : hovered
                    ? primaryHover
                    : primary,
            dashedBorder: false,
          );
        }
        return ButtonStyle(
          background: pressed
              ? primaryActive
              : hovered
                  ? primaryHover
                  : primary,
          foreground: const Color(0xFFFFFFFF),
          borderColor: null,
          dashedBorder: false,
        );

      case AntButtonType.defaultStyle:
      case AntButtonType.dashed:
        final isDashed = type == AntButtonType.dashed;
        if (ghost) {
          // ghost=true 只对 primary / default 有意义：default ghost 效果同 default。
          return ButtonStyle(
            background: const Color(0x00000000),
            foreground: alias.colorText,
            borderColor: alias.colorBorder,
            dashedBorder: isDashed,
          );
        }
        return ButtonStyle(
          background: alias.colorBackgroundContainer,
          foreground: pressed
              ? primaryActive
              : hovered
                  ? primaryHover
                  : alias.colorText,
          borderColor: pressed
              ? primaryActive
              : hovered
                  ? primaryHover
                  : alias.colorBorder,
          dashedBorder: isDashed,
        );

      case AntButtonType.text:
        return ButtonStyle(
          background: pressed
              ? alias.colorFill
              : hovered
                  ? alias.colorFillSecondary
                  : const Color(0x00000000),
          foreground: alias.colorText,
          borderColor: null,
          dashedBorder: false,
        );

      case AntButtonType.link:
        return ButtonStyle(
          background: const Color(0x00000000),
          foreground: pressed
              ? primaryActive
              : hovered
                  ? primaryHover
                  : primary,
          borderColor: null,
          dashedBorder: false,
        );
    }
  }

  /// 根据 [size] 派生高度 / 水平 padding / 字号。
  static ButtonSizeSpec sizeSpec({
    required AntAliasToken alias,
    required AntComponentSize size,
  }) {
    return switch (size) {
      AntComponentSize.small => ButtonSizeSpec(
          height: resolveControlHeight(alias, AntComponentSize.small),
          horizontalPadding: 7,
          fontSize: 14,
        ),
      AntComponentSize.middle => ButtonSizeSpec(
          height: resolveControlHeight(alias, AntComponentSize.middle),
          horizontalPadding: 15,
          fontSize: 14,
        ),
      AntComponentSize.large => ButtonSizeSpec(
          height: resolveControlHeight(alias, AntComponentSize.large),
          horizontalPadding: 15,
          fontSize: 16,
        ),
    };
  }
}

/// 尺寸派生结果。
@immutable
class ButtonSizeSpec {
  const ButtonSizeSpec({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
}
```

- [ ] **Step 4：导出 AntButtonType / AntButtonShape（但 ButtonStyle 不导出）**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/button/ant_button.dart'
    show AntButton, AntButtonType, AntButtonShape;
```

> 这一行暂时会因为 `ant_button.dart` 还不存在报 analyze 错误。先不运行 analyze，在 Task 5b 完成后再跑。

- [ ] **Step 5：创建空的 ant_button.dart 占位（避免 analyze 炸）**

写入 `lib/src/components/button/ant_button.dart`：

```dart
// Implemented in Task 5b.
export 'package:ant_design_flutter/src/components/button/button_style.dart'
    show AntButtonType, AntButtonShape;
```

> 这是临时占位，Task 5b 替换为真实实现。`export` 让 barrel 里的 show 能找到枚举。

- [ ] **Step 6：运行 style 单测**

Run: `flutter test test/unit/components/button/button_style_test.dart`
Expected: 所有派生分支测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 7：提交**

```bash
git add lib/src/components/button/ \
        test/unit/components/button/ \
        lib/ant_design_flutter.dart
git commit -m "feat(button): add ButtonStyle visual derivation with unit tests"
```

### Task 5b：AntButton Widget

**Files:**
- Modify: `lib/src/components/button/ant_button.dart`（替换占位）
- Create: `test/widget/components/button/ant_button_test.dart`

- [ ] **Step 1：写失败测试 — widget 行为**

写入 `test/widget/components/button/ant_button_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntButton', () {
    testWidgets('default renders child and fires onPressed', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              onPressed: () => tapped++,
              child: const Text('click'),
            ),
          ),
        ),
      );
      expect(find.text('click'), findsOneWidget);
      await tester.tap(find.text('click'));
      expect(tapped, 1);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              disabled: true,
              onPressed: () => tapped++,
              child: const Text('d'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('d'));
      expect(tapped, 0);
    });

    testWidgets('loading swallows taps and renders spinner', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              loading: true,
              onPressed: () => tapped++,
              child: const Text('l'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('l'));
      expect(tapped, 0);
      // Spinner child 存在（通过 CustomPaint 间接断言）
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('block=true makes width expand', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: SizedBox(
            width: 300,
            child: AntButton(
              block: true,
              onPressed: () {},
              child: const Text('b'),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntButton));
      expect(size.width, 300);
    });

    testWidgets('small size → height 24', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              size: AntComponentSize.small,
              onPressed: () {},
              child: const Text('s'),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(AntButton)).height, 24);
    });

    testWidgets('large size → height 40', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              size: AntComponentSize.large,
              onPressed: () {},
              child: const Text('l'),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(AntButton)).height, 40);
    });

    testWidgets('circle shape → width = height', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              shape: AntButtonShape.circle,
              onPressed: () {},
              child: const Text('c'),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntButton));
      expect(size.width, size.height);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/button/ant_button_test.dart`
Expected: 失败，`AntButton` 未定义。

- [ ] **Step 3：实现 AntButton**

用下面内容**完整替换** `lib/src/components/button/ant_button.dart`（删除占位 export）：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:ant_design_flutter/src/components/button/button_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

export 'package:ant_design_flutter/src/components/button/button_style.dart'
    show AntButtonType, AntButtonShape;

/// Ant Design Flutter 的按钮组件。
///
/// 5 种 type × 3 种 size × 3 种 shape × `danger` / `ghost` / `block` /
/// `disabled` / `loading` 组合的视觉由 [ButtonStyle.resolve] / [ButtonStyle.sizeSpec]
/// 两个纯函数派生；本 widget 只负责把派生值拼装成渲染树。
class AntButton extends StatelessWidget {
  const AntButton({
    required this.child,
    super.key,
    this.onPressed,
    this.type = AntButtonType.defaultStyle,
    this.size = AntComponentSize.middle,
    this.shape = AntButtonShape.rectangle,
    this.danger = false,
    this.ghost = false,
    this.block = false,
    this.disabled = false,
    this.loading = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final AntButtonType type;
  final AntComponentSize size;
  final AntButtonShape shape;
  final bool danger;
  final bool ghost;
  final bool block;
  final bool disabled;
  final bool loading;

  bool get _effectiveDisabled => disabled || loading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sizeSpec = ButtonStyle.sizeSpec(alias: alias, size: size);

    return AntInteractionDetector(
      enabled: !_effectiveDisabled,
      onTap: onPressed,
      builder: (context, states) {
        final style = ButtonStyle.resolve(
          alias: alias,
          type: type,
          states: states,
          danger: danger,
          ghost: ghost,
        );

        final radius = switch (shape) {
          AntButtonShape.rectangle => alias.borderRadius,
          AntButtonShape.round => sizeSpec.height / 2,
          AntButtonShape.circle => sizeSpec.height / 2,
        };

        final content = _buildContent(style: style, sizeSpec: sizeSpec);

        Widget decorated;
        if (style.dashedBorder) {
          decorated = CustomPaint(
            painter: _DashedBorderPainter(
              color: style.borderColor ?? alias.colorBorder,
              radius: radius,
            ),
            child: ColoredBox(
              color: style.background,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizeSpec.horizontalPadding,
                ),
                child: content,
              ),
            ),
          );
        } else {
          decorated = DecoratedBox(
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(radius),
              border: style.borderColor == null
                  ? null
                  : Border.all(color: style.borderColor!, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizeSpec.horizontalPadding,
              ),
              child: content,
            ),
          );
        }

        final width = switch (shape) {
          AntButtonShape.circle => sizeSpec.height,
          _ => block ? double.infinity : null,
        };

        return SizedBox(
          height: sizeSpec.height,
          width: width,
          child: decorated,
        );
      },
    );
  }

  Widget _buildContent({
    required ButtonStyle style,
    required ButtonSizeSpec sizeSpec,
  }) {
    final textStyle = TextStyle(
      color: style.foreground,
      fontSize: sizeSpec.fontSize,
    );
    final text = DefaultTextStyle.merge(style: textStyle, child: child);
    if (!loading) {
      return Center(child: text);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingSpinner(color: style.foreground, size: sizeSpec.fontSize),
        SizedBox(width: sizeSpec.fontSize / 2),
        text,
      ],
    );
  }
}

/// 虚线边框自绘 painter（dashed type 专用）。
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 用 PathMetric 按固定 dash 长度 / gap 画。
    const dash = 4.0;
    const gap = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) {
    return old.color != color || old.radius != radius;
  }
}
```

- [ ] **Step 4：运行全部 button 测试**

Run: `flutter test test/unit/components/button/ test/widget/components/button/`
Expected: 所有测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 5：提交**

```bash
git add lib/src/components/button/ant_button.dart \
        test/widget/components/button/
git commit -m "feat(button): add AntButton widget (5 types x 3 sizes x 3 shapes)"
```

---

## Task 6：AntInput（EditableText 驱动，不引入 material）

### Task 6a：InputStyle 派生 + unit test

**目的：** border / background 由 `InputStyle.resolve` 给出，5 种可视状态穷举覆盖。

**Files:**
- Create: `lib/src/components/input/input_style.dart`
- Create: `test/unit/components/input/input_style_test.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/input/input_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/input/input_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('InputStyle.resolve', () {
    test('normal: borderColor=colorBorder, background=colorBackgroundContainer', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: false,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorBorder);
      expect(s.background, alias.colorBackgroundContainer);
      expect(s.focusRing, isNull);
    });

    test('hover → borderColor=colorPrimaryHover', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: true,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
    });

    test('focused → borderColor=colorPrimary + focusRing', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: false,
        focused: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.focusRing, isNotNull);
    });

    test('disabled → background=colorFillSecondary', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: false,
        focused: false,
        disabled: true,
      );
      expect(s.background, alias.colorFillSecondary);
    });

    test('status=error → borderColor=colorError', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.error,
        hovered: false,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorError);
    });

    test('status=warning → borderColor=colorWarning', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.warning,
        hovered: false,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorWarning);
    });
  });

  group('InputStyle.sizeSpec', () {
    test('middle height = alias.controlHeight, fontSize = alias.fontSize', () {
      final s = InputStyle.sizeSpec(alias: alias, size: AntComponentSize.middle);
      expect(s.height, alias.controlHeight);
      expect(s.fontSize, alias.fontSize);
    });
    test('small / large heights', () {
      expect(
        InputStyle.sizeSpec(alias: alias, size: AntComponentSize.small).height,
        24,
      );
      expect(
        InputStyle.sizeSpec(alias: alias, size: AntComponentSize.large).height,
        40,
      );
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/input/input_style_test.dart`
Expected: 失败，`InputStyle` 未定义。

- [ ] **Step 3：实现 InputStyle**

写入 `lib/src/components/input/input_style.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/component_status.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Input 视觉派生结果。
@immutable
class InputStyle {
  const InputStyle({
    required this.borderColor,
    required this.background,
    required this.focusRing,
  });

  final Color borderColor;
  final Color background;

  /// focus 时 2px 外环颜色；非 focus 时为 null。
  final Color? focusRing;

  static InputStyle resolve({
    required AntAliasToken alias,
    required AntStatus status,
    required bool hovered,
    required bool focused,
    required bool disabled,
  }) {
    final background = disabled
        ? alias.colorFillSecondary
        : alias.colorBackgroundContainer;

    Color borderColor;
    if (status == AntStatus.error) {
      borderColor = alias.colorError;
    } else if (status == AntStatus.warning) {
      borderColor = alias.colorWarning;
    } else if (disabled) {
      borderColor = alias.colorBorder;
    } else if (focused) {
      borderColor = alias.colorPrimary;
    } else if (hovered) {
      borderColor = alias.colorPrimaryHover;
    } else {
      borderColor = alias.colorBorder;
    }

    return InputStyle(
      borderColor: borderColor,
      background: background,
      focusRing: focused && !disabled && status == AntStatus.defaultStatus
          ? alias.colorPrimaryBackground
          : null,
    );
  }

  static InputSizeSpec sizeSpec({
    required AntAliasToken alias,
    required AntComponentSize size,
  }) {
    return InputSizeSpec(
      height: resolveControlHeight(alias, size),
      fontSize: switch (size) {
        AntComponentSize.small => alias.fontSize - 2,
        AntComponentSize.middle => alias.fontSize,
        AntComponentSize.large => alias.fontSize + 2,
      },
      horizontalPadding: switch (size) {
        AntComponentSize.small => 7,
        _ => 11,
      },
    );
  }
}

@immutable
class InputSizeSpec {
  const InputSizeSpec({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
  });

  final double height;
  final double fontSize;
  final double horizontalPadding;
}
```

- [ ] **Step 4：运行测试确认通过**

Run: `flutter test test/unit/components/input/input_style_test.dart`
Expected: 8 tests pass。

- [ ] **Step 5：提交**

```bash
git add lib/src/components/input/input_style.dart \
        test/unit/components/input/
git commit -m "feat(input): add InputStyle visual derivation"
```

### Task 6b：自绘 clear icon

**Files:**
- Create: `lib/src/components/input/_clear_icon.dart`

- [ ] **Step 1：实现 ClearIcon**

写入 `lib/src/components/input/_clear_icon.dart`：

```dart
import 'package:flutter/widgets.dart';

/// 内置的"清除"图标（8×8 的圆形 × 号）。
///
/// 库内私有：不引入 `package:flutter/material.dart` 的 `Icons.cancel`。
/// AntInput.allowClear=true 时在 suffix 之前渲染。
class ClearIcon extends StatelessWidget {
  const ClearIcon({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 12,
      child: CustomPaint(painter: _ClearIconPainter(color)),
    );
  }
}

class _ClearIconPainter extends CustomPainter {
  _ClearIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final fill = Paint()..color = color;
    canvas.drawCircle(center, radius, fill);

    final stroke = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final inset = radius * 0.45;
    canvas
      ..drawLine(
        Offset(center.dx - inset, center.dy - inset),
        Offset(center.dx + inset, center.dy + inset),
        stroke,
      )
      ..drawLine(
        Offset(center.dx - inset, center.dy + inset),
        Offset(center.dx + inset, center.dy - inset),
        stroke,
      );
  }

  @override
  bool shouldRepaint(covariant _ClearIconPainter old) => old.color != color;
}
```

> 此文件内容简单，不单独写测试（由 Task 6c 的 AntInput.allowClear 测间接覆盖）。

- [ ] **Step 2：analyze 确认无 warning**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 3：提交**

```bash
git add lib/src/components/input/_clear_icon.dart
git commit -m "feat(input): add private clear icon painter"
```

### Task 6c：AntInput Widget

**Files:**
- Create: `lib/src/components/input/ant_input.dart`
- Create: `test/widget/components/input/ant_input_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/input/ant_input_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntInput', () {
    testWidgets('renders placeholder when empty', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntInput(placeholder: 'name')),
      );
      expect(find.text('name'), findsOneWidget);
    });

    testWidgets('typing triggers onChanged', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(onChanged: (v) => last = v)),
      );
      await tester.enterText(find.byType(EditableText), 'hi');
      expect(last, 'hi');
    });

    testWidgets('disabled swallows input', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(disabled: true, onChanged: (v) => last = v)),
      );
      // disabled 下 EditableText.readOnly=true，tester.enterText 仍会注入，
      // 但 onChanged 不触发（因为我们内部拦截）。
      await tester.enterText(find.byType(EditableText), 'x');
      expect(last, '');
    });

    testWidgets('allowClear clears text on tap', (tester) async {
      var current = 'abc';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: AntInput(
              allowClear: true,
              value: current,
              onChanged: (v) => setState(() => current = v),
            ),
          ),
        ),
      );

      // 模拟 hover 使 clear icon 显示
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(AntInput)));
      await tester.pump();

      // 点击 clear icon（位于 Input 最右侧）
      final inputRight = tester.getRect(find.byType(AntInput)).centerRight;
      await tester.tapAt(Offset(inputRight.dx - 14, inputRight.dy));
      await tester.pump();
      expect(current, '');
    });

    testWidgets('maxLength limits input', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(maxLength: 3, onChanged: (v) => last = v)),
      );
      await tester.enterText(find.byType(EditableText), 'abcdef');
      expect(last.length, 3);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/input/ant_input_test.dart`
Expected: 失败，`AntInput` 未定义。

- [ ] **Step 3：实现 AntInput**

写入 `lib/src/components/input/ant_input.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/component_status.dart';
import 'package:ant_design_flutter/src/components/input/_clear_icon.dart';
import 'package:ant_design_flutter/src/components/input/input_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 的单行输入框。
///
/// 内部使用 `package:flutter/widgets.dart` 的 `EditableText`，不引入 material。
/// 长按 / 右键唤出的选区工具栏由平台原生提供（`selectionControls` 留 null）。
/// 2.1 评估是否补 widgets-only toolbar。
class AntInput extends StatefulWidget {
  const AntInput({
    super.key,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.size = AntComponentSize.middle,
    this.status = AntStatus.defaultStatus,
    this.disabled = false,
    this.readOnly = false,
    this.allowClear = false,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.controller,
    this.focusNode,
  });

  final String? value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final AntComponentSize size;
  final AntStatus status;
  final bool disabled;
  final bool readOnly;
  final bool allowClear;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<AntInput> createState() => _AntInputState();
}

class _AntInputState extends State<AntInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocus;
  bool _hovered = false;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());
  FocusNode get _focus => widget.focusNode ?? (_internalFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
    _focus.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant AntInput old) {
    super.didUpdateWidget(old);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_handleFocus);
      _internalFocus?.dispose();
      _internalFocus = null;
      _focus.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocus);
    _internalFocus?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  void _handleFocus() => setState(() => _focused = _focus.hasFocus);

  void _handleChanged(String value) {
    if (widget.disabled || widget.readOnly) return;
    widget.onChanged?.call(value);
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sizeSpec = InputStyle.sizeSpec(alias: alias, size: widget.size);
    final style = InputStyle.resolve(
      alias: alias,
      status: widget.status,
      hovered: _hovered,
      focused: _focused,
      disabled: widget.disabled,
    );

    final textStyle = TextStyle(
      color: widget.disabled ? alias.colorTextDisabled : alias.colorText,
      fontSize: sizeSpec.fontSize,
    );

    final showClear = widget.allowClear &&
        _hovered &&
        !widget.disabled &&
        _controller.text.isNotEmpty;

    final editable = EditableText(
      controller: _controller,
      focusNode: _focus,
      style: textStyle,
      cursorColor: alias.colorPrimary,
      backgroundCursorColor: alias.colorBorder,
      readOnly: widget.disabled || widget.readOnly,
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
      maxLines: 1,
      inputFormatters: widget.maxLength == null
          ? null
          : [LengthLimitingTextInputFormatter(widget.maxLength)],
      selectionColor: alias.colorPrimaryBackground,
    );

    final textWithPlaceholder = Stack(
      children: [
        if ((widget.value ?? _controller.text).isEmpty &&
            widget.placeholder != null)
          IgnorePointer(
            child: Text(
              widget.placeholder!,
              style: textStyle.copyWith(color: alias.colorTextTertiary),
            ),
          ),
        editable,
      ],
    );

    final row = Row(
      children: [
        if (widget.prefix != null) ...[
          widget.prefix!,
          const SizedBox(width: 4),
        ],
        Expanded(child: textWithPlaceholder),
        if (showClear) ...[
          GestureDetector(
            onTap: _handleClear,
            child: ClearIcon(color: alias.colorTextTertiary),
          ),
          const SizedBox(width: 4),
        ],
        if (widget.suffix != null) ...[
          const SizedBox(width: 4),
          widget.suffix!,
        ],
      ],
    );

    final decoration = BoxDecoration(
      color: style.background,
      borderRadius: BorderRadius.circular(alias.borderRadius),
      border: Border.all(color: style.borderColor, width: 1),
      boxShadow: style.focusRing == null
          ? null
          : [BoxShadow(color: style.focusRing!, blurRadius: 0, spreadRadius: 2)],
    );

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.text,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        height: sizeSpec.height,
        padding: EdgeInsets.symmetric(horizontal: sizeSpec.horizontalPadding),
        decoration: decoration,
        child: row,
      ),
    );
  }
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/input/ant_input.dart' show AntInput;
```

- [ ] **Step 5：运行全部 input 测试**

Run: `flutter test test/unit/components/input/ test/widget/components/input/`
Expected: 所有测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/components/input/ant_input.dart \
        test/widget/components/input/ \
        lib/ant_design_flutter.dart
git commit -m "feat(input): add AntInput (EditableText, no material dependency)"
```

---

## Task 7：AntCheckbox + AntCheckboxGroup

### Task 7a：AntOption<T> 数据类

**Files:**
- Create: `lib/src/components/checkbox/ant_option.dart`
- Create: `test/unit/components/checkbox/ant_option_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/checkbox/ant_option_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntOption', () {
    test('fields assigned', () {
      const opt = AntOption<int>(value: 1, label: 'one');
      expect(opt.value, 1);
      expect(opt.label, 'one');
      expect(opt.disabled, false);
    });

    test('equality by value/label/disabled', () {
      expect(
        const AntOption<int>(value: 1, label: 'a'),
        const AntOption<int>(value: 1, label: 'a'),
      );
      expect(
        const AntOption<int>(value: 1, label: 'a'),
        isNot(const AntOption<int>(value: 2, label: 'a')),
      );
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/checkbox/ant_option_test.dart`
Expected: 失败，`AntOption` 未定义。

- [ ] **Step 3：实现 AntOption**

写入 `lib/src/components/checkbox/ant_option.dart`：

```dart
import 'package:flutter/foundation.dart';

/// Group 系列组件（`AntCheckboxGroup` / `AntRadioGroup`）的选项数据类。
///
/// `radio_group.dart` 显式 import 本文件复用（spec §2 例外条款）。
@immutable
class AntOption<T> {
  const AntOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final String label;
  final bool disabled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntOption<T> &&
        other.value == value &&
        other.label == label &&
        other.disabled == disabled;
  }

  @override
  int get hashCode => Object.hash(value, label, disabled);
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/checkbox/ant_option.dart' show AntOption;
```

- [ ] **Step 5：运行测试 + 提交**

Run: `flutter test test/unit/components/checkbox/ant_option_test.dart`
Expected: 2 tests pass。

```bash
git add lib/src/components/checkbox/ant_option.dart \
        test/unit/components/checkbox/ant_option_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(checkbox): add AntOption<T> data class"
```

### Task 7b：CheckboxStyle 派生

**Files:**
- Create: `lib/src/components/checkbox/checkbox_style.dart`
- Create: `test/unit/components/checkbox/checkbox_style_test.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/checkbox/checkbox_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/checkbox/checkbox_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('CheckboxStyle.resolve', () {
    test('unchecked: border=colorBorder, fill=white, tick absent', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: false,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorBorder);
      expect(s.fillColor, const Color(0xFFFFFFFF));
      expect(s.tickColor, isNull);
    });

    test('unchecked hover: border=colorPrimary', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: false,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
    });

    test('checked: border/fill=colorPrimary, tick=white', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.fillColor, alias.colorPrimary);
      expect(s.tickColor, const Color(0xFFFFFFFF));
    });

    test('checked hover: border/fill=colorPrimaryHover', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
      expect(s.fillColor, alias.colorPrimaryHover);
    });

    test('disabled: fill=colorFillSecondary, tick=colorTextDisabled', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: true,
      );
      expect(s.fillColor, alias.colorFillSecondary);
      expect(s.tickColor, alias.colorTextDisabled);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/checkbox/checkbox_style_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 CheckboxStyle**

写入 `lib/src/components/checkbox/checkbox_style.dart`：

```dart
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Checkbox 与 Radio 共用的派生数据（radio_style.dart 会 re-export 类型）。
@immutable
class CheckboxStyle {
  const CheckboxStyle({
    required this.borderColor,
    required this.fillColor,
    required this.tickColor,
  });

  final Color borderColor;
  final Color fillColor;

  /// null 表示不画钩 / 点（unchecked 状态）。
  final Color? tickColor;

  static CheckboxStyle resolve({
    required AntAliasToken alias,
    required bool checked,
    required bool hovered,
    required bool disabled,
  }) {
    if (disabled) {
      return CheckboxStyle(
        borderColor: alias.colorBorder,
        fillColor: alias.colorFillSecondary,
        tickColor: checked ? alias.colorTextDisabled : null,
      );
    }
    if (!checked) {
      return CheckboxStyle(
        borderColor: hovered ? alias.colorPrimary : alias.colorBorder,
        fillColor: const Color(0xFFFFFFFF),
        tickColor: null,
      );
    }
    final primary = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    return CheckboxStyle(
      borderColor: primary,
      fillColor: primary,
      tickColor: const Color(0xFFFFFFFF),
    );
  }
}
```

- [ ] **Step 4：运行测试 + 提交**

Run: `flutter test test/unit/components/checkbox/checkbox_style_test.dart`
Expected: 5 tests pass。

```bash
git add lib/src/components/checkbox/checkbox_style.dart \
        test/unit/components/checkbox/checkbox_style_test.dart
git commit -m "feat(checkbox): add CheckboxStyle derivation"
```

### Task 7c：AntCheckbox Widget

**Files:**
- Create: `lib/src/components/checkbox/ant_checkbox.dart`
- Create: `test/widget/components/checkbox/ant_checkbox_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/checkbox/ant_checkbox_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntCheckbox', () {
    testWidgets('tap toggles checked via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckbox(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
                label: const Text('agree'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('agree'));
      await tester.pump();
      expect(checked, isTrue);

      await tester.tap(find.text('agree'));
      await tester.pump();
      expect(checked, isFalse);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckbox(
              checked: false,
              disabled: true,
              onChanged: (_) => changed = true,
              label: const Text('x'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump();
      expect(changed, isFalse);
    });

    testWidgets('renders without label', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckbox(checked: true, onChanged: (_) {}),
          ),
        ),
      );
      expect(find.byType(AntCheckbox), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/checkbox/ant_checkbox_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 AntCheckbox**

写入 `lib/src/components/checkbox/ant_checkbox.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/checkbox/checkbox_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 的复选框。
class AntCheckbox extends StatelessWidget {
  const AntCheckbox({
    required this.checked,
    required this.onChanged,
    super.key,
    this.label,
    this.disabled = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: () => onChanged?.call(!checked),
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = CheckboxStyle.resolve(
          alias: alias,
          checked: checked,
          hovered: hovered,
          disabled: disabled,
        );
        final box = SizedBox.square(
          dimension: 14,
          child: CustomPaint(
            painter: _CheckboxPainter(style: style, radius: 4),
          ),
        );
        if (label == null) return box;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            box,
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: disabled ? alias.colorTextDisabled : alias.colorText,
              ),
              child: label!,
            ),
          ],
        );
      },
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({required this.style, required this.radius});

  final CheckboxStyle style;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    canvas
      ..drawRRect(rrect, Paint()..color = style.fillColor)
      ..drawRRect(
        rrect,
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

    if (style.tickColor == null) return;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.43, size.height * 0.72)
      ..lineTo(size.width * 0.8, size.height * 0.3);
    canvas.drawPath(
      path,
      Paint()
        ..color = style.tickColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter old) =>
      old.style != style || old.radius != radius;
}
```

> `CheckboxStyle` 没有 `==` / `hashCode` —— `shouldRepaint` 里的 `old.style != style` 当成"总是重绘"也没问题（检查会失败 → 返回 true），但更干净的做法是我们后面 widget 层用 `AnimatedBuilder` 驱动：这里简化，保留 `!=` 比较（Dart 默认按 identity），每次重建都会重绘，成本可接受。

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/checkbox/ant_checkbox.dart' show AntCheckbox;
```

- [ ] **Step 5：运行测试 + 提交**

Run: `flutter test test/widget/components/checkbox/ant_checkbox_test.dart`
Expected: 3 tests pass。

```bash
git add lib/src/components/checkbox/ant_checkbox.dart \
        test/widget/components/checkbox/ant_checkbox_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(checkbox): add AntCheckbox widget"
```

### Task 7d：AntCheckboxGroup

**Files:**
- Create: `lib/src/components/checkbox/ant_checkbox_group.dart`
- Create: `test/widget/components/checkbox/ant_checkbox_group_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/checkbox/ant_checkbox_group_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntCheckboxGroup', () {
    testWidgets('renders one checkbox per option', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckboxGroup<String>(
              options: const [
                AntOption(value: 'a', label: 'A'),
                AntOption(value: 'b', label: 'B'),
                AntOption(value: 'c', label: 'C'),
              ],
              value: const ['a'],
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(AntCheckbox), findsNWidgets(3));
    });

    testWidgets('tapping option emits updated list', (tester) async {
      var current = <String>['a'];
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckboxGroup<String>(
                options: const [
                  AntOption(value: 'a', label: 'A'),
                  AntOption(value: 'b', label: 'B'),
                ],
                value: current,
                onChanged: (v) => setState(() => current = v),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(current, unorderedEquals(['a', 'b']));

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(current, ['b']);
    });

    testWidgets('disabled group swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckboxGroup<String>(
              disabled: true,
              options: const [AntOption(value: 'a', label: 'A')],
              value: const [],
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, isFalse);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/checkbox/ant_checkbox_group_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 AntCheckboxGroup**

写入 `lib/src/components/checkbox/ant_checkbox_group.dart`：

```dart
import 'package:ant_design_flutter/src/components/checkbox/ant_checkbox.dart';
import 'package:ant_design_flutter/src/components/checkbox/ant_option.dart';
import 'package:flutter/widgets.dart';

/// 多选组：`options` 驱动，受控 `value` + `onChanged`。
class AntCheckboxGroup<T> extends StatelessWidget {
  const AntCheckboxGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final bool disabled;
  final Axis direction;

  void _toggle(T v, bool checked) {
    final next = [...value];
    if (checked) {
      if (!next.contains(v)) next.add(v);
    } else {
      next.remove(v);
    }
    onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (opt) => Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(bottom: 8),
            child: AntCheckbox(
              checked: value.contains(opt.value),
              disabled: disabled || opt.disabled,
              onChanged: disabled
                  ? null
                  : (checked) => _toggle(opt.value, checked),
              label: Text(opt.label),
            ),
          ),
        )
        .toList();
    return direction == Axis.horizontal
        ? Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/checkbox/ant_checkbox_group.dart'
    show AntCheckboxGroup;
```

- [ ] **Step 5：运行测试 + 提交**

Run: `flutter test test/widget/components/checkbox/`
Expected: 所有 checkbox 测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

```bash
git add lib/src/components/checkbox/ant_checkbox_group.dart \
        test/widget/components/checkbox/ant_checkbox_group_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(checkbox): add AntCheckboxGroup (options list API)"
```

---

## Task 8：AntRadio + AntRadioGroup

### Task 8a：RadioStyle 派生

**Files:**
- Create: `lib/src/components/radio/radio_style.dart`
- Create: `test/unit/components/radio/radio_style_test.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/radio/radio_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/radio/radio_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('RadioStyle.resolve', () {
    test('unselected: border=colorBorder, inner=null', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: false,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorBorder);
      expect(s.innerDotColor, isNull);
    });

    test('unselected hover: border=colorPrimary', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: false,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
    });

    test('selected: border=colorPrimary, inner=colorPrimary', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: true,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.innerDotColor, alias.colorPrimary);
    });

    test('disabled selected: inner=colorTextDisabled', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: true,
        hovered: false,
        disabled: true,
      );
      expect(s.innerDotColor, alias.colorTextDisabled);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/radio/radio_style_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 RadioStyle**

写入 `lib/src/components/radio/radio_style.dart`：

```dart
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

@immutable
class RadioStyle {
  const RadioStyle({required this.borderColor, required this.innerDotColor});

  final Color borderColor;

  /// null 表示 unselected（不画内圆点）。
  final Color? innerDotColor;

  static RadioStyle resolve({
    required AntAliasToken alias,
    required bool selected,
    required bool hovered,
    required bool disabled,
  }) {
    if (disabled) {
      return RadioStyle(
        borderColor: alias.colorBorder,
        innerDotColor: selected ? alias.colorTextDisabled : null,
      );
    }
    if (!selected) {
      return RadioStyle(
        borderColor: hovered ? alias.colorPrimary : alias.colorBorder,
        innerDotColor: null,
      );
    }
    final primary = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    return RadioStyle(borderColor: primary, innerDotColor: primary);
  }
}
```

- [ ] **Step 4：运行测试 + 提交**

Run: `flutter test test/unit/components/radio/radio_style_test.dart`
Expected: 4 tests pass。

```bash
git add lib/src/components/radio/radio_style.dart \
        test/unit/components/radio/radio_style_test.dart
git commit -m "feat(radio): add RadioStyle derivation"
```

### Task 8b：AntRadio + AntRadioGroup widgets

**Files:**
- Create: `lib/src/components/radio/ant_radio.dart`
- Create: `lib/src/components/radio/ant_radio_group.dart`
- Create: `test/widget/components/radio/ant_radio_test.dart`
- Create: `test/widget/components/radio/ant_radio_group_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试 — AntRadio**

写入 `test/widget/components/radio/ant_radio_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntRadio', () {
    testWidgets('tap fires onChanged with value', (tester) async {
      String? picked;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntRadio<String>(
              value: 'a',
              groupValue: null,
              onChanged: (v) => picked = v,
              label: const Text('A'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(picked, 'a');
    });

    testWidgets('disabled swallows taps', (tester) async {
      String? picked;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntRadio<String>(
              value: 'a',
              groupValue: null,
              disabled: true,
              onChanged: (v) => picked = v,
              label: const Text('X'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('X'));
      expect(picked, isNull);
    });
  });
}
```

- [ ] **Step 2：写失败测试 — AntRadioGroup**

写入 `test/widget/components/radio/ant_radio_group_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AntRadioGroup: tapping an option fires onChanged with value',
      (tester) async {
    String? current;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (ctx, setState) => AntApp(
          home: Center(
            child: AntRadioGroup<String>(
              options: const [
                AntOption(value: 'a', label: 'A'),
                AntOption(value: 'b', label: 'B'),
              ],
              value: current,
              onChanged: (v) => setState(() => current = v),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(current, 'b');
  });

  testWidgets('AntRadioGroup disabled swallows taps', (tester) async {
    var changed = false;
    await tester.pumpWidget(
      AntApp(
        home: Center(
          child: AntRadioGroup<String>(
            disabled: true,
            options: const [AntOption(value: 'a', label: 'A')],
            value: null,
            onChanged: (_) => changed = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('A'));
    expect(changed, isFalse);
  });
}
```

- [ ] **Step 3：运行测试确认失败**

Run: `flutter test test/widget/components/radio/`
Expected: 失败，`AntRadio` / `AntRadioGroup` 未定义。

- [ ] **Step 4：实现 AntRadio**

写入 `lib/src/components/radio/ant_radio.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/radio/radio_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

class AntRadio<T> extends StatelessWidget {
  const AntRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.label,
    this.disabled = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Widget? label;
  final bool disabled;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: () {
        if (!_selected) onChanged?.call(value);
      },
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = RadioStyle.resolve(
          alias: alias,
          selected: _selected,
          hovered: hovered,
          disabled: disabled,
        );
        final circle = SizedBox.square(
          dimension: 16,
          child: CustomPaint(painter: _RadioPainter(style: style)),
        );
        if (label == null) return circle;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            circle,
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: disabled ? alias.colorTextDisabled : alias.colorText,
              ),
              child: label!,
            ),
          ],
        );
      },
    );
  }
}

class _RadioPainter extends CustomPainter {
  _RadioPainter({required this.style});

  final RadioStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    canvas
      ..drawCircle(
        center,
        radius - 0.5,
        Paint()..color = const Color(0xFFFFFFFF),
      )
      ..drawCircle(
        center,
        radius - 0.5,
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

    if (style.innerDotColor == null) return;
    canvas.drawCircle(
      center,
      radius * 0.45,
      Paint()..color = style.innerDotColor!,
    );
  }

  @override
  bool shouldRepaint(covariant _RadioPainter old) => true;
}
```

- [ ] **Step 5：实现 AntRadioGroup**

写入 `lib/src/components/radio/ant_radio_group.dart`：

```dart
import 'package:ant_design_flutter/src/components/checkbox/ant_option.dart';
import 'package:ant_design_flutter/src/components/radio/ant_radio.dart';
import 'package:flutter/widgets.dart';

/// 单选组：`options` 驱动，受控 `value` + `onChanged`。
class AntRadioGroup<T> extends StatelessWidget {
  const AntRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool disabled;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (opt) => Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(bottom: 8),
            child: AntRadio<T>(
              value: opt.value,
              groupValue: value,
              disabled: disabled || opt.disabled,
              onChanged: disabled ? null : onChanged,
              label: Text(opt.label),
            ),
          ),
        )
        .toList();
    return direction == Axis.horizontal
        ? Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }
}
```

- [ ] **Step 6：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/radio/ant_radio.dart' show AntRadio;
export 'src/components/radio/ant_radio_group.dart' show AntRadioGroup;
```

- [ ] **Step 7：运行测试 + 提交**

Run: `flutter test test/unit/components/radio/ test/widget/components/radio/`
Expected: 所有 radio 测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

```bash
git add lib/src/components/radio/ \
        test/widget/components/radio/ \
        lib/ant_design_flutter.dart
git commit -m "feat(radio): add AntRadio + AntRadioGroup (reuses AntOption)"
```

---

## Task 9：AntSwitch

### Task 9a：SwitchStyle 派生

**Files:**
- Create: `lib/src/components/switch/switch_style.dart`
- Create: `test/unit/components/switch/switch_style_test.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/switch/switch_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/switch/switch_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('SwitchStyle.resolve', () {
    test('unchecked track = colorTextTertiary', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: false,
        hovered: false,
        disabled: false,
      );
      expect(s.trackColor, alias.colorTextTertiary);
    });

    test('checked track = colorPrimary', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: false,
      );
      expect(s.trackColor, alias.colorPrimary);
    });

    test('checked + hover → colorPrimaryHover', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: true,
        disabled: false,
      );
      expect(s.trackColor, alias.colorPrimaryHover);
    });

    test('disabled track has 0.4 alpha baseline', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: true,
      );
      expect(s.opacity, 0.4);
    });
  });

  group('SwitchStyle.sizeSpec', () {
    test('middle: 28x16, thumb=14', () {
      final s = SwitchStyle.sizeSpec(AntComponentSize.middle);
      expect(s.width, 28);
      expect(s.height, 16);
      expect(s.thumbDiameter, 14);
    });
    test('small: 22x14, thumb=12', () {
      final s = SwitchStyle.sizeSpec(AntComponentSize.small);
      expect(s.width, 22);
      expect(s.height, 14);
      expect(s.thumbDiameter, 12);
    });
    test('large maps to middle spec', () {
      expect(
        SwitchStyle.sizeSpec(AntComponentSize.large),
        SwitchStyle.sizeSpec(AntComponentSize.middle),
      );
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/switch/switch_style_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 SwitchStyle**

写入 `lib/src/components/switch/switch_style.dart`：

```dart
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

@immutable
class SwitchStyle {
  const SwitchStyle({required this.trackColor, required this.opacity});

  final Color trackColor;
  final double opacity;

  static SwitchStyle resolve({
    required AntAliasToken alias,
    required bool checked,
    required bool hovered,
    required bool disabled,
  }) {
    final Color track;
    if (checked) {
      track = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    } else {
      track = hovered ? alias.colorTextSecondary : alias.colorTextTertiary;
    }
    return SwitchStyle(trackColor: track, opacity: disabled ? 0.4 : 1.0);
  }

  static SwitchSizeSpec sizeSpec(AntComponentSize size) {
    return switch (size) {
      AntComponentSize.small =>
        const SwitchSizeSpec(width: 22, height: 14, thumbDiameter: 12),
      AntComponentSize.middle || AntComponentSize.large =>
        const SwitchSizeSpec(width: 28, height: 16, thumbDiameter: 14),
    };
  }
}

@immutable
class SwitchSizeSpec {
  const SwitchSizeSpec({
    required this.width,
    required this.height,
    required this.thumbDiameter,
  });

  final double width;
  final double height;
  final double thumbDiameter;

  @override
  bool operator ==(Object other) {
    return other is SwitchSizeSpec &&
        other.width == width &&
        other.height == height &&
        other.thumbDiameter == thumbDiameter;
  }

  @override
  int get hashCode => Object.hash(width, height, thumbDiameter);
}
```

- [ ] **Step 4：运行测试 + 提交**

Run: `flutter test test/unit/components/switch/switch_style_test.dart`
Expected: 7 tests pass。

```bash
git add lib/src/components/switch/switch_style.dart \
        test/unit/components/switch/switch_style_test.dart
git commit -m "feat(switch): add SwitchStyle derivation"
```

### Task 9b：AntSwitch Widget

**Files:**
- Create: `lib/src/components/switch/ant_switch.dart`
- Create: `test/widget/components/switch/ant_switch_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/switch/ant_switch_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSwitch', () {
    testWidgets('tap toggles via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntSwitch(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      await tester.pumpAndSettle();
      expect(checked, isTrue);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              disabled: true,
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      expect(changed, isFalse);
    });

    testWidgets('loading swallows taps and renders spinner', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              loading: true,
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      expect(changed, isFalse);
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('middle renders 28x16', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(checked: false, onChanged: (_) {}),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntSwitch));
      expect(size.width, 28);
      expect(size.height, 16);
    });

    testWidgets('small renders 22x14', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              size: AntComponentSize.small,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntSwitch));
      expect(size.width, 22);
      expect(size.height, 14);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/switch/ant_switch_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 AntSwitch**

写入 `lib/src/components/switch/ant_switch.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:ant_design_flutter/src/components/switch/switch_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 开关。
///
/// - middle / large 视觉等同（28×16，thumb 14）；small 为 22×14，thumb 12。
/// - 切换带 200ms 平滑动画；`loading=true` 时 thumb 中心替换为旋转 spinner、
///   整体降不透明度到 0.4，且不响应点击。
class AntSwitch extends StatelessWidget {
  const AntSwitch({
    required this.checked,
    required this.onChanged,
    super.key,
    this.size = AntComponentSize.middle,
    this.disabled = false,
    this.loading = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final AntComponentSize size;
  final bool disabled;
  final bool loading;

  bool get _effectiveDisabled => disabled || loading;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final spec = SwitchStyle.sizeSpec(size);
    return AntInteractionDetector(
      enabled: !_effectiveDisabled,
      onTap: () => onChanged?.call(!checked),
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = SwitchStyle.resolve(
          alias: alias,
          checked: checked,
          hovered: hovered,
          disabled: _effectiveDisabled,
        );
        return Opacity(
          opacity: style.opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: spec.width,
            height: spec.height,
            decoration: BoxDecoration(
              color: style.trackColor,
              borderRadius: BorderRadius.circular(spec.height / 2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment:
                  checked ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all((spec.height - spec.thumbDiameter) / 2),
                child: SizedBox.square(
                  dimension: spec.thumbDiameter,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: loading
                        ? Center(
                            child: LoadingSpinner(
                              color: style.trackColor,
                              size: spec.thumbDiameter * 0.7,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/switch/ant_switch.dart' show AntSwitch;
```

- [ ] **Step 5：运行测试 + 提交**

Run: `flutter test test/unit/components/switch/ test/widget/components/switch/`
Expected: 所有 switch 测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

```bash
git add lib/src/components/switch/ant_switch.dart \
        test/widget/components/switch/ant_switch_test.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(switch): add AntSwitch with loading state"
```

---

## Task 10：AntTag + AntCheckableTag

### Task 10a：TagStyle 派生 + 对比色工具

**Files:**
- Create: `lib/src/components/tag/tag_style.dart`
- Create: `test/unit/components/tag/tag_style_test.dart`

- [ ] **Step 1：写失败测试**

写入 `test/unit/components/tag/tag_style_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/tag/tag_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('TagStyle.resolveDefault', () {
    test('no color → fill=colorFillSecondary, foreground=colorText', () {
      final s = TagStyle.resolveDefault(alias: alias, color: null);
      expect(s.background, alias.colorFillSecondary);
      expect(s.foreground, alias.colorText);
      expect(s.borderColor, alias.colorBorder);
    });

    test('light color → foreground = colorText (dark text on light background)', () {
      const lightYellow = Color(0xFFFFF8B8);
      final s = TagStyle.resolveDefault(alias: alias, color: lightYellow);
      expect(s.background, lightYellow);
      expect(s.foreground, alias.colorText);
    });

    test('dark color → foreground = white', () {
      const navy = Color(0xFF000080);
      final s = TagStyle.resolveDefault(alias: alias, color: navy);
      expect(s.background, navy);
      expect(s.foreground, const Color(0xFFFFFFFF));
    });
  });

  group('TagStyle.resolveCheckable', () {
    test('checked → colorPrimary background, white foreground', () {
      final s = TagStyle.resolveCheckable(alias: alias, checked: true);
      expect(s.background, alias.colorPrimary);
      expect(s.foreground, const Color(0xFFFFFFFF));
    });

    test('unchecked → colorFillSecondary background, colorText foreground', () {
      final s = TagStyle.resolveCheckable(alias: alias, checked: false);
      expect(s.background, alias.colorFillSecondary);
      expect(s.foreground, alias.colorText);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/unit/components/tag/tag_style_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 TagStyle**

写入 `lib/src/components/tag/tag_style.dart`：

```dart
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

@immutable
class TagStyle {
  const TagStyle({
    required this.background,
    required this.foreground,
    required this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color borderColor;

  static TagStyle resolveDefault({
    required AntAliasToken alias,
    required Color? color,
  }) {
    if (color == null) {
      return TagStyle(
        background: alias.colorFillSecondary,
        foreground: alias.colorText,
        borderColor: alias.colorBorder,
      );
    }
    final foreground =
        _luminance(color) > 0.5 ? alias.colorText : const Color(0xFFFFFFFF);
    return TagStyle(
      background: color,
      foreground: foreground,
      borderColor: _withAlpha(color, 0.4),
    );
  }

  static TagStyle resolveCheckable({
    required AntAliasToken alias,
    required bool checked,
  }) {
    if (checked) {
      return TagStyle(
        background: alias.colorPrimary,
        foreground: const Color(0xFFFFFFFF),
        borderColor: alias.colorPrimary,
      );
    }
    return TagStyle(
      background: alias.colorFillSecondary,
      foreground: alias.colorText,
      borderColor: alias.colorBorder,
    );
  }
}

/// sRGB relative luminance（简化版，未做 gamma 反变换，对比色挑选够用）。
double _luminance(Color c) {
  final r = c.r;
  final g = c.g;
  final b = c.b;
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

Color _withAlpha(Color c, double alpha) {
  return Color.fromARGB(
    (alpha * 255).round().clamp(0, 255),
    (c.r * 255).round(),
    (c.g * 255).round(),
    (c.b * 255).round(),
  );
}
```

- [ ] **Step 4：运行测试 + 提交**

Run: `flutter test test/unit/components/tag/tag_style_test.dart`
Expected: 5 tests pass。

```bash
git add lib/src/components/tag/tag_style.dart \
        test/unit/components/tag/tag_style_test.dart
git commit -m "feat(tag): add TagStyle with contrast-aware foreground"
```

### Task 10b：AntTag + AntCheckableTag widgets

**Files:**
- Create: `lib/src/components/tag/ant_tag.dart`
- Create: `test/widget/components/tag/ant_tag_test.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写失败测试**

写入 `test/widget/components/tag/ant_tag_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTag', () {
    testWidgets('default renders child', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTag(child: Text('t'))),
      );
      expect(find.text('t'), findsOneWidget);
    });

    testWidgets('closable=true + tap fires onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntTag(
              closable: true,
              onClose: () => closed = true,
              child: const Text('c'),
            ),
          ),
        ),
      );
      // 点击最右侧 × 图标
      final right = tester.getRect(find.byType(AntTag)).centerRight;
      await tester.tapAt(Offset(right.dx - 6, right.dy));
      expect(closed, isTrue);
    });
  });

  group('AntCheckableTag', () {
    testWidgets('tap toggles via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckableTag(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
                child: const Text('k'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('k'));
      await tester.pump();
      expect(checked, isTrue);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/components/tag/ant_tag_test.dart`
Expected: 失败。

- [ ] **Step 3：实现 AntTag 和 AntCheckableTag**

写入 `lib/src/components/tag/ant_tag.dart`：

```dart
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/tag/tag_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 展示性 Tag：支持自定义底色（对比色自动）、可选关闭按钮。
///
/// 可选中语义见 `AntCheckableTag`（故意拆分以避免互斥属性）。
class AntTag extends StatelessWidget {
  const AntTag({
    required this.child,
    super.key,
    this.color,
    this.bordered = true,
    this.closable = false,
    this.onClose,
  });

  final Widget child;
  final Color? color;
  final bool bordered;
  final bool closable;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final style = TagStyle.resolveDefault(alias: alias, color: color);
    return _TagShell(
      background: style.background,
      borderColor: bordered ? style.borderColor : null,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: style.foreground, fontSize: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            if (closable) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: SizedBox.square(
                  dimension: 10,
                  child: CustomPaint(
                    painter: _CloseIconPainter(color: style.foreground),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 可选中 Tag：`checked` 状态 + `onChanged(bool)`。
class AntCheckableTag extends StatelessWidget {
  const AntCheckableTag({
    required this.child,
    required this.checked,
    required this.onChanged,
    super.key,
  });

  final Widget child;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      onTap: () => onChanged?.call(!checked),
      builder: (context, _) {
        final style = TagStyle.resolveCheckable(alias: alias, checked: checked);
        return _TagShell(
          background: style.background,
          borderColor: style.borderColor,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: style.foreground, fontSize: 12),
            child: child,
          ),
        );
      },
    );
  }
}

class _TagShell extends StatelessWidget {
  const _TagShell({
    required this.background,
    required this.child,
    this.borderColor,
  });

  final Color background;
  final Color? borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 1),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  _CloseIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(Offset.zero, Offset(size.width, size.height), paint)
      ..drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant _CloseIconPainter old) => old.color != color;
}
```

- [ ] **Step 4：追加 barrel 导出**

Edit `lib/ant_design_flutter.dart` 追加：

```dart
export 'src/components/tag/ant_tag.dart' show AntTag, AntCheckableTag;
```

- [ ] **Step 5：运行测试 + 提交**

Run: `flutter test test/unit/components/tag/ test/widget/components/tag/`
Expected: 所有 tag 测试 pass。

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

```bash
git add lib/src/components/tag/ant_tag.dart \
        test/widget/components/tag/ \
        lib/ant_design_flutter.dart
git commit -m "feat(tag): add AntTag + AntCheckableTag"
```

---

## Task 11：Gallery 24 故事重建

**目的：** `gallery/lib/main.dart` 从占位壳改成按"Round 1 / Round 2"两个 category 组织 8 组件；每组件在 `gallery/lib/components/<name>_stories.dart` 暴露至少 3 个 `WidgetbookUseCase`。

**Files:**
- Modify: `gallery/lib/main.dart`
- Create: `gallery/lib/components/icon_stories.dart`
- Create: `gallery/lib/components/typography_stories.dart`
- Create: `gallery/lib/components/button_stories.dart`
- Create: `gallery/lib/components/input_stories.dart`
- Create: `gallery/lib/components/checkbox_stories.dart`
- Create: `gallery/lib/components/radio_stories.dart`
- Create: `gallery/lib/components/switch_stories.dart`
- Create: `gallery/lib/components/tag_stories.dart`

- [ ] **Step 1：写 icon stories**

写入 `gallery/lib/components/icon_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

const _demoIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

WidgetbookComponent iconStories() {
  return WidgetbookComponent(
    name: 'AntIcon',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Center(child: AntIcon(_demoIcon)),
      ),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntIcon(_demoIcon, size: AntComponentSize.small),
              SizedBox(width: 16),
              AntIcon(_demoIcon, size: AntComponentSize.middle),
              SizedBox(width: 16),
              AntIcon(_demoIcon, size: AntComponentSize.large),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom color',
        builder: (_) => const Center(
          child: AntIcon(_demoIcon, color: Color(0xFF1677FF)),
        ),
      ),
    ],
  );
}
```

- [ ] **Step 2：写 typography stories**

写入 `gallery/lib/components/typography_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent typographyStories() {
  return WidgetbookComponent(
    name: 'Typography',
    useCases: [
      WidgetbookUseCase(
        name: 'Title (h1 - h5)',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AntTitle('Title h1'),
              AntTitle('Title h2', level: AntTitleLevel.h2),
              AntTitle('Title h3', level: AntTitleLevel.h3),
              AntTitle('Title h4', level: AntTitleLevel.h4),
              AntTitle('Title h5', level: AntTitleLevel.h5),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Text (types)',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AntText('normal'),
              AntText('secondary', type: AntTextType.secondary),
              AntText('tertiary', type: AntTextType.tertiary),
              AntText('disabled', type: AntTextType.disabled),
              AntText('success', type: AntTextType.success),
              AntText('warning', type: AntTextType.warning),
              AntText('danger', type: AntTextType.danger),
              AntText('code()', code: true),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Paragraph',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: AntParagraph(
            'Ant Design Flutter is a UI library that brings Ant Design '
            'v5 to Flutter for web and desktop applications.',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Link',
        builder: (_) => Center(
          child: AntLink('Click me', onPressed: () {}),
        ),
      ),
    ],
  );
}
```

- [ ] **Step 3：写 button stories**

写入 `gallery/lib/components/button_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buttonStories() {
  return WidgetbookComponent(
    name: 'AntButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Types',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AntButton(
                type: AntButtonType.primary,
                onPressed: () {},
                child: const Text('Primary'),
              ),
              AntButton(onPressed: () {}, child: const Text('Default')),
              AntButton(
                type: AntButtonType.dashed,
                onPressed: () {},
                child: const Text('Dashed'),
              ),
              AntButton(
                type: AntButtonType.text,
                onPressed: () {},
                child: const Text('Text'),
              ),
              AntButton(
                type: AntButtonType.link,
                onPressed: () {},
                child: const Text('Link'),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AntButton(
                size: AntComponentSize.small,
                onPressed: () {},
                child: const Text('Small'),
              ),
              AntButton(onPressed: () {}, child: const Text('Middle')),
              AntButton(
                size: AntComponentSize.large,
                onPressed: () {},
                child: const Text('Large'),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'States',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AntButton(
                type: AntButtonType.primary,
                loading: true,
                onPressed: () {},
                child: const Text('Loading'),
              ),
              AntButton(
                type: AntButtonType.primary,
                disabled: true,
                onPressed: () {},
                child: const Text('Disabled'),
              ),
              AntButton(
                danger: true,
                onPressed: () {},
                child: const Text('Danger'),
              ),
              AntButton(
                type: AntButtonType.primary,
                ghost: true,
                onPressed: () {},
                child: const Text('Ghost'),
              ),
              SizedBox(
                width: 200,
                child: AntButton(
                  type: AntButtonType.primary,
                  block: true,
                  onPressed: () {},
                  child: const Text('Block'),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
```

- [ ] **Step 4：写 input stories**

写入 `gallery/lib/components/input_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

const _demoIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

WidgetbookComponent inputStories() {
  return WidgetbookComponent(
    name: 'AntInput',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(width: 260, child: AntInput(placeholder: 'input')),
        ),
      ),
      WidgetbookUseCase(
        name: 'Status',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AntInput(placeholder: 'default'),
                SizedBox(height: 12),
                AntInput(placeholder: 'error', status: AntStatus.error),
                SizedBox(height: 12),
                AntInput(placeholder: 'warning', status: AntStatus.warning),
              ],
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Prefix / suffix / clear',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: AntInput(
              placeholder: 'search',
              prefix: AntIcon(_demoIcon, size: AntComponentSize.small),
              allowClear: true,
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled / read-only',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: Column(
              children: [
                AntInput(disabled: true, placeholder: 'disabled'),
                SizedBox(height: 12),
                AntInput(readOnly: true, value: 'read-only'),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
```

- [ ] **Step 5：写 checkbox / radio / switch / tag stories**

写入 `gallery/lib/components/checkbox_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent checkboxStories() {
  return WidgetbookComponent(
    name: 'AntCheckbox',
    useCases: [
      WidgetbookUseCase(
        name: 'Single',
        builder: (_) => _CheckboxSingle(),
      ),
      WidgetbookUseCase(
        name: 'Group horizontal',
        builder: (_) => _CheckboxGroupDemo(direction: Axis.horizontal),
      ),
      WidgetbookUseCase(
        name: 'Group vertical',
        builder: (_) => _CheckboxGroupDemo(direction: Axis.vertical),
      ),
    ],
  );
}

class _CheckboxSingle extends StatefulWidget {
  @override
  State<_CheckboxSingle> createState() => _CheckboxSingleState();
}

class _CheckboxSingleState extends State<_CheckboxSingle> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
        child: AntCheckbox(
          checked: _checked,
          onChanged: (v) => setState(() => _checked = v),
          label: const Text('accept terms'),
        ),
      );
}

class _CheckboxGroupDemo extends StatefulWidget {
  const _CheckboxGroupDemo({required this.direction});
  final Axis direction;
  @override
  State<_CheckboxGroupDemo> createState() => _CheckboxGroupDemoState();
}

class _CheckboxGroupDemoState extends State<_CheckboxGroupDemo> {
  List<String> _value = ['read'];
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: AntCheckboxGroup<String>(
          direction: widget.direction,
          options: const [
            AntOption(value: 'read', label: 'Reading'),
            AntOption(value: 'write', label: 'Writing'),
            AntOption(value: 'gym', label: 'Gym'),
          ],
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      );
}
```

写入 `gallery/lib/components/radio_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent radioStories() {
  return WidgetbookComponent(
    name: 'AntRadio',
    useCases: [
      WidgetbookUseCase(name: 'Single', builder: (_) => _RadioSingle()),
      WidgetbookUseCase(
        name: 'Group horizontal',
        builder: (_) => _RadioGroupDemo(direction: Axis.horizontal),
      ),
      WidgetbookUseCase(
        name: 'Group vertical',
        builder: (_) => _RadioGroupDemo(direction: Axis.vertical),
      ),
    ],
  );
}

class _RadioSingle extends StatefulWidget {
  @override
  State<_RadioSingle> createState() => _RadioSingleState();
}

class _RadioSingleState extends State<_RadioSingle> {
  String? _value;
  @override
  Widget build(BuildContext context) => Center(
        child: AntRadio<String>(
          value: 'only',
          groupValue: _value,
          onChanged: (v) => setState(() => _value = v),
          label: const Text('only'),
        ),
      );
}

class _RadioGroupDemo extends StatefulWidget {
  const _RadioGroupDemo({required this.direction});
  final Axis direction;
  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  String? _value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: AntRadioGroup<String>(
          direction: widget.direction,
          options: const [
            AntOption(value: 'm', label: 'Male'),
            AntOption(value: 'f', label: 'Female'),
            AntOption(value: 'o', label: 'Other'),
          ],
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      );
}
```

写入 `gallery/lib/components/switch_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent switchStories() {
  return WidgetbookComponent(
    name: 'AntSwitch',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: (_) => _SwitchDemo()),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StaticSwitch(size: AntComponentSize.small),
              SizedBox(width: 16),
              _StaticSwitch(size: AntComponentSize.middle),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Loading',
        builder: (_) => Center(
          child: AntSwitch(
            checked: true,
            loading: true,
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  );
}

class _SwitchDemo extends StatefulWidget {
  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
        child: AntSwitch(
          checked: _checked,
          onChanged: (v) => setState(() => _checked = v),
        ),
      );
}

class _StaticSwitch extends StatelessWidget {
  const _StaticSwitch({required this.size});
  final AntComponentSize size;
  @override
  Widget build(BuildContext context) =>
      AntSwitch(checked: true, size: size, onChanged: (_) {});
}
```

写入 `gallery/lib/components/tag_stories.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent tagStories() {
  return WidgetbookComponent(
    name: 'AntTag',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Center(child: AntTag(child: Text('default'))),
      ),
      WidgetbookUseCase(
        name: 'Custom color',
        builder: (_) => const Center(
          child: Wrap(
            spacing: 8,
            children: [
              AntTag(color: Color(0xFFFFF8B8), child: Text('light')),
              AntTag(color: Color(0xFF1677FF), child: Text('blue')),
              AntTag(color: Color(0xFF000080), child: Text('navy')),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Closable',
        builder: (_) => Center(
          child: AntTag(
            closable: true,
            onClose: () {},
            child: const Text('closable'),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Checkable',
        builder: (_) => _CheckableTagDemo(),
      ),
    ],
  );
}

class _CheckableTagDemo extends StatefulWidget {
  @override
  State<_CheckableTagDemo> createState() => _CheckableTagDemoState();
}

class _CheckableTagDemoState extends State<_CheckableTagDemo> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
        child: AntCheckableTag(
          checked: _checked,
          onChanged: (v) => setState(() => _checked = v),
          child: const Text('topic'),
        ),
      );
}
```

- [ ] **Step 6：重写 gallery/lib/main.dart 拼接所有 stories**

替换 `gallery/lib/main.dart` 全文为：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

import 'components/button_stories.dart';
import 'components/checkbox_stories.dart';
import 'components/icon_stories.dart';
import 'components/input_stories.dart';
import 'components/radio_stories.dart';
import 'components/switch_stories.dart';
import 'components/tag_stories.dart';
import 'components/typography_stories.dart';

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: [
        WidgetbookCategory(
          name: 'Round 1 — Atoms',
          children: [iconStories(), typographyStories()],
        ),
        WidgetbookCategory(
          name: 'Round 2 — Form controls',
          children: [
            buttonStories(),
            inputStories(),
            checkboxStories(),
            radioStories(),
            switchStories(),
            tagStories(),
          ],
        ),
      ],
      appBuilder: (context, child) => AntConfigProvider(
        theme: AntThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      ),
      addons: const [],
    );
  }
}
```

- [ ] **Step 7：pub get + 启动确认 gallery 能编译**

Run: `cd gallery && flutter pub get`
Expected: 依赖解析通过。

Run: `cd gallery && flutter analyze --fatal-infos`
Expected: `No issues found!`

> 不跑 `flutter run` —— 仅静态验证；用户本地手动打开确认故事数量。

- [ ] **Step 8：提交**

```bash
git add gallery/
git commit -m "feat(gallery): add widgetbook stories for all Phase 3 components"
```

---

## Task 12：example/main.dart 重写为注册表单

**目的：** 把"Hello Ant"演示页换成跨 7 组件的注册表单，验证 Phase 3 组件的集成体验。

**Files:**
- Modify: `example/main.dart`（全量替换）

- [ ] **Step 1：全量替换**

写入 `example/main.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return const AntApp(home: _RegisterForm());
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  String _username = '';
  String _password = '';
  List<String> _interests = [];
  String? _gender;
  bool _subscribe = false;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return ColoredBox(
      color: alias.colorBackgroundLayout,
      child: Center(
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AntTitle('Create account', level: AntTitleLevel.h3),
                const SizedBox(height: 16),
                AntInput(
                  placeholder: 'Username',
                  value: _username,
                  onChanged: (v) => setState(() => _username = v),
                ),
                const SizedBox(height: 12),
                AntInput(
                  placeholder: 'Password',
                  value: _password,
                  onChanged: (v) => setState(() => _password = v),
                ),
                const SizedBox(height: 16),
                const AntText('Interests', type: AntTextType.secondary),
                const SizedBox(height: 8),
                AntCheckboxGroup<String>(
                  options: const [
                    AntOption(value: 'read', label: 'Reading'),
                    AntOption(value: 'write', label: 'Writing'),
                    AntOption(value: 'gym', label: 'Gym'),
                  ],
                  value: _interests,
                  onChanged: (v) => setState(() => _interests = v),
                ),
                const SizedBox(height: 16),
                const AntText('Gender', type: AntTextType.secondary),
                const SizedBox(height: 8),
                AntRadioGroup<String>(
                  options: const [
                    AntOption(value: 'm', label: 'Male'),
                    AntOption(value: 'f', label: 'Female'),
                    AntOption(value: 'o', label: 'Other'),
                  ],
                  value: _gender,
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AntSwitch(
                      checked: _subscribe,
                      onChanged: (v) => setState(() => _subscribe = v),
                    ),
                    const SizedBox(width: 8),
                    const AntText('Subscribe to newsletter'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_submitted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AntTag(
                      color: alias.colorSuccess,
                      child: const Text('Submitted'),
                    ),
                  ),
                AntButton(
                  type: AntButtonType.primary,
                  block: true,
                  onPressed: () => setState(() => _submitted = true),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2：静态检查**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 3：提交**

```bash
git add example/main.dart
git commit -m "docs(example): rewrite Hello demo as registration form"
```

---

## Task 13：文档 + 版本号收尾

### Task 13a：README 新增"使用图标字体"章节

**Files:**
- Modify: `README.md`

- [ ] **Step 1：读取当前 README**

Run: `cat README.md | head -80`（了解现有章节锚点，准备插入位置）

- [ ] **Step 2：在 README 的"Quick Start"章节后插入图标字体说明**

在 `README.md` 的"Quick Start"章节末尾、下一节标题之前，新增如下段落：

```markdown
## Using icon fonts

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
```

> 如果 `Quick Start` 章节不存在，就把上述段落放在 `## Installation` 之后。

- [ ] **Step 3：提交**

```bash
git add README.md
git commit -m "docs(readme): explain icon font policy (no bundled font)"
```

### Task 13b：pubspec.yaml 版本升 2.0.0-dev.4

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1：替换 version 行**

Edit `pubspec.yaml`，把：

```yaml
version: 2.0.0-dev.3
```

替换为：

```yaml
version: 2.0.0-dev.4
```

- [ ] **Step 2：验证 pubspec.lock 一致（应当无需重跑 pub get，仅本包 version 变化）**

Run: `flutter pub get`
Expected: 依赖解析通过，lock 可能无变化。

- [ ] **Step 3：提交**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: bump version to 2.0.0-dev.4"
```

### Task 13c：CHANGELOG 新增 2.0.0-dev.4 条目

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1：在文件顶部插入新条目**

Edit `CHANGELOG.md`，在现有 `## 2.0.0-dev.3` 之前插入：

```markdown
## 2.0.0-dev.4

Phase 3 delivery: Round 1 + Round 2 atomic components.

### Added
- `_shared`: `AntComponentSize` / `AntStatus` enums; `resolveControlHeight()` utility; internal `LoadingSpinner` reused by Button/Switch.
- `AntIcon`: thin `IconData` wrapper with 3 size tiers (14 / 16 / 20). No icon font shipped — users supply their own (see README).
- `AntTitle` (h1-h5), `AntText` (7 semantic types + strong/italic/underline/delete/code), `AntParagraph` (1em bottom gap), `AntLink` (hover / focus / disabled states).
- `AntButton`: 5 types (primary / default / dashed / text / link), 3 sizes, 3 shapes, flags `danger` / `ghost` / `block` / `disabled` / `loading`. `ButtonStyle` pure-function derivation with exhaustive unit tests.
- `AntInput`: built on `package:flutter/widgets.dart`'s `EditableText` (no `material.dart` dependency). Supports `prefix` / `suffix` / `allowClear` / `maxLength` / `status` (default/error/warning) / `disabled` / `readOnly`.
- `AntOption<T>` data class (shared by Checkbox/Radio groups).
- `AntCheckbox` + `AntCheckboxGroup<T>` (options-list API).
- `AntRadio<T>` + `AntRadioGroup<T>`.
- `AntSwitch`: 2 visible sizes, `loading` with embedded spinner, 200ms toggle animation.
- `AntTag` (color / bordered / closable) + `AntCheckableTag` (checked / onChanged) — split intentionally to avoid mutually-exclusive properties on one class.
- Gallery: 24+ widgetbook use cases across 8 components.
- Example: rewrote `example/main.dart` into a registration form spanning 7 components.

### Deviations from parent spec
- **No bundled icon font.** Parent spec §0/§6.1/§7.1 called for a shipped AntIcons TrueType subset; deferred indefinitely. `AntIcon` accepts any user-provided `IconData`; README recommends community packages such as `ant_icons_plus`.
- **AntCheckableTag split** from `AntTag` (parent spec §6.1 counted Tag as one component). The two semantics (onClose vs checked) would otherwise need mutually-exclusive flags on a single class.
- **Phase 3 budget widened** from 45h/6 weeks to 53h/7 weeks to cover 3-tier size variants, balanced property pack, gallery 24 stories, and example rewrite.
- **AntButton.icon deferred to 2.1** — users compose icons via `child: Row(children: [AntIcon(...), SizedBox, text])`.

### Constraints
- Components only consume `AntTheme.aliasOf(context)` — never seed / map tokens.
- Components do not import `package:flutter/material.dart`.
- Form integration uses classic controlled API (`value` + `onChanged`). `AntFormField` mixin deferred to Phase 6.

### Reference
- Spec: `docs/superpowers/specs/2026-04-19-phase-3-atoms-design.md`
- Plan: `docs/superpowers/plans/2026-04-19-phase-3-atoms.md`
```

- [ ] **Step 2：提交**

```bash
git add CHANGELOG.md
git commit -m "docs(changelog): add 2.0.0-dev.4 entry for Phase 3 delivery"
```

### Task 13d：PROGRESS.md 标记 Phase 3 完成

**Files:**
- Modify: `doc/PROGRESS.md`

- [ ] **Step 1：更新 "Last updated" 与 Phase 3 状态**

Edit `doc/PROGRESS.md`：
- 把 `**Last updated:** ...` 行替换成 `**Last updated:** 2026-06-07 (Phase 3 delivery)` —— 按实际完成日期调整（执行者自填）。
- Phase 3 行的 `Status` 列改为 `complete`；Plan 列改为 `[plans/2026-04-19-phase-3-atoms.md](../docs/superpowers/plans/2026-04-19-phase-3-atoms.md)`。
- 在 `Current session notes` 列表末尾追加一条：

```markdown
- 2026-06-07: Phase 3 complete. 8 components shipped (Icon / Title / Text / Paragraph / Link / Button / Input / Checkbox+Group / Radio+Group / Switch / Tag+CheckableTag). All consume alias token only. No material.dart. Gallery has 24+ widgetbook use cases; example is now a registration form. Next: write Phase 4 plan (Round 3 feedback widgets: Tooltip / Message / Notification / Modal).
```

> 日期占位符 `2026-06-07` 由执行者按实际日期覆盖。

- [ ] **Step 2：提交**

```bash
git add doc/PROGRESS.md
git commit -m "docs(progress): mark Phase 3 complete"
```

---

## Task 14：全面回归 + 版本 tag

**目的：** Phase 收尾的最后一步：跑全套测试、analyze、覆盖率检查，通过后打 `v2.0.0-dev.4` tag。

- [ ] **Step 1：全量 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 2：全量测试 + 覆盖率**

Run: `flutter test --coverage`
Expected: 所有测试 pass（预估总用例 ~150+）。

生成覆盖率报告并查看 `coverage/lcov.info`：

Run: `grep -c '^SF:' coverage/lcov.info`
Expected: 至少 30+ 个源文件（Phase 1 已有约 10、Phase 2 约 8、Phase 3 新增约 25，共 40+）。

覆盖率阈值（spec § 12.2）：

- Unit ≥ 90%（Style 派生穷举覆盖）
- Widget ≥ 80%
- 总体 ≥ 85%

若低于阈值，先补测再进入下一步；常见缺口是 ButtonStyle 的罕见分支（ghost + danger 组合、dashed 虚线边框 painter 的 path 分支）。

- [ ] **Step 3：gallery 静态检查**

Run: `cd gallery && flutter analyze --fatal-infos && cd ..`
Expected: `No issues found!`

- [ ] **Step 4：example 跑通（冒烟）**

Run: `flutter run -t example/main.dart -d chrome` 或 `-d macos`（任意桌面设备）
Expected: 注册表单渲染正常，所有控件可交互；提交后出现 Submitted tag。

> 这一步是手动验证。执行者确认后在本地 `^C` 退出。

- [ ] **Step 5：确认工作树干净**

Run: `git status`
Expected: `nothing to commit, working tree clean`。

- [ ] **Step 6：打 tag v2.0.0-dev.4**

```bash
git tag -a v2.0.0-dev.4 -m "Phase 3 delivery: Round 1+2 atomic components (8 components)"
git push origin main
git push origin v2.0.0-dev.4
```

> 禁止在 tag message 或推送命令中附带任何 AI 水印文本。

- [ ] **Step 7：本地 pub publish --dry-run 校验发布元数据（不真正发布）**

Run: `flutter pub publish --dry-run`
Expected: 输出列出的已知 warnings 可接受（`pubspec.yaml.description too short` 等业务判断决定是否处理），不要求 zero warning 才通过。

> 真正的 `flutter pub publish` 留给维护者手动执行，本计划不自动化发布。

---

## 参考索引

- 父 spec: [`docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`](../specs/2026-04-18-antdf-2.0-design.md)
- Phase 3 补充 spec: [`docs/superpowers/specs/2026-04-19-phase-3-atoms-design.md`](../specs/2026-04-19-phase-3-atoms-design.md)
- Phase 1 plan（token system）: [`2026-04-18-phase-1-token-system.md`](./2026-04-18-phase-1-token-system.md)
- Phase 2 plan（primitives）: [`2026-04-18-phase-2-primitives.md`](./2026-04-18-phase-2-primitives.md)

**Phase 3 合计：14 个 Task，约 53h 工时，约 40 次独立 commit，最终 tag `v2.0.0-dev.4`。**

