import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
    this.child,
    this.children,
    this.dashed = false,
    this.orientation = DividerOrientation.center,
    this.orientationMargin,
    this.plain = false,
    this.type = Axis.horizontal,
  }) : super(key: key);

  final Widget? child;
  final Widget? children;
  final bool dashed;
  final DividerOrientation orientation;
  final double? orientationMargin;
  final bool plain;
  final Axis type;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.gray_4),
            ),
          ),
          width: 24,
        ),
        child == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DefaultTextStyle.merge(
                  child: child!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.gray_4),
              ),
            ),
          ),
        )
      ],
    );
  }
}

enum DividerOrientation { left, right, center }
