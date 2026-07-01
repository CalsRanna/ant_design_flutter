import 'package:flutter/widgets.dart';

/// 间距。对齐 AntD v5 `Space`。
class AntSpace extends StatelessWidget {
  const AntSpace({
    required this.children,
    super.key,
    this.size = 8,
    this.direction = Axis.horizontal,
    this.wrap = false,
  });

  final List<Widget> children;
  final double size;
  final Axis direction;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final interleaved = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        interleaved.add(SizedBox(
          width: direction == Axis.horizontal ? size : 0,
          height: direction == Axis.vertical ? size : 0,
        ));
      }
      interleaved.add(children[i]);
    }

    if (direction == Axis.horizontal) {
      return Wrap(
        runSpacing: wrap ? size : 0,
        spacing: wrap ? size : 0,
        children: wrap ? children : interleaved,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: interleaved,
    );
  }
}
