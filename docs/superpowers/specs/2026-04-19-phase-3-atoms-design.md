# Phase 3：Round 1+2 原子组件设计文档

- **Spec 日期**：2026-04-19
- **父 Spec**：[2026-04-18-antdf-2.0-design.md](./2026-04-18-antdf-2.0-design.md) §6
- **覆盖范围**：L3 Components 层的 Round 1（Icon、Typography）+ Round 2（Button、Input、Checkbox+Group、Radio+Group、Switch、Tag）
- **预计工时**：50-55h / 7 周（业余 7.5h/周；父 spec §10 原排 45h/6 周，因偏离调整）
- **状态**：Draft，等待用户 review

---

## 0. 决策摘要

| 维度 | 决策 |
| --- | --- |
| 组件总数 | 8 个：AntIcon、AntTypography（Title/Text/Paragraph/Link 四子）、AntButton、AntInput、AntCheckbox（+Group）、AntRadio（+Group）、AntSwitch、AntTag |
| AntIcons 字体 | **不打包**字体文件；AntIcon 只是 `IconData` 包装；推荐用户配合社区包 `ant_icons_plus`（**偏离父 spec §0 / §6.1 / §7.1**） |
| size 变体 | small / middle / large 三档全做（middle 默认）；尺寸值由 alias 派生（24/32/40） |
| 文件结构 | 每组件 `components/<name>/ant_<name>.dart`（Widget）+ `components/<name>/<name>_style.dart`（纯函数：alias + properties → 视觉值） |
| Form 集成 | Phase 3 只做受控 API（`value` + `onChanged`）；`AntFormField` mixin 推 Phase 6 |
| Token 消费 | 组件**只**调用 `AntTheme.aliasOf(context)`；禁止读 seed/map（沿用父 spec §3.4） |
| Group 组件 API | CheckboxGroup / RadioGroup 只提供 `options: List<AntOption<T>>` API；不接 children |
| 临界属性包 | 均衡包：Button(loading)、Input(prefix/suffix/allowClear)、Tag(closable+checkable+color)、Switch(loading) |
| 推迟属性 | Button.icon、Input.password、Input.textarea、Checkbox.indeterminate、Tag preset color、AntD 已 deprecated 的属性 |
| 第三方依赖 | 零；TextField 用 Flutter 内置 `EditableText` 路径 |
| widget test 阈值 | 沿用 Phase 2：Widget ≥80% / Unit ≥90% / 总体 ≥85% |
| Gallery DoD | 8 组件 × ≥3 story = 至少 24 个 widgetbook 用例 |
| example 演进 | `example/main.dart` 重写为"注册表单"演示页（输入 + 复选 + 单选 + 开关 + 标签 + 提交按钮） |
| 动画 | Switch 切换、Tag 关闭、Button loading 旋转交付内置基础动画；其余复杂动画推 2.1 |

---

## 1. 架构总览

Phase 3 落地 L3 Components，依赖关系：

```
foundation/   已有
theme/        已有  ← 组件唯一可读层（仅 alias）
primitives/   已有  ← Round 2 组件复用 InteractionDetector
components/   Phase 3 新增
   ├─ _shared/         共性 enum / 工具
   ├─ icon/
   ├─ typography/
   ├─ button/
   ├─ input/
   ├─ checkbox/        含 group
   ├─ radio/           含 group
   ├─ switch/
   └─ tag/
```

**硬约束**：

- `components/**` 不 import `foundation/`、`theme/algorithm/`、`theme/seed_token.dart`、`theme/map_token.dart`
- `components/<a>/` 不 import `components/<b>/`（同层禁互引；共性放 `_shared/`）
- 组件层不直接 `import 'package:flutter/material.dart'`；`material.dart` 仅在确实需要 `EditableText` 配套（如 `TextField` 内部）时局部允许，详见 § 7
- Round 1（Icon、Typography）不依赖 `AntInteractionDetector`；Round 2 全部依赖

**与 Form 引擎（Phase 6）的关系**：Phase 3 控件采用经典 Flutter 受控模式（`value` + `onChanged`）。Phase 6 引入 `AntFormField` mixin 时，对现有控件是**纯加法**（mixin 加在 StatefulWidget 上，不破坏构造体），不构成 breaking change。

---

## 2. 项目结构

Phase 3 结束时新增/改动文件：

```
lib/
├── ant_design_flutter.dart                                    ← 修改（新增导出）
└── src/
    └── components/                                            ← 新目录
        ├── _shared/
        │   ├── component_size.dart                            ← AntComponentSize enum
        │   ├── component_status.dart                          ← AntStatus enum (default/error/warning)
        │   ├── control_height.dart                            ← resolveControlHeight() 工具
        │   └── loading_spinner.dart                           ← LoadingSpinner（library private）
        ├── icon/
        │   └── ant_icon.dart
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
        │   └── _clear_icon.dart                               ← library private
        ├── checkbox/
        │   ├── ant_checkbox.dart
        │   ├── ant_checkbox_group.dart
        │   ├── ant_option.dart                                ← AntOption<T> 数据类（被 Radio Group 复用，故放在 checkbox/ 之外更稳）
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

example/
└── main.dart                                                  ← 重写为表单页

gallery/lib/
├── main.dart                                                  ← 重写为按组件分类的 widgetbook 树
└── components/                                                ← 新目录，每组件一个 use case 文件
    ├── icon_stories.dart
    ├── typography_stories.dart
    ├── button_stories.dart
    ├── input_stories.dart
    ├── checkbox_stories.dart
    ├── radio_stories.dart
    ├── switch_stories.dart
    └── tag_stories.dart

test/
├── unit/
│   └── components/
│       ├── button/
│       │   └── button_style_test.dart
│       ├── input/
│       │   └── input_style_test.dart
│       ├── checkbox/
│       │   └── checkbox_style_test.dart
│       ├── radio/
│       │   └── radio_style_test.dart
│       ├── switch/
│       │   └── switch_style_test.dart
│       └── tag/
│           └── tag_style_test.dart
└── widget/
    └── components/
        ├── icon/
        │   └── ant_icon_test.dart
        ├── typography/
        │   ├── ant_title_test.dart
        │   ├── ant_text_test.dart
        │   ├── ant_paragraph_test.dart
        │   └── ant_link_test.dart
        ├── button/
        │   └── ant_button_test.dart
        ├── input/
        │   └── ant_input_test.dart
        ├── checkbox/
        │   ├── ant_checkbox_test.dart
        │   └── ant_checkbox_group_test.dart
        ├── radio/
        │   ├── ant_radio_test.dart
        │   └── ant_radio_group_test.dart
        ├── switch/
        │   └── ant_switch_test.dart
        └── tag/
            └── ant_tag_test.dart

CHANGELOG.md                                                   ← 新增 2.0.0-dev.4 条目
doc/PROGRESS.md                                                ← Phase 3 → complete
README.md                                                      ← 新增"使用图标字体"章节
```

`AntOption<T>`（值 + label + disabled）放 `checkbox/ant_option.dart` 是为了避免另立 `_shared/` 子文件，但被 `radio_group` 复用。这是一处可接受的同层复用——理由：Option 概念明确属于"被 Group 系列消费的数据"，无独立语义。**例外条款**：`radio_group.dart` 可以 `import '../checkbox/ant_option.dart'`。

---

## 3. 共性约定

### 3.1 enum: AntComponentSize

```dart
// lib/src/components/_shared/component_size.dart
enum AntComponentSize { small, middle, large }
```

各组件**必须**接受 `AntComponentSize size = AntComponentSize.middle`，并按下表映射到 alias 字段：

| size | controlHeight 来源 | fontSize 来源 |
| --- | --- | --- |
| small | 24（hardcode；alias 暂未派生 small/large 高度） | `alias.fontSize - 2` |
| middle | `alias.controlHeight`（=32） | `alias.fontSize` |
| large | 40（hardcode） | `alias.fontSize + 2` |

> Phase 1 的 `AntMapToken.controlHeightSmall / Large` 已存（24 / 40），但**未**透传到 alias。Phase 3 不改 alias schema（避免触动既有 token 测试），改在 `_shared/` 内提供常量映射函数：
>
> ```dart
> // lib/src/components/_shared/control_height.dart
> double resolveControlHeight(AntAliasToken alias, AntComponentSize size) {
>   return switch (size) {
>     AntComponentSize.small => 24,
>     AntComponentSize.middle => alias.controlHeight,
>     AntComponentSize.large => 40,
>   };
> }
> ```
>
> 2.1 引入 alias 的 small/large 字段后，函数内部改读 alias，调用方零改动。

### 3.2 enum: AntStatus

```dart
// lib/src/components/_shared/component_status.dart
enum AntStatus { defaultStatus, error, warning }
```

`defaultStatus` 而非 `default`：`default` 是 Dart 关键字。被 Input / Button (后续 2.1 起)消费。

### 3.3 *Style 类契约

每个 Round 2 组件提供 `<Name>Style`：

- 构造：`const <Name>Style.from({required AntAliasToken alias, required properties...})`
- 字段：UI 实际渲染所需的派生值（`Color background`、`Color foreground`、`BorderSide border`、`EdgeInsets padding`、`TextStyle textStyle`、`double height`、可选 `BoxDecoration` 整包）
- **纯**：无 BuildContext 依赖；可 unit-test
- **不**导出（`show` 列表里只有 widget 类）；style 类是 `library private`

> Round 1 的 Icon / Typography 不需要 *Style 类（它们直接读 alias 一两个字段，不存在多状态派生）。

### 3.4 状态注入

Round 2 widget 内部以以下顺序拼装：

```dart
AntTheme.aliasOf(context)      // 拿 alias
   → <Name>Style.from(...)     // 算派生
   → AntInteractionDetector(   // 4 态合成
        builder: (ctx, states) {
          // 用 states 二次决定 hover/active/disabled 视觉
        },
      )
```

`states` 优先级：`disabled` > `pressed` > `focused` > `hovered`。

### 3.5 视觉对齐参考

每个组件章节列出的颜色派生规则均以 [Ant Design v5 文档](https://ant.design/components/overview/) 默认主题为基准。**MVP 不强制 pixel-perfect**——目标是 alias-token 一致，外观与 AntD 同源；细节差距（圆角 1px、padding 2px）允许。Golden test 推 2.1 时统一对拍。

---

## 4. AntIcon

### 4.1 公开 API

```dart
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
  final Color? color;        // null → 继承父 DefaultTextStyle.color
  final String? semanticLabel;
}
```

### 4.2 实现

直接包 Flutter `Icon`（来自 `package:flutter/widgets.dart`）：

```dart
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
    color: color,                       // null 时 Flutter Icon 自身回落 IconTheme.color
    semanticLabel: semanticLabel,
  );
}
```

### 4.3 不打包字体的契约

- pubspec.yaml `flutter.fonts` 区段保持不写 `AntIcons`
- `IconData` 的 `fontPackage` 字段由用户传入的 IconData 自带；本库**不**约束
- README 新增"使用图标字体"小节，明文写：本库不内置字体，推荐 `ant_icons_plus` 或用户自制 IconData
- AntIcon 公开 API 不出现 `package` 参数

### 4.4 实现 / 推迟属性

| 属性 | 状态 | 备注 |
| --- | --- | --- |
| icon (IconData) | ✅ MVP | 必填 |
| size (AntComponentSize) | ✅ MVP | 三档 |
| color | ✅ MVP | null 透传 IconTheme |
| semanticLabel | ✅ MVP | 可访问性 |
| spin (旋转动画) | 推迟 2.1 | Loading 场景由 AntButton.loading 内部实现 |
| rotate (静态旋转角度) | 推迟 2.1 | |
| 双色 / TwoTone | 不做 | AntD web 是 SVG 双色叠加，TrueType 字体方案不支持 |

### 4.5 widget test 关键断言

- 默认 size=middle 渲染 16px Icon
- size=small/large 分别渲染 14px / 20px
- 显式 color 生效；null color 回落到 IconTheme

---

## 5. AntTypography

AntTypography 是一个**命名空间**（barrel），不是单一 widget。下属 4 个独立 widget：

### 5.1 AntTitle

```dart
enum AntTitleLevel { h1, h2, h3, h4, h5 }   // AntD web 也只 h1-h5

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
}
```

字号 / 行高映射（对齐 AntD v5）：

| level | fontSize | lineHeight | fontWeight |
| --- | --- | --- | --- |
| h1 | 38 | 1.23 | w600 |
| h2 | 30 | 1.33 | w600 |
| h3 | 24 | 1.33 | w600 |
| h4 | 20 | 1.4 | w600 |
| h5 | 16 | 1.5 | w600 |

颜色：`alias.colorText`。

### 5.2 AntText

```dart
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
    this.code = false,        // 等宽 + 浅灰背景
  });

  final String text;
  final AntTextType type;          // normal / secondary / tertiary / disabled / success / warning / danger
  final AntComponentSize size;
  final bool strong;
  final bool italic;
  final bool underline;
  final bool delete;
  final bool code;
}

enum AntTextType { normal, secondary, tertiary, disabled, success, warning, danger }
```

颜色：`type` → `alias.colorText* / colorSuccess / colorWarning / colorError`。`code: true` 时 `fontFamily: 'monospace'` + `colorFillSecondary` 背景 + 2px 圆角 padding。

### 5.3 AntParagraph

```dart
class AntParagraph extends StatelessWidget {
  const AntParagraph(this.text, {super.key, this.type = AntTextType.normal});

  final String text;
  final AntTextType type;
}
```

视觉等同 AntText 但**默认底部 marign 1em（用 `Padding`）**。MVP 不做 ellipsis / copyable / editable（推迟 2.1）。

### 5.4 AntLink

```dart
class AntLink extends StatelessWidget {
  const AntLink(
    this.text, {
    super.key,
    required this.onPressed,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
}
```

唯一一个用 `AntInteractionDetector` 的 Typography 子类——hover 时 `colorPrimaryHover`、normal 时 `colorPrimary`、disabled 时 `colorTextDisabled`。默认无下划线；`focused` 状态下加下划线（键盘导航可见性）。

### 5.5 推迟属性

- AntTitle.copyable / editable / ellipsis / mark / keyboard
- AntText.ellipsis / copyable / editable
- AntParagraph.ellipsis（多行截断，需 `LayoutBuilder` + `TextPainter`，~3h，推 2.1）

### 5.6 widget test 关键断言

- 4 子类各 1 个测试：默认渲染 + 一个变体（如 `AntText(strong: true)` 触发 fontWeight w600）
- AntLink: hover 后颜色变化、disabled 下 onPressed 不触发

---

## 6. AntButton

### 6.1 公开 API

```dart
enum AntButtonType { primary, defaultStyle, dashed, text, link }
//                   ^^^^^^   ^^^^^^^^^^^^   ^^^^^^   ^^^^   ^^^^
// 与 AntD `default` 关键字冲突 → defaultStyle

enum AntButtonShape { rectangle, round, circle }
// MVP 全做：rectangle 默认；round → 大圆角；circle → 等宽等高 + 50% 圆角

class AntButton extends StatelessWidget {
  const AntButton({
    super.key,
    required this.child,
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

  final Widget child;            // 通常是 Text 或 Row(Icon + Text)
  final VoidCallback? onPressed; // null 同 disabled: true
  final AntButtonType type;
  final AntComponentSize size;
  final AntButtonShape shape;
  final bool danger;
  final bool ghost;
  final bool block;              // 占满宽度
  final bool disabled;
  final bool loading;            // true 时禁点击 + 显示旋转 icon
}
```

### 6.2 视觉派生（ButtonStyle）

主轴：`type × danger × ghost × disabled × pressed × hovered` → 决定 `background` / `foreground` / `borderColor`。

派生表（`d=defaultStyle`，`p=primary`）：

| type | normal background | normal foreground | hover background | hover foreground | active background | active foreground | border |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `primary` | `colorPrimary` | white | `colorPrimaryHover` | white | `colorPrimaryActive` | white | none |
| `defaultStyle` | `colorBackgroundContainer` | `colorText` | 同 normal | `colorPrimaryHover` | 同 normal | `colorPrimaryActive` | `colorPrimaryHover` on hover, `colorBorder` normal |
| `dashed` | 同 `defaultStyle` | 同 `defaultStyle` | 同 `defaultStyle` | 同 `defaultStyle` | 同 `defaultStyle` | 同 `defaultStyle` | 同 `defaultStyle` 但 dashed 样式（Flutter `BorderSide` 不支持 dashed，由 `CustomPaint` 在外层自绘） |
| `text` | transparent | `colorText` | `colorFillSecondary` | `colorText` | `colorFill` | `colorText` | none |
| `link` | transparent | `colorPrimary` | transparent | `colorPrimaryHover` | transparent | `colorPrimaryActive` | none |

`danger=true` 时把上表中所有 `colorPrimary*` 替换为 `colorError`/`colorErrorHover`/`colorErrorActive`（**alias 当前没有 errorHover/Active；MVP 用 alias.colorError 单一色，2.1 补全派生**）。

`ghost=true` 时（仅对 type=primary/default 有效）：background 变 transparent，foreground 反色（取 normal 的 background 颜色作为 foreground）。

`disabled=true`：background = `colorFillSecondary`、foreground = `colorTextDisabled`、border = `colorBorder`、cursor = forbidden。

`loading=true`：等同 disabled 视觉 + 在 child 左侧渲染一个旋转的 `_LoadingSpinner`（自绘 CustomPaint，见 § 6.3）。

### 6.3 LoadingSpinner（共享，library private）

```dart
// lib/src/components/_shared/loading_spinner.dart
class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({required this.color, required this.size, super.key});
  final Color color;
  final double size;       // 由 caller 决定 (Button: fontSize；Switch: thumb 直径)
}
// State 内用 AnimationController(duration: 1s, repeat) 驱动 CustomPainter 画 270° 弧。
```

**不导出**——library private（不在 § 15 export 列表内），共 `AntButton` / `AntSwitch` 复用。**不**新增 `AntSpinner` 公开组件——避免 1.x AntSpin 的 over-engineered 问题。需要时 Phase 4 再独立。

### 6.4 尺寸

`resolveControlHeight(alias, size)` → height；padding 表：

| size | horizontal padding | fontSize |
| --- | --- | --- |
| small | 7 | 14 |
| middle | 15 | 14 |
| large | 15 | 16 |

`block=true` 时 `width: double.infinity`；circle shape 时 width = height。

### 6.5 实现 / 推迟属性

| 属性 | 状态 |
| --- | --- |
| type / size / shape / disabled / loading / danger / ghost / block / onPressed / child | ✅ MVP |
| icon / iconPosition | 推迟 2.1（用户用 `Row(children: [AntIcon, SizedBox, child])` 手拼） |
| href / target | 不做（这是 web-only API，Flutter 用 `url_launcher` 解决，超出库范围） |
| autoInsertSpaceInButton | 不做（中文双字符自动空格，AntD 已 deprecated 倾向） |
| classNames / styles | 不做（CSS-in-JS 概念，Flutter 不需要） |

### 6.6 widget test 关键断言

- 默认渲染：type=default、size=middle、可点击
- type 五种：每种验证 background 颜色匹配派生表
- danger=true 改色
- disabled / loading 不触发 onPressed
- block=true 宽度撑满父级
- pressed 状态下 background 切到 active

---

## 7. AntInput

### 7.1 公开 API

```dart
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
}
```

### 7.2 实现策略

- 内部建一个 `_internalController` 当 `controller == null`；遵循 Flutter "若用户提供 controller 则用、否则建内部" 的标准模式
- 视觉外壳：`Container(decoration: BoxDecoration(border: ..., borderRadius: ..., color: ...))` 包 `Row` 包 `[prefix, EditableText, suffix?, clear?]`
- 内部使用 `EditableText`（来自 `package:flutter/widgets.dart`，**非 material**）
- 选区工具栏：MVP 不提供自定义 toolbar——`EditableText.selectionControls` 留 null（行为：长按弹原生平台菜单；桌面 Ctrl+C/V/X 仍可用）。2.1 评估补 widgets-only toolbar
- 光标：`EditableText.cursorColor` = `alias.colorPrimary`
- focus 用 `FocusNode`；hover 用 `MouseRegion` 直接监听（不复用 InteractionDetector——Input 的 hover/focus 视觉与点击行为耦合较深，套 InteractionDetector 反而绕）
- maxLength 通过 `LengthLimitingTextInputFormatter`
### 7.3 视觉派生（InputStyle）

| 状态 | border | background |
| --- | --- | --- |
| normal | `colorBorder` | `colorBackgroundContainer` |
| hover | `colorPrimaryHover` | 同上 |
| focus | `colorPrimary` + 2px outer ring（`colorPrimaryBackground` 透明度 0.2） | 同上 |
| disabled | `colorBorder` | `colorFillSecondary` |
| status=error | `colorError` (其余照常) | 同上 |
| status=warning | `colorWarning` | 同上 |

allowClear: hover 时在 suffix 位置之前插入一个 8×8 的 × 号图标（**自绘 CustomPainter**，不依赖 material 的 `Icons.cancel`），点击触发 `onChanged('')` 和 controller 清空。Phase 3 在 `lib/src/components/input/_clear_icon.dart` 内置（library private，不导出）。

### 7.4 实现 / 推迟属性

| 属性 | 状态 |
| --- | --- |
| value/onChanged/onSubmitted/placeholder/size/status/disabled/readOnly/allowClear/maxLength/prefix/suffix/controller/focusNode | ✅ MVP |
| password (visibilityToggle) | 推迟 2.1 |
| textarea / autoSize | 推迟 2.1（拆 widget） |
| addonBefore / addonAfter | 推迟 2.1（与 prefix 边界不清，需要单独设计） |
| count（字符计数器） | 推迟 2.1 |
| variant (filled / borderless) | 推迟 2.1 |

### 7.5 widget test 关键断言

- 默认渲染 + 输入字符触发 onChanged
- disabled 下不响应输入
- focus 后 border 切到 primary
- status=error 时 border = colorError
- allowClear=true + hover + 有内容 → clear icon 出现；点击后 value=''
- maxLength=5 时只能输入 5 个字符

---

## 8. AntCheckbox + AntCheckboxGroup

### 8.1 AntCheckbox

```dart
class AntCheckbox extends StatelessWidget {
  const AntCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
    this.label,
    this.disabled = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final Widget? label;          // 通常是 Text；null 时只渲染方块
  final bool disabled;
}
```

视觉：14×14 方框，圆角 4。状态：

| 状态 | 方框边框 | 方框填充 | √ 颜色 | 标签颜色 |
| --- | --- | --- | --- | --- |
| unchecked | `colorBorder` | white | — | `colorText` |
| unchecked + hover | `colorPrimary` | white | — | `colorText` |
| checked | `colorPrimary` | `colorPrimary` | white | `colorText` |
| checked + hover | `colorPrimaryHover` | `colorPrimaryHover` | white | `colorText` |
| disabled | `colorBorder` | `colorFillSecondary` | `colorTextDisabled` | `colorTextDisabled` |

√ 由 CustomPainter 自绘（两段 path）。

### 8.2 AntOption<T>

```dart
// lib/src/components/checkbox/ant_option.dart
@immutable
class AntOption<T> {
  const AntOption({required this.value, required this.label, this.disabled = false});
  final T value;
  final String label;
  final bool disabled;
}
```

### 8.3 AntCheckboxGroup

```dart
class AntCheckboxGroup<T> extends StatelessWidget {
  const AntCheckboxGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final bool disabled;
  final Axis direction;
}
```

实现：根据 `direction` 用 `Wrap`（horizontal）或 `Column`（vertical）；每个 option 渲染一个 `AntCheckbox`，其 `onChanged` 内部对 `value` 做 add/remove 后回调 `onChanged(newList)`。

### 8.4 推迟属性

| 属性 | 状态 |
| --- | --- |
| indeterminate | 推迟 2.1 |
| autoFocus | 推迟 2.1 |

### 8.5 widget test 关键断言

- 单 Checkbox：checked toggle、disabled 不响应、label 渲染
- Group：勾选 option 触发 onChanged 携带新列表；初始 value 决定哪些已勾选；disabled 整组不响应

---

## 9. AntRadio + AntRadioGroup

### 9.1 AntRadio

```dart
class AntRadio<T> extends StatelessWidget {
  const AntRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.disabled = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Widget? label;
  final bool disabled;
}
```

视觉：16×16 圆，外圈边框、内圈点（仅 selected 时画）。颜色派生与 Checkbox 相同。

### 9.2 AntRadioGroup<T>

```dart
class AntRadioGroup<T> extends StatelessWidget {
  const AntRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool disabled;
  final Axis direction;
}
```

`AntRadio` **不**对外要求与 Group 配合使用（与 Group 解耦：`AntRadio.groupValue` 可由用户独立维护）；Group 只是 sugar。

### 9.3 推迟属性

| 属性 | 状态 |
| --- | --- |
| Radio.Button (按钮组样式) | 推迟 2.1 |
| optionType="button" | 推迟 2.1（同上） |
| buttonStyle="solid" | 推迟 2.1 |

### 9.4 widget test 关键断言

- 单 Radio：被点击时 onChanged 携带 value；groupValue==value 时画内圆点
- Group：切换选中项触发 onChanged；disabled 整组不响应

---

## 10. AntSwitch

### 10.1 公开 API

```dart
class AntSwitch extends StatefulWidget {
  const AntSwitch({
    super.key,
    required this.checked,
    required this.onChanged,
    this.size = AntComponentSize.middle,
    this.disabled = false,
    this.loading = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final AntComponentSize size;
  final bool disabled;
  final bool loading;
}
```

`size=middle` 时尺寸 28×16；small 22×14；large 不存在 in AntD → 我们也不支持 large（构造体接受但与 middle 等价；spec 注释说明）。

> **偏离 § 0 决策摘要的"size 三档全做"**：Switch 的 large 与 middle 视觉相同（AntD web 没有 size="large"），但接口仍接受三档以保持组件签名统一。这是 spec 内部一致性微调，已在此节明示。

### 10.2 视觉

- 圆角胶囊：unchecked background = `colorTextTertiary`、checked background = `colorPrimary`；hover 时变深一档
- 滑块（thumb）：白色圆，14×14（middle）/ 12×12 (small)；切换时 200ms 平滑动画（`AnimatedAlign`）
- loading=true：thumb 内画 LoadingSpinner（复用 § 6.3 的共享内置 spinner）；整体暗一档；不响应点击

### 10.3 推迟属性

| 属性 | 状态 |
| --- | --- |
| checkedChildren / unCheckedChildren | 推迟 2.1 |
| autoFocus | 推迟 2.1 |

### 10.4 widget test 关键断言

- 默认渲染 + tap 触发 onChanged(!checked)
- disabled / loading 下 tap 无效
- size=small 渲染 22×14
- 切换后 thumb 位置变化（`tester.pumpAndSettle()` 后查 `Align.alignment`）

---

## 11. AntTag

### 11.1 公开 API

```dart
class AntTag extends StatelessWidget {
  const AntTag({
    super.key,
    required this.child,
    this.color,
    this.bordered = true,
    this.closable = false,
    this.onClose,
  });

  final Widget child;
  final Color? color;             // null → 中性灰 + colorText；非 null → 自定义底色，文本自动取对比色
  final bool bordered;
  final bool closable;
  final VoidCallback? onClose;
}
```

Checkable Tag 拆为独立 widget（避免一个类两种语义）：

```dart
class AntCheckableTag extends StatelessWidget {
  const AntCheckableTag({
    super.key,
    required this.child,
    required this.checked,
    required this.onChanged,
  });

  final Widget child;
  final bool checked;
  final ValueChanged<bool>? onChanged;
}
```

`AntCheckableTag.checked` 决定背景：true → `colorPrimary` + white 文字；false → `colorFillSecondary` + `colorText`。点击切换。

### 11.2 视觉

- 默认：background = `colorFillSecondary`、border = `colorBorder`、padding = `EdgeInsets.symmetric(horizontal: 8, vertical: 0)`、height = 22、fontSize = 12、borderRadius = 4
- `color` 非 null 时：background = color、border = color.withOpacity(0.4)、textColor = `_pickContrast(color)` （亮色背景用 `colorText`，暗色用 white；阈值为 luminance > 0.5）
- closable=true：右侧渲染一个 8px × 号 (CustomPainter)，点击触发 `onClose?.call()`；不内置移除动画（推 Phase 4 用 `AnimatedSize` + AnimatedSwitcher 包装）

### 11.3 推迟属性

| 属性 | 状态 |
| --- | --- |
| color: 13 个 preset 名（magenta/red/volcano/...） | 推迟 2.1（需 foundation 增 preset palette） |
| icon (左侧图标属性) | 推迟 2.1（用户传 child=Row 自拼） |
| closeIcon (自定义关闭图标) | 推迟 2.1 |

### 11.4 widget test 关键断言

- 默认 Tag 渲染 + 自定义 color 改 background
- closable=true 显示 × ；点击触发 onClose
- AntCheckableTag：tap toggle、不同 checked 视觉差异

---

## 12. 测试策略

### 12.1 测试金字塔

```
        Widget tests          每组件 ≥1 个 widget test 文件，覆盖默认渲染 + 主要交互 + disabled
        ↑
        Unit tests（Style）   每个 *Style 类的所有派生分支 (type × danger × ghost × disabled)
```

### 12.2 覆盖率门槛

延用 Phase 2：

- Unit ≥ 90%（*Style 派生函数全覆盖）
- Widget ≥ 80%
- 总体 ≥ 85%

### 12.3 Style 单测的写法范式

每个 *Style 测试形如：

```dart
group('ButtonStyle.from', () {
  final alias = AntThemeData().alias;

  test('primary normal', () {
    final s = ButtonStyle.from(
      alias: alias,
      type: AntButtonType.primary,
      states: const {},
      danger: false,
      ghost: false,
    );
    expect(s.background, alias.colorPrimary);
    expect(s.foreground, isWhite);   // 自定义 matcher
  });

  // 覆盖每条派生表行
});
```

### 12.4 widget test 限制

- 只在默认设备像素比 (1.0) / 默认 size 下断言
- Input 的输入法集成不在 widget test 覆盖（Dart VM 平台不支持原生输入法）；放 manual 检查列表

### 12.5 不做

- Golden test（推 2.1）
- Web/桌面平台专属测试
- Integration test（推 Phase 7）

---

## 13. Gallery 部署

### 13.1 widgetbook 树结构

```
Components/
  Round 1/
    Icon/        Default | Sizes | Custom Color
    Typography/  Title (5 levels) | Text (types) | Paragraph | Link
  Round 2/
    Button/      Types | Sizes | States (loading/disabled/danger/ghost/block)
    Input/       Default | Status | Prefix/Suffix/Clear | Disabled/ReadOnly
    Checkbox/    Single | Group horizontal | Group vertical
    Radio/       Single | Group horizontal | Group vertical
    Switch/      Default | Sizes | Loading
    Tag/         Default | Custom Color | Closable | Checkable
```

每"|"后是一个 use case；最少 3 个/组件，覆盖 default + 主要变体 + 边界态。Typography 4 子类合记为一个组件的 4 用例。

### 13.2 Gallery main.dart 重写

`gallery/lib/main.dart` 的 `GalleryApp` 用 `WidgetbookCategory` × `WidgetbookComponent` × `WidgetbookUseCase` 嵌套；每组件的 use cases 抽到 `gallery/lib/components/<name>_stories.dart`，main.dart 只做拼接。

### 13.3 example 重写

`example/main.dart` 改为一个"演示注册表单"：

```
[ AntInput placeholder=用户名 ]
[ AntInput placeholder=密码（普通 text，因为不做 password 子组件） ]
[ AntCheckboxGroup 兴趣：[阅读, 写作, 健身] ]
[ AntRadioGroup 性别：[男, 女, 其他] ]
[ AntSwitch 接收邮件订阅 ]
[ AntTag (默认 + closable) 演示 ]
[ AntButton primary block "提交" ]
```

提交按钮 onPressed → SnackBar 风格的 print（暂不引入 AntMessage——那是 Phase 4）。这页能跨 7 个组件做集成自检。

---

## 14. Phase 3 完成定义（DoD）

- [ ] `lib/src/components/_shared/` 四文件：`component_size.dart`、`component_status.dart`、`control_height.dart`、`loading_spinner.dart`
- [ ] 8 组件源码（含 group / typography 子类）+ 各自 *Style 类
- [ ] 所有公开类 / 字段有 dartdoc
- [ ] `lib/ant_design_flutter.dart` 新增导出（详见 § 15）
- [ ] `flutter analyze --fatal-infos` 通过
- [ ] `flutter test` 全过；覆盖率达 § 12.2
- [ ] `gallery/` 至少 24 个 widgetbook use case
- [ ] `example/main.dart` 的注册表单可跑通
- [ ] `README.md` 新增"使用图标字体"章节，明示不打包字体 + 推荐 `ant_icons_plus`
- [ ] `doc/PROGRESS.md` Phase 3 行 → complete + session note
- [ ] `CHANGELOG.md` 新增 2.0.0-dev.4 条目（含偏离父 spec 的字体决策）

**不在 DoD**：

- `MIGRATION.md` 写组件命名映射（推迟到 i18n+docs Phase 7）
- AntButton / AntInput / AntTag 的入场动画（除已定义的 Switch / Button loading 之外）
- pub.dev 发布脚本（保持手动）

---

## 15. 公开 API 导出清单

`lib/ant_design_flutter.dart` 新增以下 `export ... show ...` 行：

```dart
// _shared
export 'src/components/_shared/component_size.dart' show AntComponentSize;
export 'src/components/_shared/component_status.dart' show AntStatus;

// icon
export 'src/components/icon/ant_icon.dart' show AntIcon;

// typography
export 'src/components/typography/ant_title.dart' show AntTitle, AntTitleLevel;
export 'src/components/typography/ant_text.dart' show AntText, AntTextType;
export 'src/components/typography/ant_paragraph.dart' show AntParagraph;
export 'src/components/typography/ant_link.dart' show AntLink;

// button
export 'src/components/button/ant_button.dart'
    show AntButton, AntButtonType, AntButtonShape;

// input
export 'src/components/input/ant_input.dart' show AntInput;

// checkbox
export 'src/components/checkbox/ant_option.dart' show AntOption;
export 'src/components/checkbox/ant_checkbox.dart' show AntCheckbox;
export 'src/components/checkbox/ant_checkbox_group.dart' show AntCheckboxGroup;

// radio
export 'src/components/radio/ant_radio.dart' show AntRadio;
export 'src/components/radio/ant_radio_group.dart' show AntRadioGroup;

// switch
export 'src/components/switch/ant_switch.dart' show AntSwitch;

// tag
export 'src/components/tag/ant_tag.dart' show AntTag, AntCheckableTag;
```

**不导出**：所有 `*_style.dart` 内的 `*Style` 类（library private）、`_clear_icon.dart`、`_LoadingSpinner`。

---

## 16. 时间预算

业余 7.5h/周，共 7 周：

| 子任务 | 预计工时 |
| --- | --- |
| _shared/ enums + control_height + LoadingSpinner（含 unit test） | 2.5h |
| AntIcon + widget test | 1.5h |
| AntTypography（4 子类 + style helper + tests） | 5h |
| AntButton + ButtonStyle + LoadingSpinner + widget tests | 8h |
| AntInput + InputStyle + clear icon + widget tests | 9h |
| AntCheckbox + AntCheckboxGroup + AntOption + style + tests | 5h |
| AntRadio + AntRadioGroup + style + tests | 4h |
| AntSwitch + style + tests | 4h |
| AntTag + AntCheckableTag + style + tests | 4h |
| Gallery 24 use cases + main.dart 重写 | 6h |
| example/main.dart 重写注册表单 | 2h |
| dartdoc 收尾、覆盖率补测、README 字体章节、CHANGELOG | 2.5h |
| **合计** | **53h ≈ 7 周** |

> 父 spec §10 给 Phase 3 的 45h 预算未包含字体（决策偏离后省 5-10h）、未充分计 size 三档与 gallery 工作量。本节调整后可执行性更强。

---

## 17. 风险与缓解

| 风险 | 级别 | 缓解 |
| --- | --- | --- |
| AntInput 的 `EditableText` 在桌面 / web 选区行为差异 | 中 | MVP 默认行为即可；caret 闪烁与输入法在 widget test 不验证；列入 manual checklist |
| Tag 自定义 color 的对比色挑选（`_pickContrast`）在中等亮度色（蓝/紫）容易选错 | 中 | 用 sRGB luminance 公式 + 0.5 阈值；2.1 引入 preset palette 时一并按 AntD 规则做正确派生 |
| AntButton 的 ButtonStyle 视觉派生表（5 type × danger × ghost）爆炸 | 中 | unit test 覆盖**全部**派生分支；style 类设计成纯函数便于穷举测试 |
| Switch 切换动画与 loading 状态切换同时发生时 thumb 位置错乱 | 低 | loading=true 时 thumb 不参与 AnimatedAlign，固定居中位置 |
| Round 2 大量复用 InteractionDetector 后，Phase 2 的 API 暴露不足（如缺 cursor 默认行为） | 低 | 真出现时回 Phase 2 增补属性（依父 spec §10 偏离原则） |
| 不打包字体后用户首次试用看到所有 AntIcon 都不显示 | 低 | README 章节用大字标明；example 不依赖任何 IconData（避免破窗） |
| `EditableText` 在不引入 material 时的工具栏（cut/copy/paste）默认空白 | 低 | MVP 接受默认行为（长按弹出原生菜单，桌面快捷键可用）；2.1 评估是否补 widget-only 工具栏 |

---

## 18. 与父 Spec 的偏离

1. **AntIcons 字体不打包**（父 spec §0、§6.1、§7.1 要求"自带 AntD 官方图标字体子集（约 80 个）"）。理由：业余预算下，子集制作 + LICENSE 维护 + 后续字体升级负担过大；社区已有 `ant_icons_plus`；本库专注组件，图标资源解耦。父 spec §11 的"AntIcons 字体覆盖不全"风险条目随之删除（移到本 spec §17 的字体相关条目）。
2. **Phase 3 工时调整为 53h / 7 周**（父 spec §10 排 45h / 6 周）。理由：size 三档 + 均衡属性包 + Gallery 24 use cases + example 重写超出原估算。这是预算微调，不影响后续 Phase 起始时间——父 spec §10.1 明确允许"砍属性 / 缩范围保持节奏"，反向也允许"延 1 周保实现质量"。
3. **AntCheckableTag 拆为独立 widget**（父 spec §6.1 把 Tag 算作单组件）。理由：可关闭 Tag 与可选中 Tag 的语义差异大（一个有 onClose、另一个有 checked），合并签名会出现互斥属性。拆分后两个类各自职责明确。
4. **AntButton.icon 推迟 2.1**（父 spec §6.3 说"icon 推迟 2.1"已含此意）。本 spec 明示。

---

## 19. 后续

Phase 3 完成后下一步：写 Phase 4 实施计划。Phase 4 是 Round 3 反馈类（Tooltip / Message / Notification / Modal），将首次大规模消费 AntPortal + AntOverlayManager + AntButton（Modal 的 footer 按钮）。父 spec §6.1 已列清单。
