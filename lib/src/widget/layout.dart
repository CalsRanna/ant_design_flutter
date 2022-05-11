import 'package:ant_design_flutter/src/enum/theme.dart';
import 'package:flutter/widgets.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key, required this.child, this.hasSider})
      : super(key: key);

  final Widget child;
  final bool? hasSider;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Sider extends StatefulWidget {
  const Sider({
    Key? key,
    required this.child,
    this.breakpoint,
    this.collapsed,
    this.collapsedWidth = 80,
    this.collapsible = false,
    this.defaultCollapsed = false,
    this.reverseArrow = false,
    this.theme = Theme.dark,
    this.trigger,
    this.width = 200,
    this.onBreakpoint,
    this.onCollapse,
  }) : super(key: key);

  final Widget child;
  final SiderBreakpoint? breakpoint;
  final bool? collapsed;
  final double collapsedWidth;
  final bool collapsible;
  final bool defaultCollapsed;
  final bool reverseArrow;
  final Theme theme;
  final Widget? trigger;
  final double width;
  final void Function()? onBreakpoint;
  final void Function(bool collapsed)? onCollapse;

  @override
  State<Sider> createState() => _SiderState();
}

class _SiderState extends State<Sider> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SiderBreakpoint {
  SiderBreakpoint({
    this.xs = 480,
    this.sm = 576,
    this.md = 768,
    this.lg = 992,
    this.xl = 1200,
    this.xxl = 1600,
  });

  double xs;
  double sm;
  double md;
  double lg;
  double xl;
  double xxl;
}

class Header extends StatelessWidget {
  const Header({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Content extends StatelessWidget {
  const Content({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
