import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Radio extends StatefulWidget {
  const Radio({Key? key, this.child, this.controller, this.disabled = false})
      : super(key: key);

  final Widget? child;
  final RadioController? controller;
  final bool disabled;

  @override
  State<Radio> createState() => _RadioState();
}

class _RadioState extends State<Radio> {
  bool checked = false;
  bool hovered = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      checked = widget.controller?.value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.disabled ? Colors.gray_6 : Colors.gray_5,
        ),
        shape: BoxShape.circle,
      ),
      height: 16,
      width: 16,
    );

    Widget dot = checked
        ? Container(
            decoration: BoxDecoration(
              color: widget.disabled ? Colors.gray_6 : Colors.blue_6,
              shape: BoxShape.circle,
            ),
            height: 8,
            width: 8,
          )
        : const SizedBox();

    Widget text = widget.child != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: widget.child,
          )
        : const SizedBox();

    TextStyle style = TextStyle(color: widget.disabled ? Colors.gray_6 : null);

    MouseCursor cursor = widget.disabled
        ? SystemMouseCursors.forbidden
        : SystemMouseCursors.click;

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: _handleTap,
        child: DefaultTextStyle.merge(
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [circle, dot],
              ),
              text,
            ],
          ),
          style: style,
        ),
      ),
    );
  }

  void _handleTap() {
    if (!widget.disabled) {
      setState(() {
        checked = true;
      });
    }
  }
}

class RadioController extends ChangeNotifier {
  bool value = false;
}
