import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Tag extends StatefulWidget {
  const Tag({
    Key? key,
    required this.child,
    this.closable = false,
    this.closeIcon,
    this.color,
    this.icon,
    this.onClose,
    this.visible = true,
  }) : super(key: key);

  final Widget child;
  final bool closable;
  final Widget? closeIcon;
  final Color? color;
  final Widget? icon;
  final void Function()? onClose;
  final bool visible;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: widget.color ?? Colors.gray_5),
          borderRadius: BorderRadius.circular(2),
          color: widget.color ?? Colors.gray_2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: widget.child,
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}
