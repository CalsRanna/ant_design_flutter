import 'package:ant_design_flutter/antdf.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Material;

class Tooltip extends StatefulWidget {
  const Tooltip({
    Key? key,
    required this.child,
    this.placement = Placement.top,
    required this.label,
    this.trigger = Trigger.hover,
  }) : super(key: key);

  final Widget child;
  final Placement placement;
  final String label;
  final Trigger trigger;

  @override
  State<Tooltip> createState() => _TooltipState();
}

class _TooltipState extends State<Tooltip> {
  bool hovered = false;
  bool inserted = false;
  LayerLink link = LayerLink();
  late OverlayEntry entry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: CompositedTransformTarget(child: widget.child, link: link),
      onEnter: _handleEnter,
      onExit: _handleExit,
    );
  }

  void updateOverlayEntry() {
    entry.remove();
    var size = context.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          child: Material(
            child: _TooltipOverlayEntry(label: widget.label),
            elevation: 4,
          ),
          followerAnchor: Alignment.bottomCenter,
          link: link,
          offset: Offset(0, -1 * size!.height),
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
        ),
        height: 38,
      ),
    );
    Overlay.of(context)!.insert(entry);
  }

  void _handleEnter(PointerEnterEvent event) {
    var size = context.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          child: Material(
            child: _TooltipOverlayEntry(label: widget.label),
            elevation: 4,
          ),
          followerAnchor: Alignment.bottomCenter,
          link: link,
          offset: Offset(0, -1 * size!.height),
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
        ),
        height: 38,
      ),
    );
    Overlay.of(context)!.insert(entry);
  }

  void _handleExit(PointerExitEvent event) {
    entry.remove();
  }
}

class _AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class _TooltipOverlayEntry extends StatelessWidget {
  const _TooltipOverlayEntry({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.gray_10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    );
  }
}
