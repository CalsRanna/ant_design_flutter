import 'dart:math';

import 'package:ant_design_flutter/src/enum/placement.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';

class Slider extends StatefulWidget {
  const Slider({
    Key? key,
    this.allowClear = false,
    this.controller,
    this.disabled = false,
    this.dots = false,
    this.draggableTrack = false,
    this.included = true,
    this.marks,
    this.max = 100,
    this.min = 0,
    this.range = false,
    this.reverse = false,
    this.step = 1,
    this.tipFormatter,
    this.tooltipPlacement,
    this.tooltipVisible,
    this.vertical = false,
    this.onAfterChange,
    this.onChange,
  }) : super(key: key);

  final bool allowClear;
  final SliderController? controller;
  final bool disabled;
  final bool dots;
  final bool draggableTrack;
  final bool included;
  final List<Widget>? marks;
  final double max;
  final double min;
  final bool range;
  final bool reverse;
  final double step;
  final Widget Function(double value)? tipFormatter;
  final Placement? tooltipPlacement;
  final bool? tooltipVisible;
  final bool vertical;
  final void Function(double value)? onAfterChange;
  final void Function(double value)? onChange;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  double value = 0;
  bool hovered = false;
  bool pressed = false;

  LayerLink link = LayerLink();
  late OverlayEntry entry;

  @override
  void initState() {
    super.initState();
    setState(() {
      value = widget.controller?.value ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      final double width = constraints.maxWidth - 14;

      Widget activedTrack = GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(2),
              topLeft: Radius.circular(2),
            ),
            color: Colors.blue_5,
          ),
          height: 4,
          width: width / widget.max * value,
        ),
        onTapDown: (TapDownDetails details) =>
            _handleTapDown(details, width, negative: true),
      );

      Widget draggableCircle = Listener(
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerUp,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue_6,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            height: 14,
            width: 14,
          ),
          onHorizontalDragUpdate: (DragUpdateDetails details) =>
              _handleDragUpdate(details, width),
        ),
      );

      Widget unactivedTrack = Expanded(
        child: GestureDetector(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              color: Colors.gray_4,
            ),
            height: 4,
          ),
          onTapDown: (TapDownDetails details) => _handleTapDown(details, width),
        ),
      );

      return MouseRegion(
        cursor: hovered ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: _handleEnter,
        onExit: _handleExit,
        child: Row(
          children: [
            activedTrack,
            CompositedTransformTarget(link: link, child: draggableCircle),
            unactivedTrack
          ],
        ),
      );
    });
  }

  void _handleTapDown(
    TapDownDetails details,
    double width, {
    bool negative = false,
  }) {
    double newValue = details.localPosition.dx / width * widget.max;
    if (!negative) {
      newValue = newValue + value;
    }

    widget.controller?.value = newValue.roundToDouble();

    setState(() {
      value = newValue;
    });
    entry.markNeedsBuild();
  }

  void _handleDragUpdate(DragUpdateDetails details, double width) {
    double newValue = value + details.delta.dx / width * widget.max;
    if (newValue < widget.min) {
      newValue = widget.min;
    } else if (newValue > widget.max) {
      newValue = widget.max;
    }

    widget.controller?.value = newValue.roundToDouble();

    setState(() {
      value = newValue;
    });
    entry.markNeedsBuild();
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      pressed = true;
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      pressed = false;
    });
  }

  void _handleEnter(PointerEnterEvent event) {
    setState(() {
      hovered = true;
    });
    entry = _buildOverlayEntry();
    Overlay.of(context).insert(entry);
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      hovered = false;
    });
    if (!pressed) {
      entry.remove();
    }
  }

  OverlayEntry _buildOverlayEntry() {
    var offset = Offset(0, -1 * context.size!.height);
    return OverlayEntry(
      builder: (context) => Positioned(
        height: 38,
        child: CompositedTransformFollower(
          followerAnchor: Alignment.bottomCenter,
          link: link,
          offset: offset,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topCenter,
          child: _SliderOverlayEntry(label: value.roundToDouble().toString()),
        ),
      ),
    );
  }
}

class SliderController extends ChangeNotifier {
  double value = 0;
}

class _SliderOverlayEntry extends StatelessWidget {
  const _SliderOverlayEntry({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
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
      ),
    );
  }
}
