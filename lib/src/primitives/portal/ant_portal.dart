import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding, SchedulerPhase;
import 'package:flutter/widgets.dart';

/// 基于 `CompositedTransformTarget/Follower` 的锚点弹层原语。
/// Phase 2 spec § 4。视觉（配色 / 阴影 / 箭头 / 动画）由 consumer 负责，
/// 本组件只负责几何定位与生命周期。
///
/// 内部使用 Flutter 3.10+ 的 `OverlayPortal` 承载 overlay 生命周期：
/// 避免手工 `Overlay.insert` 在 build phase 触发 `setState during build`
/// 的问题，同时保留 `CompositedTransformFollower` 的锚点语义。
class AntPortal extends StatefulWidget {
  const AntPortal({
    required this.child,
    required this.overlayBuilder,
    super.key,
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
  final OverlayPortalController _controller = OverlayPortalController();
  final GlobalKey _followerKey = GlobalKey();

  /// 翻转后的有效 placement；null 表示尚未计算，使用 widget.placement。
  AntPlacement? _effectivePlacement;

  /// 本次挂载是否已评估过翻转（locked once per mount）。
  bool _adjusted = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) _scheduleShow();
  }

  @override
  void didUpdateWidget(covariant AntPortal old) {
    super.didUpdateWidget(old);
    if (old.visible != widget.visible) {
      if (widget.visible) {
        _scheduleShow();
      } else {
        _scheduleHide();
      }
    } else if (old.placement != widget.placement ||
        old.autoAdjustOverflow != widget.autoAdjustOverflow) {
      // placement 改变：重置翻转状态，重新评估
      _effectivePlacement = null;
      _adjusted = false;
      if (widget.visible) _scheduleAdjust();
    }
  }

  bool get _inBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks;
  }

  void _scheduleShow() {
    // 每次显示重置翻转锁与结果，让 _maybeFlip 基于本次新的 target 位置重判。
    _effectivePlacement = null;
    _adjusted = false;
    if (_inBuildPhase) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !widget.visible) return;
        _controller.show();
        _scheduleAdjust();
      });
    } else {
      _controller.show();
      _scheduleAdjust();
    }
  }

  void _scheduleHide() {
    if (_inBuildPhase) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && !widget.visible) _controller.hide();
      });
    } else {
      _controller.hide();
    }
  }

  void _scheduleAdjust() {
    if (!widget.autoAdjustOverflow) return;
    if (_adjusted) return;
    _adjusted = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeFlip();
    });
  }

  void _maybeFlip() {
    final ctx = _followerKey.currentContext;
    if (ctx == null) return;
    final renderObj = ctx.findRenderObject();
    if (renderObj is! RenderBox || !renderObj.hasSize) return;
    final origin = renderObj.localToGlobal(Offset.zero);
    final size = renderObj.size;
    final screen = MediaQuery.of(context).size;

    final overflowsTop = origin.dy < 0;
    final overflowsBottom = origin.dy + size.height > screen.height;
    final overflowsLeft = origin.dx < 0;
    final overflowsRight = origin.dx + size.width > screen.width;

    final current = _effectivePlacement ?? widget.placement;
    var next = current;

    const verticalAxis = <AntPlacement>{
      AntPlacement.top,
      AntPlacement.topLeft,
      AntPlacement.topRight,
      AntPlacement.bottom,
      AntPlacement.bottomLeft,
      AntPlacement.bottomRight,
    };
    if (verticalAxis.contains(current)) {
      final isTopSide =
          current == AntPlacement.top ||
          current == AntPlacement.topLeft ||
          current == AntPlacement.topRight;
      if (isTopSide && overflowsTop && !overflowsBottom) {
        next = flipAntPlacement(current, vertical: true);
      } else if (!isTopSide && overflowsBottom && !overflowsTop) {
        next = flipAntPlacement(current, vertical: true);
      }
    } else {
      final isLeftSide =
          current == AntPlacement.left ||
          current == AntPlacement.leftTop ||
          current == AntPlacement.leftBottom;
      if (isLeftSide && overflowsLeft && !overflowsRight) {
        next = flipAntPlacement(current, vertical: false);
      } else if (!isLeftSide && overflowsRight && !overflowsLeft) {
        next = flipAntPlacement(current, vertical: false);
      }
    }

    if (next != current) {
      setState(() => _effectivePlacement = next);
    }
  }

  Widget _buildOverlay(BuildContext context) {
    final placement = _effectivePlacement ?? widget.placement;
    final anchors = antPlacementAnchors[placement]!;
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: anchors.target,
        followerAnchor: anchors.follower,
        offset: widget.offset,
        child: KeyedSubtree(
          key: _followerKey,
          child: widget.overlayBuilder(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: _buildOverlay,
        child: widget.child,
      ),
    );
  }
}
