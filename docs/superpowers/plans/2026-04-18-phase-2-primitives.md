# Phase 2 Primitives（Interaction / Portal / Overlay）实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 落地 L2 Primitives 三个原语（`AntInteractionDetector` / `AntPortal` / `AntOverlayManager`），为 Phase 3+ 组件提供统一的状态合成、锚点弹层和无锚浮层能力。

**Architecture:** 三原语彼此独立，统一不读 `AntTheme`/token（视觉由 consumer 决定）；`primitives/` 目录只依赖 Flutter `widgets.dart` + `foundation.dart`。Interaction 用 `WidgetStatesController` + `Focus`/`Actions`/`MouseRegion`/`GestureDetector` 拼装；Portal 用 `CompositedTransformTarget/Follower` + 单次翻转；Overlay 采用 per-(Overlay × slot) 一个 host `OverlayEntry` 的模型。

**Tech Stack:** Flutter 3.38+ / Dart 3.10+、`flutter/widgets.dart`（含 `WidgetState`/`WidgetStatesController`、`Overlay`、`CompositedTransform*`、`Focus`/`Actions`/`Shortcuts`）、`flutter_test`。

**上游 Spec：**
- 父 spec：[`docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`](../specs/2026-04-18-antdf-2.0-design.md) §4
- Phase 2 补充 spec：[`docs/superpowers/specs/2026-04-18-phase-2-primitives-design.md`](../specs/2026-04-18-phase-2-primitives-design.md)

**时间预算：** 3 周 / 约 22 小时（业余 5-10 小时/周）。

---

## File Structure

Phase 2 结束时新增/改动的文件：

```
lib/
├── ant_design_flutter.dart                                ← 修改（新增 6 个导出）
└── src/
    └── primitives/                                        ← 新目录
        ├── interaction/
        │   └── ant_interaction_detector.dart              ← 新建
        ├── portal/
        │   ├── ant_placement.dart                         ← 新建
        │   └── ant_portal.dart                            ← 新建
        └── overlay/
            ├── ant_overlay_slot.dart                      ← 新建
            ├── overlay_entry_handle.dart                  ← 新建
            ├── ant_overlay_host.dart                      ← 新建（internal）
            └── ant_overlay_manager.dart                   ← 新建

test/
└── widget/
    └── primitives/                                        ← 新目录
        ├── interaction/
        │   └── ant_interaction_detector_test.dart         ← 新建
        ├── portal/
        │   ├── ant_placement_test.dart                    ← 新建
        │   ├── ant_portal_basic_test.dart                 ← 新建
        │   └── ant_portal_adjust_test.dart                ← 新建
        └── overlay/
            ├── ant_overlay_manager_test.dart              ← 新建
            └── ant_overlay_stacking_test.dart             ← 新建

CHANGELOG.md                                               ← 修改（新增 2.0.0-dev.3 条目）
doc/PROGRESS.md                                            ← 修改（Phase 2 → complete）
```

**职责切分：**
- `interaction/` 只关心"把 hover/focus/press/disabled 四态合成成 `Set<WidgetState>`"
- `portal/ant_placement.dart` 只放 enum 和 "placement → (targetAnchor, followerAnchor)" 映射
- `portal/ant_portal.dart` 只关心"把一块 widget 挂到 target 周围并检测越界"
- `overlay/ant_overlay_manager.dart` 是对外门面（所有公开静态方法）
- `overlay/ant_overlay_host.dart` 是**内部** StatefulWidget，per-slot 持有条目列表与布局
- `overlay/overlay_entry_handle.dart` 是 opaque 句柄，内部字段全私有

**硬规则：** `lib/src/primitives/**` 内任何文件都**不**能 `import '../theme/...'` 或 `import '../app/...'`。违反靠 code review 守护。

---

## Task 1：目录骨架 + barrel 占位

**目的：** 先把目录和空文件建好，避免后续 Task 互相 import 时缺失。

**Files:**
- Create: `lib/src/primitives/interaction/ant_interaction_detector.dart`
- Create: `lib/src/primitives/portal/ant_placement.dart`
- Create: `lib/src/primitives/portal/ant_portal.dart`
- Create: `lib/src/primitives/overlay/ant_overlay_slot.dart`
- Create: `lib/src/primitives/overlay/overlay_entry_handle.dart`
- Create: `lib/src/primitives/overlay/ant_overlay_host.dart`
- Create: `lib/src/primitives/overlay/ant_overlay_manager.dart`

- [ ] **Step 1：新建 7 个源码占位文件**

每个文件只写如下占位 —— Task 2 起逐个替换成真实实现。

写入 `lib/src/primitives/interaction/ant_interaction_detector.dart`：

```dart
// Implemented in Task 2-5.
```

用相同一行占位写入其他 6 个文件（`ant_placement.dart`、`ant_portal.dart`、`ant_overlay_slot.dart`、`overlay_entry_handle.dart`、`ant_overlay_host.dart`、`ant_overlay_manager.dart`）。

- [ ] **Step 2：运行 `flutter analyze --fatal-infos` 验证占位合法**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`（空文件不会有 lint 警告）

- [ ] **Step 3：提交骨架**

```bash
git add lib/src/primitives/
git commit -m "chore(primitives): add phase 2 directory scaffold"
```

---

## Task 2：AntInteractionDetector — 接口定义 + 初始渲染测试

**目的：** 落地公开 API 和最小可编译实现（只返回 `builder(context, {})`），先让测试基础设施就绪。

**Files:**
- Modify: `lib/src/primitives/interaction/ant_interaction_detector.dart`
- Create: `test/widget/primitives/interaction/ant_interaction_detector_test.dart`

- [ ] **Step 1：写失败测试 — 默认渲染**

写入 `test/widget/primitives/interaction/ant_interaction_detector_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntInteractionDetector — default render', () {
    testWidgets('builder receives empty states initially', (tester) async {
      Set<WidgetState>? observed;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            builder: (context, states) {
              observed = states;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      expect(observed, isNotNull);
      expect(observed, isEmpty);
    });

    testWidgets('builder receives {disabled} when enabled: false',
        (tester) async {
      Set<WidgetState>? observed;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            enabled: false,
            builder: (context, states) {
              observed = states;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      expect(observed, {WidgetState.disabled});
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 失败，`AntInteractionDetector` 未定义 / 未导出。

- [ ] **Step 3：实现最小骨架**

整文件替换 `lib/src/primitives/interaction/ant_interaction_detector.dart`：

```dart
import 'package:flutter/widgets.dart';

/// Builder 签名：拿到当前合成好的 widget states 集合。
typedef AntInteractionBuilder = Widget Function(
  BuildContext context,
  Set<WidgetState> states,
);

/// 统一的交互检测器：把 hover / focus / pressed / disabled 四态合成成
/// `Set<WidgetState>` 透传给 builder。详见 Phase 2 spec § 3。
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

  @override
  State<AntInteractionDetector> createState() =>
      _AntInteractionDetectorState();
}

class _AntInteractionDetectorState extends State<AntInteractionDetector> {
  final WidgetStatesController _controller = WidgetStatesController();

  @override
  void initState() {
    super.initState();
    _controller.update(WidgetState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(covariant AntInteractionDetector old) {
    super.didUpdateWidget(old);
    if (old.enabled != widget.enabled) {
      _controller.update(WidgetState.disabled, !widget.enabled);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}
```

- [ ] **Step 4：导出 `AntInteractionDetector`**

Edit `lib/ant_design_flutter.dart`，在现有 export 块末尾追加：

```dart
export 'src/primitives/interaction/ant_interaction_detector.dart'
    show AntInteractionDetector, AntInteractionBuilder;
```

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: `All tests passed!`（2 个测试通过）

- [ ] **Step 6：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 7：提交**

```bash
git add lib/src/primitives/interaction/ant_interaction_detector.dart \
        lib/ant_design_flutter.dart \
        test/widget/primitives/interaction/ant_interaction_detector_test.dart
git commit -m "feat(primitives): add AntInteractionDetector skeleton with disabled state"
```

---

## Task 3：AntInteractionDetector — hover 状态与回调

**目的：** 加入 `MouseRegion`，让 states 在 hover 时包含 `WidgetState.hovered`，并驱动 `onHover(bool)` 的跳变回调。

**Files:**
- Modify: `lib/src/primitives/interaction/ant_interaction_detector.dart`
- Modify: `test/widget/primitives/interaction/ant_interaction_detector_test.dart`

- [ ] **Step 1：追加失败测试 — hover 行为**

Edit `test/widget/primitives/interaction/ant_interaction_detector_test.dart`，在文件末尾的 `main()` 里追加一个新 group（不要删除已有的 group）：

```dart
  group('AntInteractionDetector — hover', () {
    testWidgets('states include hovered while pointer is inside',
        (tester) async {
      Set<WidgetState> captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              builder: (context, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(captured, contains(WidgetState.hovered));

      await gesture.moveTo(Offset.zero);
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.hovered)));
    });

    testWidgets('onHover fires once per transition', (tester) async {
      final transitions = <bool>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onHover: transitions.add,
              builder: (_, __) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      await gesture.moveBy(const Offset(1, 1)); // 同一区域内微移，不应再次回调
      await tester.pump();
      await gesture.moveTo(Offset.zero);
      await tester.pump();

      expect(transitions, <bool>[true, false]);
    });

    testWidgets('hover suppressed when disabled', (tester) async {
      final transitions = <bool>[];
      Set<WidgetState> captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              enabled: false,
              onHover: transitions.add,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();

      expect(transitions, isEmpty);
      expect(captured, isNot(contains(WidgetState.hovered)));
      expect(captured, contains(WidgetState.disabled));
    });
  });
```

还要在文件顶部 `import` 区追加：

```dart
import 'package:flutter/gestures.dart' show PointerDeviceKind;
```

- [ ] **Step 2：运行测试确认 hover group 全部失败**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 3 个新测试全失败（当前实现没有 `MouseRegion`）。

- [ ] **Step 3：在 `build` 里加入 `MouseRegion`**

Edit `lib/src/primitives/interaction/ant_interaction_detector.dart`，把 `build` 方法替换为：

```dart
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => MouseRegion(
        cursor: _resolveCursor(),
        onEnter: widget.enabled ? _handleMouseEnter : null,
        onExit: widget.enabled ? _handleMouseExit : null,
        child: widget.builder(context, _controller.value),
      ),
    );
  }

  MouseCursor _resolveCursor() {
    if (!widget.enabled) return SystemMouseCursors.forbidden;
    return widget.cursor ?? MouseCursor.defer;
  }

  void _handleMouseEnter(PointerEnterEvent _) {
    if (_controller.value.contains(WidgetState.hovered)) return;
    _controller.update(WidgetState.hovered, true);
    widget.onHover?.call(true);
  }

  void _handleMouseExit(PointerExitEvent _) {
    if (!_controller.value.contains(WidgetState.hovered)) return;
    _controller.update(WidgetState.hovered, false);
    widget.onHover?.call(false);
  }
```

还要在文件顶部 `import` 区追加：

```dart
import 'package:flutter/gestures.dart'
    show PointerEnterEvent, PointerExitEvent;
```

> 注意：`MouseRegion.onEnter/onExit` 在同一个 region 内不会重复触发，所以我们无需手动 debounce；`if (_controller.value.contains(...)) return;` 是防 re-entry 防御。

- [ ] **Step 4：运行测试确认全部通过**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 全部 5 个测试通过（2 个旧的 + 3 个新的）。

- [ ] **Step 5：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/interaction/ant_interaction_detector.dart \
        test/widget/primitives/interaction/ant_interaction_detector_test.dart
git commit -m "feat(interaction): track hovered state and fire onHover transitions"
```

---

## Task 4：AntInteractionDetector — pressed 状态 + onTap

**目的：** 加入 `GestureDetector`，在 tapDown / tapUp / tapCancel 时维护 `WidgetState.pressed`，点击完成触发 `onTap`。disabled 下不触发任何回调、不进入 pressed。

**Files:**
- Modify: `lib/src/primitives/interaction/ant_interaction_detector.dart`
- Modify: `test/widget/primitives/interaction/ant_interaction_detector_test.dart`

- [ ] **Step 1：追加失败测试 — pressed / onTap**

Edit `test/widget/primitives/interaction/ant_interaction_detector_test.dart`，在 `main()` 里追加新 group（不要删除已有内容）：

```dart
  group('AntInteractionDetector — tap & pressed', () {
    testWidgets('pressed state toggles around tap', (tester) async {
      final snapshots = <Set<WidgetState>>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () {},
              builder: (_, states) {
                snapshots.add(Set.of(states));
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(snapshots.last, contains(WidgetState.pressed));

      await gesture.up();
      await tester.pump();
      expect(snapshots.last, isNot(contains(WidgetState.pressed)));
    });

    testWidgets('onTap fires when enabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () => taps++,
              builder: (_, __) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SizedBox));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('onTap suppressed when disabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              enabled: false,
              onTap: () => taps++,
              builder: (_, __) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SizedBox));
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('pressed clears on tap cancel', (tester) async {
      var taps = 0;
      Set<WidgetState> captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () => taps++,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(captured, contains(WidgetState.pressed));

      await gesture.cancel();
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.pressed)));
      expect(taps, 0);
    });
  });
```

- [ ] **Step 2：运行测试确认 tap 组 4 条全失败**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 4 个新测试失败（当前 build 没有 GestureDetector）。

- [ ] **Step 3：在 `build` 里嵌入 `GestureDetector`**

Edit `lib/src/primitives/interaction/ant_interaction_detector.dart`，把 `build` 替换成以下版本（在 `MouseRegion` 和 `widget.builder(...)` 之间插入 `GestureDetector`）：

```dart
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => MouseRegion(
        cursor: _resolveCursor(),
        onEnter: widget.enabled ? _handleMouseEnter : null,
        onExit: widget.enabled ? _handleMouseExit : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled ? _handleTapDown : null,
          onTapUp: widget.enabled ? _handleTapUp : null,
          onTapCancel: widget.enabled ? _handleTapCancel : null,
          onTap: widget.enabled ? widget.onTap : null,
          child: widget.builder(context, _controller.value),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.update(WidgetState.pressed, true);
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.update(WidgetState.pressed, false);
  }

  void _handleTapCancel() {
    _controller.update(WidgetState.pressed, false);
  }
```

- [ ] **Step 4：运行测试确认 tap 组全部通过**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 全部 9 个测试通过（5 旧 + 4 新）。

- [ ] **Step 5：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/interaction/ant_interaction_detector.dart \
        test/widget/primitives/interaction/ant_interaction_detector_test.dart
git commit -m "feat(interaction): track pressed state and invoke onTap when enabled"
```

---

## Task 5：AntInteractionDetector — focus + 键盘激活

**目的：** 加入 `Focus` + `Actions/Shortcuts`，让 Tab 可聚焦且 focus 时按 Enter / Space 触发 `onTap`。`focusable: false` 时跳过 tab traversal；`enabled: false` 时同时退出 traversal。

**Files:**
- Modify: `lib/src/primitives/interaction/ant_interaction_detector.dart`
- Modify: `test/widget/primitives/interaction/ant_interaction_detector_test.dart`

- [ ] **Step 1：追加失败测试 — focus / 键盘激活**

Edit 测试文件，追加 group：

```dart
  group('AntInteractionDetector — focus & keyboard', () {
    testWidgets('focused state tracks FocusNode', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      Set<WidgetState> captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              focusNode: node,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      expect(captured, contains(WidgetState.focused));

      node.unfocus();
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.focused)));
    });

    testWidgets('Enter and Space trigger onTap while focused',
        (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              focusNode: node,
              onTap: () => taps++,
              builder: (_, __) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('focusable: false skips tab traversal', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            focusNode: node,
            focusable: false,
            builder: (_, __) => const SizedBox(width: 10, height: 10),
          ),
        ),
      );
      // canRequestFocus == false 时 requestFocus 不会生效
      node.requestFocus();
      await tester.pump();
      expect(node.hasFocus, isFalse);
    });

    testWidgets('disabled widget drops focus and ignores key events',
        (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            focusNode: node,
            enabled: false,
            onTap: () => taps++,
            builder: (_, __) => const SizedBox(width: 10, height: 10),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      expect(node.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 0);
    });
  });
```

在文件顶部 `import` 区追加（若尚未存在）：

```dart
import 'package:flutter/services.dart' show LogicalKeyboardKey;
```

- [ ] **Step 2：运行测试确认 focus 组失败**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 4 个新测试失败（当前没有 `Focus`）。

- [ ] **Step 3：加入 Focus + Actions，内部 FocusNode 懒创建**

Edit `lib/src/primitives/interaction/ant_interaction_detector.dart`：

**3a.** 文件顶部 `import` 区追加：

```dart
import 'package:flutter/services.dart' show LogicalKeyboardKey;
```

**3b.** 把 `_AntInteractionDetectorState` 替换为以下版本（保留 `_controller` 的已有逻辑，新增 focus 管理）：

```dart
class _AntInteractionDetectorState extends State<AntInteractionDetector> {
  final WidgetStatesController _controller = WidgetStatesController();
  FocusNode? _internalNode;

  FocusNode get _effectiveNode =>
      widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.update(WidgetState.disabled, !widget.enabled);
    _effectiveNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AntInteractionDetector old) {
    super.didUpdateWidget(old);
    if (old.enabled != widget.enabled) {
      _controller.update(WidgetState.disabled, !widget.enabled);
      if (!widget.enabled && _effectiveNode.hasFocus) {
        _effectiveNode.unfocus();
      }
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_handleFocusChange);
      _internalNode?.dispose();
      _internalNode = null;
      _effectiveNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveNode.removeListener(_handleFocusChange);
    _internalNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    _controller.update(WidgetState.focused, _effectiveNode.hasFocus);
  }

  bool get _canRequestFocus => widget.enabled && widget.focusable;

  void _activate(Intent _) {
    if (!widget.enabled) return;
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Focus(
        focusNode: _effectiveNode,
        canRequestFocus: _canRequestFocus,
        descendantsAreFocusable: false,
        child: Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
          },
          child: Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            },
            child: MouseRegion(
              cursor: _resolveCursor(),
              onEnter: widget.enabled ? _handleMouseEnter : null,
              onExit: widget.enabled ? _handleMouseExit : null,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: widget.enabled ? _handleTapDown : null,
                onTapUp: widget.enabled ? _handleTapUp : null,
                onTapCancel: widget.enabled ? _handleTapCancel : null,
                onTap: widget.enabled ? widget.onTap : null,
                child: widget.builder(context, _controller.value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _resolveCursor / _handleMouseEnter / _handleMouseExit / _handleTapDown /
  // _handleTapUp / _handleTapCancel 保留 Task 3-4 已有实现，无需重写。
}
```

> 保留 Task 3-4 已经写好的 6 个私有方法，不要改动它们的实现。若编辑器需要，可以整段替换 state 类再把旧方法粘回来。

- [ ] **Step 4：运行测试确认 focus 组全过**

Run: `flutter test test/widget/primitives/interaction/ant_interaction_detector_test.dart`
Expected: 全部 13 个测试通过（9 旧 + 4 新）。

- [ ] **Step 5：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/interaction/ant_interaction_detector.dart \
        test/widget/primitives/interaction/ant_interaction_detector_test.dart
git commit -m "feat(interaction): add focus tracking and Enter/Space activation"
```

---

## Task 6：AntPlacement enum + anchor 映射表

**目的：** 落地 12 方位枚举和"placement → (targetAnchor, followerAnchor)"映射。映射表是 Phase 2 spec § 4.3 的代码镜像；table-driven test 固化每一条。

**Files:**
- Modify: `lib/src/primitives/portal/ant_placement.dart`
- Create: `test/widget/primitives/portal/ant_placement_test.dart`

- [ ] **Step 1：写失败测试（12 条映射 + flip 行为）**

写入 `test/widget/primitives/portal/ant_placement_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart'
    show antPlacementAnchors, flipAntPlacement, AntPlacementAnchors;
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntPlacement anchor table', () {
    // 语义对齐 Phase 2 spec § 4.3
    const expected = <AntPlacement, AntPlacementAnchors>{
      AntPlacement.top:
          AntPlacementAnchors(Alignment.topCenter, Alignment.bottomCenter),
      AntPlacement.topLeft:
          AntPlacementAnchors(Alignment.topLeft, Alignment.bottomLeft),
      AntPlacement.topRight:
          AntPlacementAnchors(Alignment.topRight, Alignment.bottomRight),
      AntPlacement.bottom:
          AntPlacementAnchors(Alignment.bottomCenter, Alignment.topCenter),
      AntPlacement.bottomLeft:
          AntPlacementAnchors(Alignment.bottomLeft, Alignment.topLeft),
      AntPlacement.bottomRight:
          AntPlacementAnchors(Alignment.bottomRight, Alignment.topRight),
      AntPlacement.left:
          AntPlacementAnchors(Alignment.centerLeft, Alignment.centerRight),
      AntPlacement.leftTop:
          AntPlacementAnchors(Alignment.topLeft, Alignment.topRight),
      AntPlacement.leftBottom:
          AntPlacementAnchors(Alignment.bottomLeft, Alignment.bottomRight),
      AntPlacement.right:
          AntPlacementAnchors(Alignment.centerRight, Alignment.centerLeft),
      AntPlacement.rightTop:
          AntPlacementAnchors(Alignment.topRight, Alignment.topLeft),
      AntPlacement.rightBottom:
          AntPlacementAnchors(Alignment.bottomRight, Alignment.bottomLeft),
    };

    for (final entry in expected.entries) {
      test('${entry.key} maps to ${entry.value}', () {
        expect(antPlacementAnchors[entry.key], entry.value);
      });
    }

    test('anchor table covers all 12 placements', () {
      expect(antPlacementAnchors.length, 12);
      for (final p in AntPlacement.values) {
        expect(antPlacementAnchors.containsKey(p), isTrue,
            reason: '$p missing');
      }
    });
  });

  group('flipAntPlacement', () {
    const topAxis = <AntPlacement, AntPlacement>{
      AntPlacement.top: AntPlacement.bottom,
      AntPlacement.topLeft: AntPlacement.bottomLeft,
      AntPlacement.topRight: AntPlacement.bottomRight,
      AntPlacement.bottom: AntPlacement.top,
      AntPlacement.bottomLeft: AntPlacement.topLeft,
      AntPlacement.bottomRight: AntPlacement.topRight,
    };
    const horizontalAxis = <AntPlacement, AntPlacement>{
      AntPlacement.left: AntPlacement.right,
      AntPlacement.leftTop: AntPlacement.rightTop,
      AntPlacement.leftBottom: AntPlacement.rightBottom,
      AntPlacement.right: AntPlacement.left,
      AntPlacement.rightTop: AntPlacement.leftTop,
      AntPlacement.rightBottom: AntPlacement.leftBottom,
    };

    for (final entry in topAxis.entries) {
      test('${entry.key} flips vertically to ${entry.value}', () {
        expect(flipAntPlacement(entry.key, vertical: true), entry.value);
      });
    }
    for (final entry in horizontalAxis.entries) {
      test('${entry.key} flips horizontally to ${entry.value}', () {
        expect(flipAntPlacement(entry.key, vertical: false), entry.value);
      });
    }
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/portal/ant_placement_test.dart`
Expected: 所有 25 条测试失败（符号未定义）。

- [ ] **Step 3：实现 enum + 映射 + flip**

整文件替换 `lib/src/primitives/portal/ant_placement.dart`：

```dart
import 'package:flutter/painting.dart' show Alignment;

/// Portal 12 方位。语义对齐 AntD v5 `Tooltip.placement`。详见 Phase 2 spec § 4.3。
enum AntPlacement {
  topLeft, top, topRight,
  rightTop, right, rightBottom,
  bottomRight, bottom, bottomLeft,
  leftBottom, left, leftTop,
}

/// (targetAnchor, followerAnchor) 对。用于 `CompositedTransformFollower`。
@immutable
class AntPlacementAnchors {
  const AntPlacementAnchors(this.target, this.follower);
  final Alignment target;
  final Alignment follower;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntPlacementAnchors &&
          other.target == target &&
          other.follower == follower;

  @override
  int get hashCode => Object.hash(target, follower);

  @override
  String toString() => 'AntPlacementAnchors($target → $follower)';
}

/// spec § 4.3 映射表。
const Map<AntPlacement, AntPlacementAnchors> antPlacementAnchors =
    <AntPlacement, AntPlacementAnchors>{
  AntPlacement.top:
      AntPlacementAnchors(Alignment.topCenter, Alignment.bottomCenter),
  AntPlacement.topLeft:
      AntPlacementAnchors(Alignment.topLeft, Alignment.bottomLeft),
  AntPlacement.topRight:
      AntPlacementAnchors(Alignment.topRight, Alignment.bottomRight),
  AntPlacement.bottom:
      AntPlacementAnchors(Alignment.bottomCenter, Alignment.topCenter),
  AntPlacement.bottomLeft:
      AntPlacementAnchors(Alignment.bottomLeft, Alignment.topLeft),
  AntPlacement.bottomRight:
      AntPlacementAnchors(Alignment.bottomRight, Alignment.topRight),
  AntPlacement.left:
      AntPlacementAnchors(Alignment.centerLeft, Alignment.centerRight),
  AntPlacement.leftTop:
      AntPlacementAnchors(Alignment.topLeft, Alignment.topRight),
  AntPlacement.leftBottom:
      AntPlacementAnchors(Alignment.bottomLeft, Alignment.bottomRight),
  AntPlacement.right:
      AntPlacementAnchors(Alignment.centerRight, Alignment.centerLeft),
  AntPlacement.rightTop:
      AntPlacementAnchors(Alignment.topRight, Alignment.topLeft),
  AntPlacement.rightBottom:
      AntPlacementAnchors(Alignment.bottomRight, Alignment.bottomLeft),
};

/// 按主轴翻转 placement。`vertical: true` 翻 top↔bottom；否则翻 left↔right。
/// 副轴保持不变。详见 Phase 2 spec § 4.3 flip 映射。
AntPlacement flipAntPlacement(AntPlacement p, {required bool vertical}) {
  if (vertical) {
    switch (p) {
      case AntPlacement.top: return AntPlacement.bottom;
      case AntPlacement.topLeft: return AntPlacement.bottomLeft;
      case AntPlacement.topRight: return AntPlacement.bottomRight;
      case AntPlacement.bottom: return AntPlacement.top;
      case AntPlacement.bottomLeft: return AntPlacement.topLeft;
      case AntPlacement.bottomRight: return AntPlacement.topRight;
      case AntPlacement.left:
      case AntPlacement.leftTop:
      case AntPlacement.leftBottom:
      case AntPlacement.right:
      case AntPlacement.rightTop:
      case AntPlacement.rightBottom:
        return p;
    }
  }
  switch (p) {
    case AntPlacement.left: return AntPlacement.right;
    case AntPlacement.leftTop: return AntPlacement.rightTop;
    case AntPlacement.leftBottom: return AntPlacement.rightBottom;
    case AntPlacement.right: return AntPlacement.left;
    case AntPlacement.rightTop: return AntPlacement.leftTop;
    case AntPlacement.rightBottom: return AntPlacement.leftBottom;
    case AntPlacement.top:
    case AntPlacement.topLeft:
    case AntPlacement.topRight:
    case AntPlacement.bottom:
    case AntPlacement.bottomLeft:
    case AntPlacement.bottomRight:
      return p;
  }
}
```

还要在顶部加 `import 'package:meta/meta.dart' show immutable;`？不需要 —— `@immutable` 在 `package:flutter/foundation.dart` 里导出。若 analyzer 抱怨，改为：

```dart
import 'package:flutter/foundation.dart' show immutable;
```

- [ ] **Step 4：导出 `AntPlacement`**

Edit `lib/ant_design_flutter.dart`，在 export 块追加：

```dart
export 'src/primitives/portal/ant_placement.dart' show AntPlacement;
```

> `antPlacementAnchors` 常量和 `flipAntPlacement` 函数**不导出**（仅供 `ant_portal.dart` 和测试文件用内部 import 访问）。

- [ ] **Step 5：运行测试确认通过**

Run: `flutter test test/widget/primitives/portal/ant_placement_test.dart`
Expected: 25 条测试全部通过。

- [ ] **Step 6：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 7：提交**

```bash
git add lib/src/primitives/portal/ant_placement.dart \
        lib/ant_design_flutter.dart \
        test/widget/primitives/portal/ant_placement_test.dart
git commit -m "feat(portal): add AntPlacement enum with anchor table and flip helper"
```

---

## Task 7：AntPortal — 基础挂载/卸载（visible 驱动 OverlayEntry）

**目的：** 落地 `AntPortal` 骨架：`visible: true` 时 insert `OverlayEntry`，`visible: false` / dispose 时 remove。这一步先不管 12 方位和翻转，overlay 直接用 `Center` 居中，只验证生命周期。

**Files:**
- Modify: `lib/src/primitives/portal/ant_portal.dart`
- Create: `test/widget/primitives/portal/ant_portal_basic_test.dart`

- [ ] **Step 1：写失败测试 — 生命周期**

写入 `test/widget/primitives/portal/ant_portal_basic_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 让 AntPortal 能拿到 Overlay 的最小 host。
Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => child),
        ],
      ),
    ),
  );
}

void main() {
  group('AntPortal — lifecycle', () {
    testWidgets('overlayBuilder not invoked when visible: false',
        (tester) async {
      var built = 0;
      await tester.pumpWidget(
        _host(
          child: Center(
            child: AntPortal(
              overlayBuilder: (_) {
                built++;
                return const SizedBox(width: 20, height: 20);
              },
              child: const SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      );
      expect(built, 0);
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });

    testWidgets('overlay inserts when visible flips to true', (tester) async {
      Widget buildApp({required bool visible}) => _host(
            child: Center(
              child: AntPortal(
                visible: visible,
                overlayBuilder: (_) => const ColoredBox(
                  key: ValueKey('tooltip-content'),
                  color: Color(0xFFFF0000),
                  child: SizedBox(width: 20, height: 20),
                ),
                child: const SizedBox(width: 10, height: 10),
              ),
            ),
          );

      await tester.pumpWidget(buildApp(visible: false));
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);

      await tester.pumpWidget(buildApp(visible: true));
      await tester.pump();
      expect(find.byKey(const ValueKey('tooltip-content')), findsOneWidget);

      await tester.pumpWidget(buildApp(visible: false));
      await tester.pump();
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });

    testWidgets('overlay removed on dispose', (tester) async {
      Widget buildApp({required bool mounted}) => _host(
            child: mounted
                ? Center(
                    child: AntPortal(
                      visible: true,
                      overlayBuilder: (_) => const ColoredBox(
                        key: ValueKey('tooltip-content'),
                        color: Color(0xFFFF0000),
                        child: SizedBox(width: 20, height: 20),
                      ),
                      child: const SizedBox(width: 10, height: 10),
                    ),
                  )
                : const SizedBox.shrink(),
          );

      await tester.pumpWidget(buildApp(mounted: true));
      await tester.pump();
      expect(find.byKey(const ValueKey('tooltip-content')), findsOneWidget);

      await tester.pumpWidget(buildApp(mounted: false));
      await tester.pump();
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/portal/ant_portal_basic_test.dart`
Expected: `AntPortal` 未定义，全部失败。

- [ ] **Step 3：实现 AntPortal 骨架（Center 占位定位）**

整文件替换 `lib/src/primitives/portal/ant_portal.dart`：

```dart
import 'package:flutter/widgets.dart';

import 'ant_placement.dart';

/// 基于 `CompositedTransformTarget/Follower` 的锚点弹层原语。
/// Phase 2 spec § 4。视觉（配色 / 阴影 / 箭头 / 动画）由 consumer 负责，
/// 本组件只负责几何定位与生命周期。
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

  final Widget child;
  final WidgetBuilder overlayBuilder;
  final AntPlacement placement;
  final bool visible;
  final Offset offset;
  final bool autoAdjustOverflow;
  final VoidCallback? onDismiss;

  @override
  State<AntPortal> createState() => _AntPortalState();
}

class _AntPortalState extends State<AntPortal> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  @override
  void didUpdateWidget(covariant AntPortal old) {
    super.didUpdateWidget(old);
    if (old.visible != widget.visible ||
        old.placement != widget.placement ||
        old.offset != widget.offset) {
      _syncEntry();
    } else if (_entry != null) {
      _entry!.markNeedsBuild();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncEntry();
  }

  @override
  void dispose() {
    _removeEntry();
    super.dispose();
  }

  void _syncEntry() {
    if (widget.visible) {
      if (_entry == null) {
        _entry = OverlayEntry(builder: _buildOverlay);
        Overlay.of(context, debugRequiredFor: widget).insert(_entry!);
      } else {
        _entry!.markNeedsBuild();
      }
    } else {
      _removeEntry();
    }
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext context) {
    // Task 8 会替换成 CompositedTransformFollower 精确定位；
    // 目前只挂在 Overlay 顶部居中，仅用于生命周期验证。
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        child: widget.overlayBuilder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _link, child: widget.child);
  }
}
```

- [ ] **Step 4：导出 `AntPortal`**

Edit `lib/ant_design_flutter.dart`，在 export 块追加：

```dart
export 'src/primitives/portal/ant_portal.dart' show AntPortal;
```

- [ ] **Step 5：运行测试确认生命周期测试通过**

Run: `flutter test test/widget/primitives/portal/ant_portal_basic_test.dart`
Expected: 3 条测试通过（precise positioning 留到 Task 8）。

- [ ] **Step 6：运行 analyze + 所有测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全局 `No issues found!` 且所有现有测试通过。

- [ ] **Step 7：提交**

```bash
git add lib/src/primitives/portal/ant_portal.dart \
        lib/ant_design_flutter.dart \
        test/widget/primitives/portal/ant_portal_basic_test.dart
git commit -m "feat(portal): add AntPortal lifecycle scaffold"
```

---

## Task 8：AntPortal — 12 方位精确定位 + offset

**目的：** 把 Task 7 的 `Positioned(left:0, top:0)` 占位替换成 `CompositedTransformFollower(targetAnchor, followerAnchor, offset)`，使 overlay 真正按 placement 贴到 target 周围。

**Files:**
- Modify: `lib/src/primitives/portal/ant_portal.dart`
- Modify: `test/widget/primitives/portal/ant_portal_basic_test.dart`

- [ ] **Step 1：追加失败测试 — 3 个代表方位的几何断言**

Edit `test/widget/primitives/portal/ant_portal_basic_test.dart`，在 `main()` 里追加 group（不要删除 `_host` / lifecycle group）：

```dart
  group('AntPortal — placement geometry', () {
    const overlayKey = ValueKey('overlay');
    const targetKey = ValueKey('target');

    Widget buildCase(AntPlacement placement, {Offset offset = Offset.zero}) =>
        _host(
          child: Center(
            child: AntPortal(
              visible: true,
              placement: placement,
              offset: offset,
              autoAdjustOverflow: false,
              overlayBuilder: (_) => const SizedBox(
                key: overlayKey,
                width: 40,
                height: 20,
              ),
              child: const SizedBox(
                key: targetKey,
                width: 60,
                height: 30,
              ),
            ),
          ),
        );

    testWidgets('top: overlay bottom edge aligns with target top',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.top));
      await tester.pump();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.bottom, closeTo(target.top, 0.5));
      // horizontally centered
      expect(overlay.center.dx, closeTo(target.center.dx, 0.5));
    });

    testWidgets('bottomRight: overlay top-right aligns with target bottom-right',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.bottomRight));
      await tester.pump();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.top, closeTo(target.bottom, 0.5));
      expect(overlay.right, closeTo(target.right, 0.5));
    });

    testWidgets('left: overlay right edge aligns with target left',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.left));
      await tester.pump();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.right, closeTo(target.left, 0.5));
      expect(overlay.center.dy, closeTo(target.center.dy, 0.5));
    });

    testWidgets('offset shifts overlay', (tester) async {
      await tester.pumpWidget(
        buildCase(AntPlacement.top, offset: const Offset(0, -8)),
      );
      await tester.pump();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      // overlay 底边在 target 顶边上方 8 px 处
      expect(overlay.bottom, closeTo(target.top - 8, 0.5));
    });
  });
```

- [ ] **Step 2：运行测试确认几何测试失败**

Run: `flutter test test/widget/primitives/portal/ant_portal_basic_test.dart`
Expected: 4 个新测试失败（当前 follower 挂在 (0,0)）。

- [ ] **Step 3：替换 `_buildOverlay` 使用映射表**

Edit `lib/src/primitives/portal/ant_portal.dart`，把 `_buildOverlay` 方法替换为：

```dart
  Widget _buildOverlay(BuildContext context) {
    final anchors = antPlacementAnchors[widget.placement]!;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: anchors.target,
          followerAnchor: anchors.follower,
          offset: widget.offset,
          child: Align(
            alignment: Alignment.topLeft,
            child: widget.overlayBuilder(context),
          ),
        ),
      ),
    );
  }
```

> 说明：
> - `Positioned.fill` 给 follower 一个明确的约束框，让 `CompositedTransformFollower` 能 layout
> - `Align(topLeft)` 让 follower 内容的尺寸由自身决定（不被 fill 拉伸）
> - `CompositedTransformFollower` 自己的 `targetAnchor/followerAnchor/offset` 实现 placement 语义

- [ ] **Step 4：运行 placement 测试确认通过**

Run: `flutter test test/widget/primitives/portal/ant_portal_basic_test.dart`
Expected: 全部 7 条测试通过（3 lifecycle + 4 geometry）。

- [ ] **Step 5：运行 analyze + 所有测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全绿。

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/portal/ant_portal.dart \
        test/widget/primitives/portal/ant_portal_basic_test.dart
git commit -m "feat(portal): position overlay via placement anchors and offset"
```

---

## Task 9：AntPortal — `autoAdjustOverflow` 翻转

**目的：** overlay 挂载后在 `addPostFrameCallback` 里检测越界，若越界则把 placement 翻到对侧主轴一次；副轴保持。`autoAdjustOverflow: false` 时完全不翻。

**Files:**
- Modify: `lib/src/primitives/portal/ant_portal.dart`
- Create: `test/widget/primitives/portal/ant_portal_adjust_test.dart`

- [ ] **Step 1：写失败测试 — 翻转**

写入 `test/widget/primitives/portal/ant_portal_adjust_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child, Size size = const Size(800, 600)}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => child),
        ],
      ),
    ),
  );
}

void main() {
  const overlayKey = ValueKey('overlay');
  const targetKey = ValueKey('target');

  Widget buildCase({
    required AntPlacement placement,
    required bool autoAdjustOverflow,
    required Alignment targetAlignment,
    Size overlaySize = const Size(40, 100),
  }) =>
      _host(
        child: Align(
          alignment: targetAlignment,
          child: AntPortal(
            visible: true,
            placement: placement,
            autoAdjustOverflow: autoAdjustOverflow,
            overlayBuilder: (_) => SizedBox(
              key: overlayKey,
              width: overlaySize.width,
              height: overlaySize.height,
            ),
            child: const SizedBox(
              key: targetKey,
              width: 40,
              height: 20,
            ),
          ),
        ),
      );

  testWidgets('flips top→bottom when target hugs screen top', (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.topCenter,
      overlaySize: const Size(40, 100),
    ));
    // first frame: overlay requested at top (overflow), next frame flip to bottom
    await tester.pump();
    await tester.pump();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(overlay.top, closeTo(target.bottom, 0.5),
        reason: 'should have flipped to bottom');
  });

  testWidgets('does not flip when autoAdjustOverflow: false',
      (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: false,
      targetAlignment: Alignment.topCenter,
      overlaySize: const Size(40, 100),
    ));
    await tester.pump();
    await tester.pump();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    // overflows off the top — but we asked NOT to flip
    expect(overlay.bottom, closeTo(target.top, 0.5),
        reason: 'must stay on top even when overflowing');
  });

  testWidgets('flips only once per mount', (tester) async {
    // If the algorithm had no lock, a flipped overlay that then overflows
    // the opposite side would flip back. We assert no oscillation.
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.topCenter,
      overlaySize: const Size(40, 100),
    ));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    await tester.pump();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    // must remain bottom-flipped, not oscillate back to top
    expect(overlay.top, closeTo(target.bottom, 0.5));
  });

  testWidgets('flips left→right when target hugs screen left',
      (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.left,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.centerLeft,
      overlaySize: const Size(120, 20),
    ));
    await tester.pump();
    await tester.pump();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(overlay.left, closeTo(target.right, 0.5),
        reason: 'should have flipped to right');
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/portal/ant_portal_adjust_test.dart`
Expected: 4 条失败（当前 `autoAdjustOverflow` 不生效）。

- [ ] **Step 3：实现翻转逻辑**

Edit `lib/src/primitives/portal/ant_portal.dart`。改动有三处：

**3a.** 给 `_AntPortalState` 新增两个字段：

```dart
  AntPlacement? _effectivePlacement; // 翻转后的有效 placement；null 表示未计算
  bool _adjustScheduled = false;
```

**3b.** 把 `_syncEntry` 替换为：

```dart
  void _syncEntry() {
    if (widget.visible) {
      if (_entry == null) {
        _effectivePlacement = widget.placement;
        _adjustScheduled = false;
        _entry = OverlayEntry(builder: _buildOverlay);
        Overlay.of(context, debugRequiredFor: widget).insert(_entry!);
        _scheduleAdjust();
      } else {
        // placement / offset 改变 → 重算
        _effectivePlacement = widget.placement;
        _adjustScheduled = false;
        _entry!.markNeedsBuild();
        _scheduleAdjust();
      }
    } else {
      _removeEntry();
    }
  }
```

**3c.** 新增 `_scheduleAdjust` 方法，并把 `_buildOverlay` 里的 `widget.placement` 替换为 `_effectivePlacement ?? widget.placement`：

```dart
  void _scheduleAdjust() {
    if (!widget.autoAdjustOverflow) return;
    if (_adjustScheduled) return;
    _adjustScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _entry == null) return;
      _maybeFlip();
    });
  }

  void _maybeFlip() {
    final overlayBox = _findFollowerRenderBox();
    if (overlayBox == null || !overlayBox.hasSize) return;
    final origin = overlayBox.localToGlobal(Offset.zero);
    final size = overlayBox.size;
    final screen = MediaQuery.of(context).size;

    final overflowsTop = origin.dy < 0;
    final overflowsBottom = origin.dy + size.height > screen.height;
    final overflowsLeft = origin.dx < 0;
    final overflowsRight = origin.dx + size.width > screen.width;

    final current = _effectivePlacement ?? widget.placement;
    AntPlacement next = current;

    // 垂直主轴 placements
    const verticalAxis = <AntPlacement>{
      AntPlacement.top, AntPlacement.topLeft, AntPlacement.topRight,
      AntPlacement.bottom, AntPlacement.bottomLeft, AntPlacement.bottomRight,
    };
    if (verticalAxis.contains(current)) {
      final isTopSide = current == AntPlacement.top ||
          current == AntPlacement.topLeft ||
          current == AntPlacement.topRight;
      if (isTopSide && overflowsTop && !overflowsBottom) {
        next = flipAntPlacement(current, vertical: true);
      } else if (!isTopSide && overflowsBottom && !overflowsTop) {
        next = flipAntPlacement(current, vertical: true);
      }
    } else {
      final isLeftSide = current == AntPlacement.left ||
          current == AntPlacement.leftTop ||
          current == AntPlacement.leftBottom;
      if (isLeftSide && overflowsLeft && !overflowsRight) {
        next = flipAntPlacement(current, vertical: false);
      } else if (!isLeftSide && overflowsRight && !overflowsLeft) {
        next = flipAntPlacement(current, vertical: false);
      }
    }

    if (next != current) {
      _effectivePlacement = next;
      _entry?.markNeedsBuild();
    }
    // no matter the result, lock — no further scheduling this mount
  }

  RenderBox? _findFollowerRenderBox() {
    final key = _followerKey.currentContext?.findRenderObject();
    return key is RenderBox ? key : null;
  }
```

**3d.** 在 `_AntPortalState` 类字段区域新增一个 `GlobalKey`：

```dart
  final GlobalKey _followerKey = GlobalKey();
```

并把 `_buildOverlay` 的 follower 子树包上这个 key：

```dart
  Widget _buildOverlay(BuildContext context) {
    final placement = _effectivePlacement ?? widget.placement;
    final anchors = antPlacementAnchors[placement]!;
    return Positioned.fill(
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: anchors.target,
        followerAnchor: anchors.follower,
        offset: widget.offset,
        child: Align(
          alignment: Alignment.topLeft,
          child: KeyedSubtree(
            key: _followerKey,
            child: widget.overlayBuilder(context),
          ),
        ),
      ),
    );
  }
```

> 说明："flip only once per mount"由 `_effectivePlacement` 锁定保证 —— `_maybeFlip` 调用一次就把 `_effectivePlacement` 设死，未来 frame 不再调度（除非 visible 切换）。

- [ ] **Step 4：运行 adjust 测试确认通过**

Run: `flutter test test/widget/primitives/portal/ant_portal_adjust_test.dart`
Expected: 4 条测试通过。

- [ ] **Step 5：确认原 basic 测试未回归**

Run: `flutter test test/widget/primitives/portal/`
Expected: 全部测试通过（lifecycle + geometry + adjust）。

- [ ] **Step 6：运行 analyze**

Run: `flutter analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 7：提交**

```bash
git add lib/src/primitives/portal/ant_portal.dart \
        test/widget/primitives/portal/ant_portal_adjust_test.dart
git commit -m "feat(portal): flip placement once when overlay overflows screen"
```

---

## Task 10：OverlaySlot + OverlayEntryHandle 骨架

**目的：** 先落地 `AntOverlaySlot` enum 和 opaque `OverlayEntryHandle` 类型。没有行为，只是让 Task 11-13 有类型可用。

**Files:**
- Modify: `lib/src/primitives/overlay/ant_overlay_slot.dart`
- Modify: `lib/src/primitives/overlay/overlay_entry_handle.dart`
- Modify: `lib/ant_design_flutter.dart`

- [ ] **Step 1：写 `AntOverlaySlot` enum**

整文件替换 `lib/src/primitives/overlay/ant_overlay_slot.dart`：

```dart
/// `AntOverlayManager` 的 4 个 slot。每个 slot 在一个 Overlay 下最多一个 host。
/// 详见 Phase 2 spec § 5。
enum AntOverlaySlot {
  /// 顶部居中，多条垂直堆叠（FIFO）。
  message,

  /// 右上角，多条垂直堆叠（FIFO）。
  notification,

  /// 屏幕居中，单例（再次 show 先 dismiss 旧的）。
  modal,

  /// 屏幕右侧，单例。
  drawer,
}

extension AntOverlaySlotX on AntOverlaySlot {
  /// 是否单例（同 slot 同时只允许一条）。
  bool get isSingleton =>
      this == AntOverlaySlot.modal || this == AntOverlaySlot.drawer;
}
```

- [ ] **Step 2：写 opaque `OverlayEntryHandle`**

整文件替换 `lib/src/primitives/overlay/overlay_entry_handle.dart`：

```dart
import 'ant_overlay_slot.dart';

/// 不透明句柄。consumer 只用它传给 `AntOverlayManager.dismiss`。
/// 内部字段全部 library-private，外部不可读。
class OverlayEntryHandle {
  /// @internal
  OverlayEntryHandle.internal(this.slot, this.id);

  /// @internal
  final AntOverlaySlot slot;

  /// @internal 自增 id，Manager 侧用来在 host 的 list 中定位。
  final int id;

  bool _dismissed = false;

  /// @internal
  bool get isDismissed => _dismissed;

  /// @internal
  void markDismissed() => _dismissed = true;

  @override
  String toString() =>
      'OverlayEntryHandle(${slot.name}#$id${_dismissed ? ' dismissed' : ''})';
}
```

> 说明：这里把"内部"字段名加 `internal` 后缀，避免 Dart 包内其他文件以为它们是公开 API；公开 API 在 dartdoc 上只承认 `OverlayEntryHandle` 类型本身。

- [ ] **Step 3：导出两个公开符号**

Edit `lib/ant_design_flutter.dart`，追加：

```dart
export 'src/primitives/overlay/ant_overlay_slot.dart' show AntOverlaySlot;
export 'src/primitives/overlay/overlay_entry_handle.dart'
    show OverlayEntryHandle;
```

> `AntOverlaySlotX` extension 不导出（仅供内部 host / manager 使用）；`OverlayEntryHandle.internal` 构造器 / `markDismissed` 方法即使可见，consumer 在外部也通常不会调用。

- [ ] **Step 4：analyze + 测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全绿（新增类未被使用，不会产生告警，因为它们被导出了）。

- [ ] **Step 5：提交**

```bash
git add lib/src/primitives/overlay/ant_overlay_slot.dart \
        lib/src/primitives/overlay/overlay_entry_handle.dart \
        lib/ant_design_flutter.dart
git commit -m "feat(overlay): add AntOverlaySlot enum and OverlayEntryHandle"
```

---

## Task 11：AntOverlayHost internal widget + 基础 show/dismiss

**目的：** 落地 per-slot 的 host `StatefulWidget`。host 的 state 持有 `List<_HostedEntry>` 并渲染；`AntOverlayManager.show/dismiss` 走 host state 的公开方法（包私有 API）。本 Task 先完成 `message`/`notification` 两个 list slot 的最小可用版本；modal/drawer 留到 Task 13。

**Files:**
- Modify: `lib/src/primitives/overlay/ant_overlay_host.dart`
- Modify: `lib/src/primitives/overlay/ant_overlay_manager.dart`
- Create: `test/widget/primitives/overlay/ant_overlay_manager_test.dart`

- [ ] **Step 1：写失败测试 — 基础 show/dismiss**

写入 `test/widget/primitives/overlay/ant_overlay_manager_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Overlay(
          initialEntries: [OverlayEntry(builder: (_) => child)],
        ),
      ),
    );

void main() {
  group('AntOverlayManager — show/dismiss', () {
    testWidgets('shows and dismisses a message entry', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(_host(
        child: Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
      ));

      final handle = AntOverlayManager.show(
        context: capturedContext,
        slot: AntOverlaySlot.message,
        builder: (_) => const ColoredBox(
          key: ValueKey('msg-1'),
          color: Color(0xFFFFFFFF),
          child: SizedBox(width: 100, height: 30),
        ),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('msg-1')), findsOneWidget);

      AntOverlayManager.dismiss(handle);
      await tester.pump();
      expect(find.byKey(const ValueKey('msg-1')), findsNothing);
    });

    testWidgets('dismiss is idempotent on already-dismissed handle',
        (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(_host(
        child: Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
      ));

      final handle = AntOverlayManager.show(
        context: capturedContext,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('msg'), height: 10),
      );
      await tester.pump();
      AntOverlayManager.dismiss(handle);
      await tester.pump();
      // 再次 dismiss 不应抛错
      expect(() => AntOverlayManager.dismiss(handle), returnsNormally);
    });

    testWidgets('dismissAll clears a slot', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(_host(
        child: Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
      ));

      AntOverlayManager.show(
        context: capturedContext,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('a'), height: 10),
      );
      AntOverlayManager.show(
        context: capturedContext,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('b'), height: 10),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('a')), findsOneWidget);
      expect(find.byKey(const ValueKey('b')), findsOneWidget);

      AntOverlayManager.dismissAll(
          AntOverlaySlot.message, capturedContext);
      await tester.pump();
      expect(find.byKey(const ValueKey('a')), findsNothing);
      expect(find.byKey(const ValueKey('b')), findsNothing);
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_manager_test.dart`
Expected: 3 条测试失败（`AntOverlayManager` 未定义）。

- [ ] **Step 3：实现 `AntOverlayHost`**

整文件替换 `lib/src/primitives/overlay/ant_overlay_host.dart`：

```dart
import 'package:flutter/widgets.dart';

import 'ant_overlay_slot.dart';

/// 内部：per-(Overlay × slot) 的 host widget。
/// 由 `AntOverlayManager` 注入到 `OverlayEntry` 中，通过 `GlobalKey<_AntOverlayHostState>`
/// 拿到 state 后增删条目。
class AntOverlayHost extends StatefulWidget {
  const AntOverlayHost({super.key, required this.slot});

  final AntOverlaySlot slot;

  @override
  State<AntOverlayHost> createState() => AntOverlayHostState();
}

class _HostedEntry {
  _HostedEntry(this.id, this.builder);
  final int id;
  final WidgetBuilder builder;
}

class AntOverlayHostState extends State<AntOverlayHost> {
  final List<_HostedEntry> _entries = <_HostedEntry>[];

  /// 内部 API：`AntOverlayManager.show` 调用。
  void addEntry(int id, WidgetBuilder builder) {
    setState(() {
      if (widget.slot.isSingleton && _entries.isNotEmpty) {
        _entries.clear();
      }
      _entries.add(_HostedEntry(id, builder));
    });
  }

  /// 内部 API：`AntOverlayManager.dismiss` 调用。
  void removeEntry(int id) {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    setState(() => _entries.removeAt(idx));
  }

  /// 内部 API：`AntOverlayManager.dismissAll` 调用。
  void clear() {
    if (_entries.isEmpty) return;
    setState(_entries.clear);
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) return const SizedBox.shrink();
    // Task 12 会按 slot 切换布局；Task 11 先用最简单的 Stack 叠放。
    return Stack(
      children: [
        for (final e in _entries)
          KeyedSubtree(key: ValueKey('ant-overlay-${widget.slot.name}-${e.id}'),
              child: e.builder(context)),
      ],
    );
  }
}
```

- [ ] **Step 4：实现 `AntOverlayManager` 门面**

整文件替换 `lib/src/primitives/overlay/ant_overlay_manager.dart`：

```dart
import 'package:flutter/widgets.dart';

import 'ant_overlay_host.dart';
import 'ant_overlay_slot.dart';
import 'overlay_entry_handle.dart';

/// 浮层管理器。详见 Phase 2 spec § 5。
abstract final class AntOverlayManager {
  static int _idSeq = 0;

  /// (Overlay → (slot → hostKey))
  static final Expando<Map<AntOverlaySlot, GlobalKey<AntOverlayHostState>>>
      _hostsByOverlay = Expando();

  /// (Overlay → (slot → OverlayEntry))
  static final Expando<Map<AntOverlaySlot, OverlayEntry>> _entriesByOverlay =
      Expando();

  static OverlayEntryHandle show({
    required BuildContext context,
    required AntOverlaySlot slot,
    required WidgetBuilder builder,
  }) {
    final overlay = Overlay.of(context, rootOverlay: false);
    final hostKey = _ensureHost(overlay, slot);
    final id = ++_idSeq;
    hostKey.currentState!.addEntry(id, builder);
    return OverlayEntryHandle.internal(slot, id);
  }

  static void dismiss(OverlayEntryHandle handle) {
    if (handle.isDismissed) return;
    // 遍历所有已知 Overlay 找到包含该 slot 的 host；
    // 因为 Expando 不可枚举，这里采用"尝试从每个活跃 OverlayEntry 发起"的朴素路径：
    // 由于 dismiss 通常在同一个 Overlay 下发生，我们让 host 去自行处理 "find & remove"。
    // 实际实现：在 _hostsByOverlay 里找出所有匹配 slot 的 host，让每个 host 去 removeEntry(id)。
    for (final host in _allHostsForSlot(handle.slot)) {
      host.currentState?.removeEntry(handle.id);
    }
    handle.markDismissed();
  }

  static void dismissAll(AntOverlaySlot slot, BuildContext context) {
    final overlay = Overlay.of(context, rootOverlay: false);
    final hosts = _hostsByOverlay[overlay];
    final hostKey = hosts?[slot];
    hostKey?.currentState?.clear();
  }

  // ---------- internal helpers ----------

  /// 已注册过的 Overlay 列表。`Expando` 无法枚举，这里用伴随 list 让
  /// `_allHostsForSlot` 能跨 Overlay 查找。Overlay dispose 时该 list 不主动清理
  /// —— MVP 单 WidgetsApp 下不会增长；测试用 tearDown 负责清理。
  static final List<OverlayState> _registeredOverlays = <OverlayState>[];

  static GlobalKey<AntOverlayHostState> _ensureHost(
      OverlayState overlay, AntOverlaySlot slot) {
    if (!_registeredOverlays.contains(overlay)) {
      _registeredOverlays.add(overlay);
    }
    final hosts = _hostsByOverlay[overlay] ??= {};
    final entries = _entriesByOverlay[overlay] ??= {};
    final existing = hosts[slot];
    if (existing != null) return existing;

    final key = GlobalKey<AntOverlayHostState>();
    hosts[slot] = key;
    final entry = OverlayEntry(
      builder: (_) => AntOverlayHost(key: key, slot: slot),
    );
    entries[slot] = entry;
    overlay.insert(entry);
    return key;
  }

  static Iterable<GlobalKey<AntOverlayHostState>> _allHostsForSlot(
      AntOverlaySlot slot) sync* {
    for (final ov in _registeredOverlays) {
      final key = _hostsByOverlay[ov]?[slot];
      if (key != null) yield key;
    }
  }
}
```

- [ ] **Step 5：导出 `AntOverlayManager`**

Edit `lib/ant_design_flutter.dart`，追加：

```dart
export 'src/primitives/overlay/ant_overlay_manager.dart' show AntOverlayManager;
```

> `AntOverlayHost` 和 `AntOverlayHostState` 保持**不导出**。

- [ ] **Step 6：运行测试确认通过**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_manager_test.dart`
Expected: 3 条测试通过。

- [ ] **Step 7：analyze + 全量测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全绿。

- [ ] **Step 8：提交**

```bash
git add lib/src/primitives/overlay/ant_overlay_host.dart \
        lib/src/primitives/overlay/ant_overlay_manager.dart \
        lib/ant_design_flutter.dart \
        test/widget/primitives/overlay/ant_overlay_manager_test.dart
git commit -m "feat(overlay): implement AntOverlayManager with per-slot host widget"
```

---

## Task 12：AntOverlayHost — message / notification 布局 + 堆叠断言

**目的：** 把 Task 11 的 `Stack` 占位替换成 per-slot 布局：
- `message`：顶部居中，`Column(mainAxisSize: min)`，8 px 间距
- `notification`：右上角，同上
- `modal`/`drawer`：Task 13 才实现，本 Task 先画成占位

**Files:**
- Modify: `lib/src/primitives/overlay/ant_overlay_host.dart`
- Create: `test/widget/primitives/overlay/ant_overlay_stacking_test.dart`

- [ ] **Step 1：写失败测试 — 堆叠 / 位置**

写入 `test/widget/primitives/overlay/ant_overlay_stacking_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Overlay(
          initialEntries: [OverlayEntry(builder: (_) => child)],
        ),
      ),
    );

void main() {
  group('AntOverlayHost — message slot', () {
    testWidgets('stacks messages vertically near top, centered',
        (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(_host(
        child: Builder(builder: (c) {
          ctx = c;
          return const SizedBox.shrink();
        }),
      ));

      for (final key in const [
        ValueKey('msg-a'),
        ValueKey('msg-b'),
        ValueKey('msg-c'),
      ]) {
        AntOverlayManager.show(
          context: ctx,
          slot: AntOverlaySlot.message,
          builder: (_) =>
              SizedBox(key: key, width: 100, height: 32),
        );
      }
      await tester.pump();

      final a = tester.getRect(find.byKey(const ValueKey('msg-a')));
      final b = tester.getRect(find.byKey(const ValueKey('msg-b')));
      final c = tester.getRect(find.byKey(const ValueKey('msg-c')));

      // FIFO 垂直堆叠：a 在最上，b、c 依次向下
      expect(a.top, lessThan(b.top));
      expect(b.top, lessThan(c.top));
      // 8 px 间距
      expect(b.top - a.bottom, closeTo(8, 0.5));
      expect(c.top - b.bottom, closeTo(8, 0.5));
      // 都水平居中在 400 附近（screen.width / 2）
      for (final rect in [a, b, c]) {
        expect(rect.center.dx, closeTo(400, 0.5));
      }
    });
  });

  group('AntOverlayHost — notification slot', () {
    testWidgets('stacks near top-right with 24 px margin', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(_host(
        child: Builder(builder: (c) {
          ctx = c;
          return const SizedBox.shrink();
        }),
      ));

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.notification,
        builder: (_) => const SizedBox(
            key: ValueKey('notif-a'), width: 200, height: 60),
      );
      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.notification,
        builder: (_) => const SizedBox(
            key: ValueKey('notif-b'), width: 200, height: 60),
      );
      await tester.pump();

      final a = tester.getRect(find.byKey(const ValueKey('notif-a')));
      final b = tester.getRect(find.byKey(const ValueKey('notif-b')));

      expect(a.right, closeTo(800 - 24, 0.5)); // 右边距 24
      expect(b.right, closeTo(800 - 24, 0.5));
      expect(a.top, lessThan(b.top));
      expect(b.top - a.bottom, closeTo(8, 0.5));
    });
  });
}
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_stacking_test.dart`
Expected: 失败（当前 host build 是 `Stack`，未按 slot 分开布局）。

- [ ] **Step 3：按 slot 切换布局**

Edit `lib/src/primitives/overlay/ant_overlay_host.dart`，把 `AntOverlayHostState.build` 替换为：

```dart
  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) return const SizedBox.shrink();
    final children = <Widget>[
      for (final e in _entries)
        KeyedSubtree(
          key: ValueKey('ant-overlay-${widget.slot.name}-${e.id}'),
          child: e.builder(context),
        ),
    ];

    switch (widget.slot) {
      case AntOverlaySlot.message:
        return Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _verticalStack(children),
              ),
            ),
          ),
        );
      case AntOverlaySlot.notification:
        return Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, right: 24),
                child: _verticalStack(children),
              ),
            ),
          ),
        );
      case AntOverlaySlot.modal:
      case AntOverlaySlot.drawer:
        // Task 13 才实现；暂时退回到普通叠放，不影响已有测试
        return Positioned.fill(
          child: Stack(alignment: Alignment.center, children: children),
        );
    }
  }

  Widget _verticalStack(List<Widget> children) {
    final interleaved = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) interleaved.add(const SizedBox(height: 8));
      interleaved.add(children[i]);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: interleaved);
  }
```

- [ ] **Step 4：运行 stacking 测试确认通过**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_stacking_test.dart`
Expected: 2 条测试通过。

- [ ] **Step 5：analyze + 全量测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全绿。

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/overlay/ant_overlay_host.dart \
        test/widget/primitives/overlay/ant_overlay_stacking_test.dart
git commit -m "feat(overlay): layout message and notification slots with vertical stack"
```

---

## Task 13：AntOverlayHost — modal / drawer 单例 + barrier

**目的：** modal 布局（全屏 barrier + 居中内容）、drawer 布局（全屏 barrier + 右侧贴边），并验证"再次 show 自动 dismiss 前一条"的单例语义（已在 Task 11 `addEntry` 里实现，本 Task 补测试）。

**Files:**
- Modify: `lib/src/primitives/overlay/ant_overlay_host.dart`
- Modify: `test/widget/primitives/overlay/ant_overlay_stacking_test.dart`

- [ ] **Step 1：追加失败测试 — modal 单例 + drawer 位置**

Edit `test/widget/primitives/overlay/ant_overlay_stacking_test.dart`，在 `main()` 末尾追加：

```dart
  group('AntOverlayHost — modal slot', () {
    testWidgets('show replaces previous modal (singleton)', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(_host(
        child: Builder(builder: (c) {
          ctx = c;
          return const SizedBox.shrink();
        }),
      ));

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
            key: ValueKey('modal-a'), width: 200, height: 120),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('modal-a')), findsOneWidget);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
            key: ValueKey('modal-b'), width: 200, height: 120),
      );
      await tester.pump();
      expect(find.byKey(const ValueKey('modal-a')), findsNothing);
      expect(find.byKey(const ValueKey('modal-b')), findsOneWidget);
    });

    testWidgets('modal content is centered', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(_host(
        child: Builder(builder: (c) {
          ctx = c;
          return const SizedBox.shrink();
        }),
      ));

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
            key: ValueKey('m'), width: 200, height: 100),
      );
      await tester.pump();
      final rect = tester.getRect(find.byKey(const ValueKey('m')));
      expect(rect.center.dx, closeTo(400, 0.5));
      expect(rect.center.dy, closeTo(300, 0.5));
    });
  });

  group('AntOverlayHost — drawer slot', () {
    testWidgets('drawer sits on the right edge', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(_host(
        child: Builder(builder: (c) {
          ctx = c;
          return const SizedBox.shrink();
        }),
      ));

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.drawer,
        builder: (_) => const SizedBox(
            key: ValueKey('d'), width: 240, height: 600),
      );
      await tester.pump();
      final rect = tester.getRect(find.byKey(const ValueKey('d')));
      expect(rect.right, closeTo(800, 0.5));
      expect(rect.top, closeTo(0, 0.5));
      expect(rect.bottom, closeTo(600, 0.5));
    });
  });
```

- [ ] **Step 2：运行测试确认失败**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_stacking_test.dart`
Expected: 3 个新测试失败（当前 modal/drawer 还是 Stack 居中占位）。

- [ ] **Step 3：替换 modal / drawer case 为真实布局**

Edit `lib/src/primitives/overlay/ant_overlay_host.dart`，把 `build` 方法 switch 里的 modal / drawer 分支替换为：

```dart
      case AntOverlaySlot.modal:
        return Positioned.fill(
          child: Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Color(0x80000000)),
              ),
              Positioned.fill(
                child: Center(child: children.last),
              ),
            ],
          ),
        );
      case AntOverlaySlot.drawer:
        return Positioned.fill(
          child: Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Color(0x80000000)),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: children.last,
                ),
              ),
            ],
          ),
        );
```

> 说明：单例语义下 `children` 永远只有 1 条；`children.last` 与 `children.single` 等价，这里用 `last` 容忍未来扩展。

- [ ] **Step 4：运行测试确认通过**

Run: `flutter test test/widget/primitives/overlay/ant_overlay_stacking_test.dart`
Expected: 5 条测试全通（2 旧 + 3 新）。

- [ ] **Step 5：analyze + 全量测试**

Run: `flutter analyze --fatal-infos && flutter test`
Expected: 全绿。

- [ ] **Step 6：提交**

```bash
git add lib/src/primitives/overlay/ant_overlay_host.dart \
        test/widget/primitives/overlay/ant_overlay_stacking_test.dart
git commit -m "feat(overlay): layout modal and drawer slots with barrier"
```

---

## Task 14：CHANGELOG + PROGRESS + 最终校验

**目的：** 更新交付文档，跑一遍端到端检查，标记 Phase 2 完成。

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `doc/PROGRESS.md`

- [ ] **Step 1：CHANGELOG 新增 2.0.0-dev.3 条目**

Edit `CHANGELOG.md`，在文件**最上方**追加（保留所有旧条目）：

```markdown
## 2.0.0-dev.3

Phase 2 delivery: Primitives (Interaction / Portal / Overlay).

### Added
- `AntInteractionDetector`: unifies hover / focus / pressed / disabled into `Set<WidgetState>`, exposes `onTap` / `onHover`, supports Enter/Space keyboard activation and disabled-aware cursor.
- `AntPlacement` enum covering 12 placements with anchor table aligned to AntD v5 `Tooltip`.
- `AntPortal`: anchored overlay primitive backed by `CompositedTransformTarget/Follower`, with once-per-mount edge-flip driven by `autoAdjustOverflow`.
- `AntOverlaySlot` + `OverlayEntryHandle` + `AntOverlayManager`: per-(Overlay × slot) host model. `message` / `notification` are list slots with FIFO vertical stacking; `modal` / `drawer` are singletons with a shared translucent barrier.

### Constraints
- Primitives do **not** consume `AntTheme`. Visuals (colors, shadows, animations, arrows, dismiss triggers) are the responsibility of Phase 3+ components. See spec § 1 "Primitives 与 Token 的关系".
- Overlay slots currently ship without entry / exit animations; animations are component-layer responsibility.
- `AntPortal.onDismiss` is a reserved hook — no built-in tap-outside / ESC / scroll-away handling.

### Reference
- Spec: `docs/superpowers/specs/2026-04-18-phase-2-primitives-design.md`
- Plan: `docs/superpowers/plans/2026-04-18-phase-2-primitives.md`

---

## 2.0.0-dev.2
```

- [ ] **Step 2：PROGRESS 更新 Phase 2 状态与 session note**

Edit `doc/PROGRESS.md`：

**2a.** 把 Phase 2 行的 `—` / `not started` 改为：

```markdown
| 2 | Primitives (Interaction / Portal / Overlay) | [plans/2026-04-18-phase-2-primitives.md](../docs/superpowers/plans/2026-04-18-phase-2-primitives.md) | complete |
```

**2b.** 把 "Last updated" 行改为今天日期，例如：

```markdown
**Last updated:** 2026-04-XX (Phase 2 delivery)
```

（`XX` 替换为实际交付日）

**2c.** 在 "Current session notes" 追加一行：

```markdown
- 2026-04-XX: Phase 2 complete. Interaction / Portal / Overlay primitives landed with 30+ widget tests. Primitives deliberately do not consume AntTheme. Next: write Phase 3 plan for Round 1+2 atomic components (Icon / Typography / Button / Input / Checkbox / Radio / Switch / Tag).
```

- [ ] **Step 3：最终端到端校验**

按顺序跑：

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
```

预期：

```
Got dependencies!
(no format output)
No issues found!
All tests passed!
```

若 `dart format` 报改动，先 `dart format .`，再 `git add -A` 把格式调整并入本 Task 的 commit。

若 analyzer 或 test 失败 —— **不要**在这一 Task 打补丁修主代码，返回相应的 Task（2-13）修完再回来。

- [ ] **Step 4：提交并查看 git log**

```bash
git add CHANGELOG.md doc/PROGRESS.md
git commit -m "docs: mark Phase 2 complete with 2.0.0-dev.3 changelog entry"
git log --oneline v1-legacy..HEAD | head -30
```

Expected：前 13-14 条 commit 是 Phase 2 的 task 提交 + 这条收尾 commit。

- [ ] **Step 5：决定是否 tag / push**

> 仅用户决定：
> - 打 dev tag：`git tag -a v2.0.0-dev.3 -m "Phase 2: Primitives"`
> - 推送：`git push origin main` / `git push origin v2.0.0-dev.3`
>
> 本 plan 不替用户执行。

---

## Phase 2 完成定义（DoD）

全部满足才算 Phase 2 完成：

- [x] `lib/src/primitives/interaction/ant_interaction_detector.dart` 实现 + 13 个 widget test
- [x] `lib/src/primitives/portal/ant_placement.dart` 12 方位 enum + 25 条 unit test
- [x] `lib/src/primitives/portal/ant_portal.dart` 实现 + 7 条 widget test（3 lifecycle + 4 geometry）
- [x] `lib/src/primitives/portal/` 翻转逻辑 + 4 条 adjust widget test
- [x] `lib/src/primitives/overlay/{ant_overlay_slot,overlay_entry_handle}.dart`
- [x] `lib/src/primitives/overlay/ant_overlay_host.dart`（internal）
- [x] `lib/src/primitives/overlay/ant_overlay_manager.dart`（门面）+ 3 条 manager 测试 + 5 条 stacking 测试
- [x] `lib/ant_design_flutter.dart` 新增 6 个导出：`AntInteractionDetector`、`AntInteractionBuilder`、`AntPlacement`、`AntPortal`、`AntOverlaySlot`、`OverlayEntryHandle`、`AntOverlayManager`
- [x] `lib/src/primitives/` 内任何文件不 import `theme/` / `app/`
- [x] `flutter analyze --fatal-infos` 通过
- [x] `flutter test` 全部通过；覆盖率符合 spec § 6.2
- [x] 每个公开类 / 字段有 dartdoc
- [x] `doc/PROGRESS.md` Phase 2 行标记 complete
- [x] `CHANGELOG.md` 新增 `2.0.0-dev.3` 条目

满足后 Phase 2 结束。**下一步：** 回到 brainstorming / writing-plans 为 Phase 3（Round 1+2 原子组件）做计划。Phase 3 里 Button 是第一个真正消费 `AntInteractionDetector` + `AntTheme` 的组件，可作 Primitives 可用性的第一次真实检验。

