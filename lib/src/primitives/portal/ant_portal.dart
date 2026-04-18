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
    }
  }

  bool get _inBuildPhase {
    final phase = SchedulerBinding.instance.schedulerPhase;
    return phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks;
  }

  void _scheduleShow() {
    if (_inBuildPhase) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.visible) _controller.show();
      });
    } else {
      _controller.show();
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

  Widget _buildOverlay(BuildContext context) {
    final anchors = antPlacementAnchors[widget.placement]!;
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: anchors.target,
        followerAnchor: anchors.follower,
        offset: widget.offset,
        child: widget.overlayBuilder(context),
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
