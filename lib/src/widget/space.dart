import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:flutter/widgets.dart';

class Space extends StatelessWidget {
  const Space({
    Key? key,
    required this.children,
    this.align,
    this.direction = Axis.horizontal,
    this.size = Size.small,
    this.split,
    this.wrap = false,
  }) : super(key: key);

  final List<Widget> children;
  final SpaceAlign? align;
  final Axis direction;
  final Size size;
  final Widget? split;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      crossAxisAlignment: Axis.horizontal == direction
          ? WrapCrossAlignment.center
          : WrapCrossAlignment.start,
      runSpacing: _calculateSpacing(),
      spacing: _calculateSpacing(),
      children: children,
    );
  }

  double _calculateSpacing() {
    var spacing = 8.0;
    if (Size.middle == size) {
      spacing = 16.0;
    } else if (Size.large == size) {
      spacing = 24.0;
    }
    return spacing;
  }
}

enum SpaceAlign { start, end, center, baseline }
