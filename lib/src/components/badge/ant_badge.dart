import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 徽标。对齐 AntD v5 `Badge`。
class AntBadge extends StatelessWidget {
  const AntBadge({
    required this.child,
    super.key,
    this.count,
    this.color,
    this.overflowCount = 99,
    this.showZero = false,
    this.dot = false,
  });

  final Widget child;
  final int? count;
  final Color? color;
  final int overflowCount;
  final bool showZero;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final badgeColor = color ?? alias.colorError;

    if (!dot && (count == null || (count == 0 && !showZero))) {
      return child;
    }

    final displayText = dot
        ? null
        : (count! > overflowCount ? '$overflowCount+' : '$count');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -4,
          child: dot
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayText!,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
