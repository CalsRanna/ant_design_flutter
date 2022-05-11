import 'package:flutter/widgets.dart';

class Affix extends StatefulWidget {
  const Affix(
      {Key? key,
      required this.child,
      this.offsetBottom,
      this.offsetTop = 0,
      this.target,
      this.onChange})
      : super(key: key);

  final Widget child;
  final double? offsetBottom;
  final double offsetTop;
  final void Function()? target;
  final void Function(bool affixed)? onChange;

  @override
  State<Affix> createState() => _AffixState();
}

class _AffixState extends State<Affix> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
