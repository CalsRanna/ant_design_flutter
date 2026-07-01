import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 布局。对齐 AntD v5 `Layout`。
class AntLayout extends StatelessWidget {
  const AntLayout({required this.child, super.key, this.hasSider = false});
  final Widget child; final bool hasSider;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(color: alias.colorBackgroundLayout, child: child);
  }
}

class AntHeader extends StatelessWidget {
  const AntHeader({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      height: 64, padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(color: alias.colorBackgroundContainer, border: Border(bottom: BorderSide(color: alias.colorSplit))),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}

class AntSider extends StatelessWidget {
  const AntSider({required this.child, super.key, this.width = 200});
  final Widget child; final double width;
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(width: width, color: alias.colorBackgroundContainer,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Padding(padding: const EdgeInsets.all(16), child: child)]),
    );
  }
}

class AntContent extends StatelessWidget {
  const AntContent({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: child);
}

class AntFooter extends StatelessWidget {
  const AntFooter({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: alias.colorSplit))),
      child: Center(child: DefaultTextStyle(style: TextStyle(color: alias.colorTextTertiary, fontSize: alias.fontSize), child: child)),
    );
  }
}
