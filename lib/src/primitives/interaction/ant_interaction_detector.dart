import 'package:flutter/gestures.dart'
    show PointerEnterEvent, PointerExitEvent;
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
    required this.builder,
    super.key,
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
}
