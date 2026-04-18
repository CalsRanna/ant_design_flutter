# Phase 2：Primitives（Interaction / Portal / Overlay）设计文档

- **Spec 日期**：2026-04-18
- **父 Spec**：[2026-04-18-antdf-2.0-design.md](./2026-04-18-antdf-2.0-design.md) 第 4 节
- **覆盖范围**：总设计中的 L2 Primitives（AntInteractionDetector、AntPortal、AntOverlayManager）
- **预计工时**：22h / 3 周（业余 7.5h/周）
- **状态**：Draft，等待用户 review

---

## 0. 决策摘要

| 维度 | 决策 |
| --- | --- |
| Phase 2 边界 | 只做 L2 的三个纯行为/几何原语，**不含视觉默认值**、不含任何具体组件 |
| Primitives 与 Token 的关系 | **Primitives 不读 AntTheme**。视觉完全由 consumer（Phase 3+ 组件）注入 |
| Interaction 关心的状态 | `hovered` / `focused` / `pressed` / `disabled` 四个 `WidgetState` |
| Interaction 键盘激活 | Enter / Space 在 focus 时触发 `onTap`，通过 `Focus` + `Actions/Shortcuts` 声明 |
| Interaction 的 `onHover` 语义 | 状态 `hovered` 进入 / 离开两个时点各回调一次（true / false） |
| Portal 的 Overlay 选择 | `Overlay.of(context)`（最近的 Overlay），不强制 rootOverlay |
| Portal 的 12 方位语义 | 对齐 AntD web `Tooltip` 的 placement（见 § 4.3 语义表） |
| Portal 的翻转策略 | 至多翻转一次；在 overlay 首帧 layout 完成后 `addPostFrameCallback` 里检测越界并翻转；之后方位锁定不再响应 |
| Portal 的 dismiss 触发 | MVP **不内置** tap-outside / ESC / scroll-away；由 consumer 显式控制 `visible` |
| Portal 的生命周期 | `visible: true` 时插入 OverlayEntry，`false` / dispose 时移除 |
| OverlayManager 的 slot 数量 | 4 个：`message` / `notification` / `modal` / `drawer` |
| OverlayManager 的 slot 语义 | message / notification 为 **列表**（多条垂直堆叠）；modal / drawer 为 **单例**（再次 `show` 前先 dismiss 现有） |
| OverlayManager 的挂载模型 | per-(Overlay × slot) 一个 host `OverlayEntry`，host 内部是 `StatefulWidget`，list 语义由 host state 维护 |
| OverlayManager 的动画 | MVP 无入场 / 出场动画；直接插入 / 移除。动画延至 Phase 4 反馈组件 |
| OverlayManager host 清理 | slot 变空时 host 保留不卸载；Overlay dispose 时无需手动清理（OverlayEntry 随 Overlay 一同销毁） |
| 默认外观 / 配色 | **全部由 Phase 3+ 的组件负责**，Phase 2 交付的是透明行为层 |

---

## 1. 架构总览

Phase 2 覆盖 L2 Primitives，依赖 Phase 1 的仅 Flutter widgets 基础（**不消费 AntTheme / token**）：

```
foundation/      已有
theme/           已有
app/             已有
primitives/      Phase 2 新增
   ├─ interaction/          状态合成（hover/focus/press/disabled）
   ├─ portal/               锚点弹层定位
   └─ overlay/              无锚浮层（message/notification/modal/drawer）
```

**硬约束**：

- `primitives/` 不 import `theme/`、`app/`、`components/`
- `primitives/` 对外只依赖 Flutter `widgets.dart` + `foundation.dart`
- 三个原语之间相互独立（Portal 不依赖 Interaction、Overlay 不依赖 Portal）

**与组件的职责切分**：

| 层 | 职责 | 例：Tooltip 是如何实现的 |
| --- | --- | --- |
| L2 Portal | 给定 target 和 placement，把一个任意 widget 定位到锚点周围 | 提供"把这块 widget 贴到 button 上面"的能力 |
| L3 Tooltip | 给 Portal 喂入 target = 被包裹内容，overlay = 带气泡样式 + token 配色的文本框；监听 hover 控制 `visible` | Tooltip 决定"气泡长啥样、hover 时出现" |

Phase 2 交付完成后，**不产出任何可在 gallery 直接展示的视觉**；交付物是一组能被 widget test 覆盖的 API 和一个"纯行为"的临时 demo（example 里点一下会 print）。

---

## 2. 项目结构

```
lib/
└── src/
    └── primitives/
        ├── interaction/
        │   └── ant_interaction_detector.dart   # AntInteractionDetector
        ├── portal/
        │   ├── ant_placement.dart              # enum + anchor 映射
        │   └── ant_portal.dart                 # AntPortal
        └── overlay/
            ├── ant_overlay_slot.dart           # enum AntOverlaySlot
            ├── overlay_entry_handle.dart       # OverlayEntryHandle（公开 opaque 句柄）
            ├── ant_overlay_host.dart           # internal host widget
            └── ant_overlay_manager.dart        # AntOverlayManager 静态门面

test/
├── widget/
│   ├── primitives/
│   │   ├── interaction/
│   │   │   └── ant_interaction_detector_test.dart
│   │   ├── portal/
│   │   │   ├── ant_placement_test.dart          # unit 也放这里（enum 映射表）
│   │   │   ├── ant_portal_basic_test.dart       # 12 方位几何
│   │   │   └── ant_portal_adjust_test.dart      # 翻转
│   │   └── overlay/
│   │       ├── ant_overlay_manager_test.dart    # show/dismiss 基础
│   │       └── ant_overlay_stacking_test.dart   # message / notification 堆叠
```

**barrel 导出新增**（`lib/ant_design_flutter.dart`）：

```
AntInteractionDetector
AntPlacement
AntPortal
AntOverlaySlot
AntOverlayManager
OverlayEntryHandle
```

内部类（`AntOverlayHost`、placement → anchor 映射表工具等）**不导出**。

---

## 3. AntInteractionDetector

### 3.1 公开 API

```dart
typedef AntInteractionBuilder = Widget Function(
  BuildContext context,
  Set<WidgetState> states,
);

class AntInteractionDetector extends StatefulWidget {
  const AntInteractionDetector({
    super.key,
    required this.builder,
    this.onTap,
    this.onHover,
    this.enabled = true,
    this.focusable = true,
    this.cursor,
    this.focusNode,
  });

  final AntInteractionBuilder builder;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHover;
  final bool enabled;
  final bool focusable;
  final MouseCursor? cursor;
  final FocusNode? focusNode;
}
```

### 3.2 状态集合

| `WidgetState` | 何时进入 | 何时离开 |
| --- | --- | --- |
| `hovered` | `MouseRegion.onEnter` | `MouseRegion.onExit` / widget dispose |
| `focused` | `FocusNode.addListener` 检测到 focus gained | focus lost |
| `pressed` | `GestureDetector.onTapDown` / Enter/Space key down while focused | `onTapUp` / `onTapCancel` / key up |
| `disabled` | `enabled == false` 时持续存在 | `enabled == true` 时移除 |

**同时存在**：`disabled` 与其它状态可共存，但 consumer 的 builder 应优先渲染 disabled 样式（由 builder 自行决定优先级）。

### 3.3 交互约束

- `enabled == false` 时：
  - `onTap` / `onHover` 回调**均不触发**
  - `cursor` 强制为 `SystemMouseCursors.forbidden`（若 `cursor` 为 null）或 consumer 传入值（若 consumer 显式指定）
  - 节点退出 focus traversal（通过 `Focus(canRequestFocus: false)`）
- `focusable == false` 且 `enabled == true`：节点可点击、可 hover，但 Tab 跳过
- 键盘激活：focus 状态下按 Enter / Space 触发 `onTap`，通过 `Focus` + `Actions/Shortcuts` 声明（不手写 `RawKeyboardListener`）
- `onHover(bool)` 仅在 `hovered` 真正跳变时调用一次，避免 mouse move 抖动重复回调

### 3.4 实现骨架（引用，非全量）

```dart
class _AntInteractionDetectorState extends State<AntInteractionDetector> {
  late final WidgetStatesController _controller;
  late FocusNode _focusNode;
  // ... 管理 focus / mouseRegion / gestureDetector 的拼装
}
```

核心拼装顺序（从外到内）：`Focus` → `Actions` → `MouseRegion` → `GestureDetector` → `builder(context, states)`。`AnimatedBuilder(animation: _controller)` 驱动 builder 重建。

### 3.5 不做

- **长按 / 双击 / 拖拽**：MVP 不暴露（Phase 3+ 若有组件需要，再以新 prop 加入，注意不要与 WidgetState 语义冲突）
- **`selected` 状态**：由具体组件（Checkbox / Radio / Switch）在 builder 里自行拼入 `states`
- **回调的时间节流**：consumer 侧处理，这里不做 debounce

---

## 4. AntPortal

### 4.1 公开 API

```dart
enum AntPlacement {
  topLeft, top, topRight,
  rightTop, right, rightBottom,
  bottomRight, bottom, bottomLeft,
  leftBottom, left, leftTop,
}

class AntPortal extends StatefulWidget {
  const AntPortal({
    super.key,
    required this.child,
    required this.overlayBuilder,
    this.placement = AntPlacement.top,
    this.visible = false,
    this.offset = Offset.zero,
    this.autoAdjustOverflow = true,
    this.onDismiss,
  });

  final Widget child;                     // target（锚点）
  final WidgetBuilder overlayBuilder;     // 弹层内容（纯视觉，由 consumer 决定）
  final AntPlacement placement;
  final bool visible;
  final Offset offset;                    // 在 placement 计算之后的额外偏移
  final bool autoAdjustOverflow;
  final VoidCallback? onDismiss;          // 预留；MVP 不内部触发，仅提供字段便于未来扩展
}
```

### 4.2 实现策略

- `child` 被包在 `CompositedTransformTarget(link: _link)` 中
- 每次 `visible` 变为 `true`：
  1. 创建 `OverlayEntry`，entry 的 builder 返回 `CompositedTransformFollower(link: _link, targetAnchor, followerAnchor, offset)` 包裹 `overlayBuilder(context)`
  2. `Overlay.of(context).insert(entry)`
  3. `addPostFrameCallback` 检查是否越界；若 `autoAdjustOverflow == true` 且越界 → 翻转一次 placement 后 `entry.markNeedsBuild()`
- `visible: false` 或 widget dispose：`entry.remove()`

**锁定语义**：一次挂载只翻转一次。下一次 `visible: false → true` 重新评估。

### 4.3 12 方位语义表

锚点对齐规则（对齐 AntD web `Tooltip`）：

| placement | targetAnchor | followerAnchor | 视觉语义 |
| --- | --- | --- | --- |
| `top` | `topCenter` | `bottomCenter` | 弹层在上方，横向居中 |
| `topLeft` | `topLeft` | `bottomLeft` | 弹层在上方，左对齐 |
| `topRight` | `topRight` | `bottomRight` | 弹层在上方，右对齐 |
| `bottom` | `bottomCenter` | `topCenter` | 弹层在下方，横向居中 |
| `bottomLeft` | `bottomLeft` | `topLeft` | 弹层在下方，左对齐 |
| `bottomRight` | `bottomRight` | `topRight` | 弹层在下方，右对齐 |
| `left` | `centerLeft` | `centerRight` | 弹层在左侧，纵向居中 |
| `leftTop` | `topLeft` | `topRight` | 弹层在左侧，顶对齐 |
| `leftBottom` | `bottomLeft` | `bottomRight` | 弹层在左侧，底对齐 |
| `right` | `centerRight` | `centerLeft` | 弹层在右侧，纵向居中 |
| `rightTop` | `topRight` | `topLeft` | 弹层在右侧，顶对齐 |
| `rightBottom` | `bottomRight` | `bottomLeft` | 弹层在右侧，底对齐 |

**flip 映射**（一次性翻转到对侧主轴；副轴保持）：

- `top*` ↔ `bottom*`
- `left*` ↔ `right*`
- 主轴越界哪一侧就翻哪一侧；主轴上下均越界（弹层比屏幕还高）保持原 placement 不翻

越界判定：`entry` 的 follower 子树根 `RenderBox.localToGlobal(Offset.zero)` + `size` 与 `MediaQuery.of(context).size` 比较，任一边出界视作越界。

### 4.4 offset 应用

`offset` 作为 `CompositedTransformFollower.offset` 的最终值，翻转后 offset 不取反（由 consumer 预期"箭头朝下就这样偏，朝上就那样偏"，箭头视觉属于 Tooltip 组件层）。

### 4.5 不做

- **tap-outside 关闭**：Phase 4 Tooltip/Dropdown 组件用 `TapRegion` 或 `GestureDetector` 自行包装
- **ESC 关闭**：同上，组件层做
- **scroll-away 时自动消失**：Phase 4
- **箭头 / caret**：Phase 4 组件层画
- **进场动画**：Phase 4 组件层用 `AnimatedSwitcher` / `FadeTransition` 包 overlayBuilder 的返回值
- **多次 flip 振荡避免**：已通过"一次挂载只翻一次"解决；不引入 LayoutBuilder 反复测量

---

## 5. AntOverlayManager

### 5.1 公开 API

```dart
enum AntOverlaySlot { message, notification, modal, drawer }

abstract final class AntOverlayManager {
  static OverlayEntryHandle show({
    required BuildContext context,
    required AntOverlaySlot slot,
    required WidgetBuilder builder,
  });

  static void dismiss(OverlayEntryHandle handle);

  static void dismissAll(AntOverlaySlot slot, BuildContext context);
}

@immutable
class OverlayEntryHandle {
  // opaque：consumer 只用它传给 dismiss()；内部字段全包私有
}
```

### 5.2 挂载模型

**per-(Overlay × slot) 一个 host `OverlayEntry`**。

- `show()` 第一次对某 `(overlay, slot)` 调用 → lazy 创建一个 host entry 插入 overlay；host 的 child 是一个 `StatefulWidget`（`_AntOverlayHost`），state 内维护 `List<_HostedBuilder>`
- 第二次 `show()` 复用同一 host，往其 state 的 list 里加一条
- `dismiss(handle)` 找到 handle 对应的 host → state 里移除条目 → host 空了也**不**卸载 host entry（简化，Overlay dispose 时随之销毁）
- `dismissAll(slot, context)` 找到该 (overlay, slot) host → 清空其 state 的 list

### 5.3 4 个 slot 的布局规则

| slot | 布局 | list 语义 | 空 list 时视觉 |
| --- | --- | --- | --- |
| `message` | `Align(alignment: topCenter)` + `Column(mainAxisSize: min)`，顶部 `SafeArea` 内 24 px 向下，多条用 `SizedBox(height: 8)` 间隔 | 列表，FIFO 堆叠（先 show 的在上） | 什么都不画（空 `SizedBox.shrink`） |
| `notification` | `Align(alignment: topRight)` + `Column(mainAxisSize: min)`，右上 24 px / 顶 24 px 起，多条 8 px 间隔 | 列表，FIFO 堆叠 | 空 |
| `modal` | 全屏 `Stack`：底层 `ColoredBox(color: Color(0x80000000))` barrier + `Center(child: builder(context))` | **单例**。若已有 modal，`show` 新的时先 dismiss 旧的 | 不渲染 barrier |
| `drawer` | 全屏 `Stack`：底层同 modal 的 barrier + `Align(alignment: centerRight, child: builder(context))` | **单例**。规则同 modal | 不渲染 barrier |

**modal / drawer 的 barrier**：MVP **不响应点击关闭**（和 Portal.dismiss 决策一致——关闭策略由 consumer 控制）。barrier 只阻止穿透到下层 UI。

**测量问题**：message / notification 使用 `Column(mainAxisSize: min)`，由 Flutter layout 自然处理条目高度；**不**手动 `GlobalKey + addPostFrameCallback` 测。父 spec 提到的"旧版高度测量 null" 是旧版自己用 Stack + Positioned 手算 top 的后果；Column 方案天然避开。

### 5.4 context → Overlay 查找

`show(context:)` 内部调 `Overlay.of(context, rootOverlay: false)`，拿到最近 Overlay。嵌套场景（Dialog 内触发 message）会挂到 Dialog 的 Overlay 上；这是期望行为（Dialog 关闭时 message 自动消失）。

若 consumer 想挂 root，由上层组件（Phase 4 Message 组件）在 show 前自己用 `Overlay.of(context, rootOverlay: true)` 的 context。

### 5.5 不做

- **动画**：进场 / 出场淡入淡出、drawer 滑入，MVP 全部没有。Phase 4 组件层用 `AnimatedSwitcher` / `SlideTransition` 包装 builder 返回值
- **音效 / 震动**：不在范畴
- **优先级队列**：多条消息不按优先级插入，严格 FIFO
- **全局单例 API**（`AntMessage.show('text')` 这种）：属于 Phase 4 组件层
- **计时自动关闭**：由 Phase 4 Message 组件自己 `Future.delayed` 后调 dismiss

---

## 6. 测试策略

### 6.1 Widget 测试必覆盖

| 目标 | 文件 | 关键断言 |
| --- | --- | --- |
| AntInteractionDetector | ant_interaction_detector_test.dart | 初始 states 为空；`MouseRegion` enter 后 states 含 `hovered`；`onHover(true/false)` 各调一次；Tap 触发 `onTap`；disabled 下 tap / hover 不触发回调；focus 后 Enter 触发 onTap |
| AntPlacement → anchor 映射 | ant_placement_test.dart | 12 条 placement 的 `(targetAnchor, followerAnchor)` 与 § 4.3 表一致（table-driven test） |
| AntPortal 基础定位 | ant_portal_basic_test.dart | `visible: true` 后 overlay 的 `RenderBox` 位置与 target 位置相对关系符合 placement；3 个代表方位（top / bottomRight / left）即可，不必 12 个全覆盖 |
| AntPortal 翻转 | ant_portal_adjust_test.dart | target 靠近屏幕上沿且 placement=top → 挂载后 placement 被翻到 bottom；`autoAdjustOverflow: false` 时不翻 |
| AntOverlayManager 基础 | ant_overlay_manager_test.dart | show 后 builder 被渲染；dismiss 后消失；dismiss 已 dismissed 的 handle 幂等不抛错 |
| AntOverlayManager 堆叠 | ant_overlay_stacking_test.dart | message slot 连续 show 3 条，3 个子 widget 都存在；modal slot show 第二条时第一条被自动 dismiss（单例语义） |

### 6.2 覆盖率门槛

Phase 2 预计 ~500 LOC，延用 Phase 1 门槛：

- Widget ≥ 80%
- Unit ≥ 90%（placement 映射表）
- 总体 ≥ 85%

### 6.3 不做

- **Golden test**：推迟 2.1
- **Web / 桌面平台专属测试**：primitives 不依赖平台特性，默认 `testWidgets` 在 vm 平台跑即可
- **多窗口 / 多 Overlay 交互**：MVP 假设单个 `WidgetsApp`

---

## 7. Phase 2 完成定义（DoD）

- [ ] `lib/src/primitives/interaction/ant_interaction_detector.dart` 实现 + widget test
- [ ] `lib/src/primitives/portal/ant_placement.dart` enum + anchor 映射 + unit test
- [ ] `lib/src/primitives/portal/ant_portal.dart` 实现 + 两份 widget test（基础 / 翻转）
- [ ] `lib/src/primitives/overlay/ant_overlay_slot.dart`
- [ ] `lib/src/primitives/overlay/overlay_entry_handle.dart`
- [ ] `lib/src/primitives/overlay/ant_overlay_host.dart`
- [ ] `lib/src/primitives/overlay/ant_overlay_manager.dart`
- [ ] `lib/ant_design_flutter.dart` 新增导出 § 2 列出的 6 个公开符号
- [ ] `flutter analyze --fatal-infos` 通过
- [ ] `flutter test` 全部通过；覆盖率达 § 6.2
- [ ] 每个公开类 / 字段有 dartdoc
- [ ] `doc/PROGRESS.md` Phase 2 行改为 complete，追加 session note
- [ ] `CHANGELOG.md` 追加 2.0.0-dev.3 条目

**不在 DoD**：

- gallery 里的 Primitives 展示页（可选，不强制）
- example/main.dart 展示 Portal（可选，Phase 3 随 Button/Tooltip 落地更合适）

---

## 8. 时间预算

业余 7.5h/周，共 3 周：

| 子任务 | 预计工时 |
| --- | --- |
| AntInteractionDetector（含键盘激活、4 状态、widget test） | 6h |
| AntPlacement enum + anchor 映射表 + unit test | 2h |
| AntPortal 基础定位（12 方位，不含翻转） | 4h |
| AntPortal autoAdjustOverflow 翻转策略 + widget test | 3h |
| AntOverlayManager slot 框架 + 单例语义（modal / drawer） | 3h |
| AntOverlayManager list 语义（message / notification）+ widget test | 3h |
| dartdoc 收尾 + 覆盖率补测 + CHANGELOG | 1h |
| **合计** | **22h ≈ 3 周** |

---

## 9. 风险与缓解

| 风险 | 级别 | 缓解 |
| --- | --- | --- |
| `CompositedTransformFollower` 在 web 缩放 / 高 DPR 下偏位 | 中 | 基础 widget test 在默认 DPR (1.0) 下覆盖；已知 web 偏差列入 2.1 followup |
| 翻转判定在子树有额外 padding/margin 时计算误差 | 中 | 以 follower 子树的 `RenderBox` 外包围盒为准；consumer 负责 overlayBuilder 返回的 widget 不要有"不可见外边距" |
| OverlayEntryHandle 被跨 context 误用（handle 的 Overlay 已销毁） | 中 | `dismiss` 内部 try/catch + 检查 entry.mounted，已销毁则幂等返回 |
| Interaction 的键盘激活在 `focusable: false` 下仍触发 | 低 | `focusable: false` → `Focus(canRequestFocus: false)` → 根本不会进入 focused，Actions 不绑定 |
| 单例 slot（modal / drawer）被并发 show 导致旧条目 builder 被调但视觉未现 | 低 | `show` 内部同步调用 `_dismiss(previous)`，再 insert 新条目；Flutter build 管线保证不会"半挂载" |

---

## 10. 与父 Spec 的关系

本 spec 落地父 spec 第 4 节"Primitives 基础设施（L2）"。对父 spec 的偏离：

1. **父 spec 4.1 写"五种状态"，本 spec 收敛到 4 种**（`selected` 由组件层自行注入）。理由：MVP 无任何 Primitives 直接消费 `selected`；提前引入徒增抽象负担。
2. **父 spec 4.3 要求 `GlobalKey + addPostFrameCallback` 测量 message 高度**，本 spec 用 `Column(mainAxisSize: min)` 自然堆叠替代。理由：Column 方案天然避开"Stack + Positioned 手算 top"的老坑，无需测量。这是实现简化，不改变对外 API。
3. **新增**：Primitives 不读 AntTheme（父 spec 未提）。用于明确解耦责任。

Phase 3+ 组件层若需要以上任一点扩展能力，按父 spec § 3.4 "消费规约"的原则**在 Primitives 增补 API**（新 prop / 新方法），不允许组件绕过 Primitives 自己重拼 `CompositedTransformFollower`。

---

## 11. 后续

Phase 2 完成后下一步：写 Phase 3 的实施计划。Phase 3 是 Round 1+2 的原子组件（Icon / Typography / Button / Input / Checkbox / Radio / Switch / Tag），父 spec §6 已列清单——Button 是第一个会同时消费 Interaction + Token 的组件，可作 Primitives 可用性的第一次真实检验。
