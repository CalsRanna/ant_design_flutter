import 'package:flutter/widgets.dart';

class AntRow extends StatelessWidget {
  const AntRow({
    Key? key,
    required this.children,
    this.align = AntRowAlign.top,
    this.gutter,
    this.justify = AntRowJustify.start,
    this.wrap = true,
  }) : super(key: key);

  final List<Widget> children;
  final AntRowAlign align;
  final AntRowGutter? gutter;
  final AntRowJustify justify;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AntRowGutter {
  AntRowGutter({
    this.gutter,
    this.xs,
    this.sm,
    this.md,
    this.horizontal,
    this.vertical,
  });

  double? gutter;
  double? xs;
  double? sm;
  double? md;
  double? horizontal;
  double? vertical;
}

enum AntRowAlign { top, middle, bottom }
enum AntRowJustify { start, end, center, spaceAround, spaceBetween }

class AntColumn extends StatelessWidget {
  const AntColumn({
    Key? key,
    this.child,
    this.flex,
    this.offset = 0,
    this.order = 0,
    this.pull = 0,
    this.push = 0,
    required this.span,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  }) : super(key: key);

  final Widget? child;
  final int? flex;
  final int offset;
  final int order;
  final int pull;
  final int push;
  final int span;
  final AntColumnResponsiveOption? xs;
  final AntColumnResponsiveOption? sm;
  final AntColumnResponsiveOption? md;
  final AntColumnResponsiveOption? lg;
  final AntColumnResponsiveOption? xl;
  final AntColumnResponsiveOption? xxl;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AntColumnResponsiveOption {
  AntColumnResponsiveOption({
    this.flex,
    this.offset = 0,
    this.order = 0,
    this.pull = 0,
    this.push = 0,
    required this.span,
  });

  int? flex;
  int offset;
  int order;
  int pull;
  int push;
  int span;
}
