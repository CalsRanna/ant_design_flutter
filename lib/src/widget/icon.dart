import 'dart:math';

import 'package:flutter/widgets.dart' as widgets;

class Icon extends widgets.StatefulWidget {
  const Icon(
    this.icon, {
    widgets.Key? key,
    this.color,
    this.rotate,
    this.size,
    this.spin = false,
  }) : super(key: key);

  final widgets.Color? color;
  final widgets.IconData icon;
  final double? rotate;
  final double? size;
  final bool spin;

  @override
  widgets.State<Icon> createState() => _IconState();
}

class _IconState extends widgets.State<Icon>
    with widgets.SingleTickerProviderStateMixin {
  late widgets.AnimationController animatedController;

  @override
  void initState() {
    super.initState();
    animatedController = widgets.AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    animatedController.dispose();
    super.dispose();
  }

  @override
  widgets.Widget build(widgets.BuildContext context) {
    var icon = widgets.Icon(
      widget.icon,
      color: widget.color,
      size: widget.size,
    );

    var rotate = widget.rotate != null ? widget.rotate! * pi / 180 : 0.0;
    var rotateIcon = widgets.Transform.rotate(angle: rotate, child: icon);

    return widget.spin
        ? widgets.RotationTransition(
            turns: animatedController,
            child: widget.rotate != null ? rotateIcon : icon,
          )
        : widget.rotate != null
            ? rotateIcon
            : icon;
  }
}
