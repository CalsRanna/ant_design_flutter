import 'package:flutter/widgets.dart';

class Space extends StatelessWidget {
  const Space({
    Key? key,
    required this.children,
    this.align,
    this.direction = Axis.horizontal,
    this.size = SpaceSize.small,
    this.split,
    this.wrap = false,
  }) : super(key: key);

  final List<Widget> children;
  final SpaceAlign? align;
  final Axis direction;
  final double size;
  final Widget? split;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      spacing: size,
      children: children,
    );
  }
}

class SpaceSize {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}

enum SpaceAlign { start, end, center, baseline }
