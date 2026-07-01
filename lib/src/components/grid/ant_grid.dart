import 'package:flutter/widgets.dart';

/// 栅格行。对齐 AntD v5 `Row`。
class AntRow extends StatelessWidget {
  const AntRow({required this.children, super.key, this.gap = 0, this.align = MainAxisAlignment.start});
  final List<Widget> children; final double gap; final MainAxisAlignment align;

  @override
  Widget build(BuildContext context) => Wrap(spacing: gap, runSpacing: gap, children: children);
}

/// 栅格列。对齐 AntD v5 `Col`。
class AntCol extends StatelessWidget {
  const AntCol({required this.child, super.key, this.span = 24, this.offset = 0});
  final Widget child; final int span; final int offset;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: span / 24,
      child: offset > 0
          ? Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * offset / 24), child: child)
          : child,
    );
  }
}
