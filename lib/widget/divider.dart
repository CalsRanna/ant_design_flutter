import 'package:flutter/widgets.dart';

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
    this.child,
    this.children,
    this.dashed = false,
    this.orientation = DividerOrientation.center,
    this.orientationMargin,
    this.plain = false,
    this.type = Axis.horizontal,
  }) : super(key: key);

  final Widget? child;
  final Widget? children;
  final bool dashed;
  final DividerOrientation orientation;
  final double? orientationMargin;
  final bool plain;
  final Axis type;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum DividerOrientation { left, right, center }
