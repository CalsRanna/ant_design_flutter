import 'dart:math';

import 'package:ant_design_flutter/src/enum/placement.dart';
import 'package:ant_design_flutter/src/enum/trigger.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';

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
      onEnter: _handleEnter,
      onExit: _handleExit,
      child: CompositedTransformTarget(link: link, child: widget.child),
    );
  }

  void updateOverlayEntry() {
    entry.remove();
    var size = context.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        height: 38,
        child: CompositedTransformFollower(
          followerAnchor: Alignment.bottomCenter,
          link: link,
          offset: Offset(0, -1 * size!.height),
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          child: Material(
            elevation: 4,
            child: _TooltipOverlayEntry(label: widget.label),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(entry);
  }

  void _handleEnter(PointerEnterEvent event) {
    var size = context.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        height: 38,
        child: CompositedTransformFollower(
          followerAnchor: Alignment.bottomCenter,
          link: link,
          offset: Offset(0, -1 * size!.height),
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          child: Material(
            elevation: 4,
            child: _TooltipOverlayEntry(label: widget.label),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(entry);
  }

  void _handleExit(PointerExitEvent event) {
    entry.remove();
  }
}

class _TooltipOverlayEntry extends StatelessWidget {
  const _TooltipOverlayEntry({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -4,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(2),
                ),
                color: Colors.gray_10,
              ),
              height: 8,
              width: 8,
            ),
          ),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.gray_10,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
