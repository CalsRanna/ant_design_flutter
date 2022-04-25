import 'package:ant_design_flutter/enumeration/size.dart';
import 'package:flutter/widgets.dart';

class Space extends StatelessWidget {
  const Space({
    Key? key,
    required this.children,
    this.align,
    this.direction = Axis.horizontal,
    this.size = AntSize.small,
    this.split,
    this.wrap = false,
  }) : super(key: key);

  final List<Widget> children;
  final SpaceAlign? align;
  final Axis direction;
  final AntSize size;
  final Widget? split;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: children,
      direction: direction,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: _calculateSpacing(),
    );
  }

  double _calculateSpacing() {
    var spacing = 8.0;
    if (AntSize.medium == size) {
      spacing = 16.0;
    } else if (AntSize.large == size) {
      spacing = 24.0;
    }
    return spacing;
  }
}

class SpaceSize {
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
}

enum SpaceAlign { start, end, center, baseline }
