import 'package:flutter/widgets.dart';

/// 固钉。对齐 AntD v5 `Affix`。
class AntAffix extends StatelessWidget {
  const AntAffix({required this.child, super.key, this.offsetTop = 0});
  final Widget child; final double offsetTop;

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.only(top: offsetTop), child: child);
}
