import 'package:ant_design_flutter/style/color.dart';
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
    return MouseRegion(
      child: GestureDetector(
        child: DefaultTextStyle.merge(
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.disabled ? Colors.gray_6 : Colors.gray_5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    height: 16,
                    width: 16,
                  ),
                  checked
                      ? Container(
                          decoration: BoxDecoration(
                            color:
                                widget.disabled ? Colors.gray_6 : Colors.blue_6,
                            shape: BoxShape.circle,
                          ),
                          height: 8,
                          width: 8,
                        )
                      : const SizedBox()
                ],
              ),
              widget.child != null
                  ? Padding(
                      child: widget.child,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    )
                  : const SizedBox()
            ],
          ),
          style: TextStyle(color: widget.disabled ? Colors.gray_6 : null),
        ),
        onTap: () {
          if (!widget.disabled) {
            setState(() {
              checked = true;
            });
          }
        },
      ),
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
    );
  }
}

class RadioController extends ChangeNotifier {
  bool value = false;
}