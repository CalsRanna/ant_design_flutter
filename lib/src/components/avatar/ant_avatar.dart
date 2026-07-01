import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 头像。对齐 AntD v5 `Avatar`。
class AntAvatar extends StatelessWidget {
  const AntAvatar({
    super.key,
    this.child,
    this.text,
    this.size = 32,
    this.shape = AntAvatarShape.circle,
    this.color,
    this.backgroundColor,
  });

  final Widget? child;
  final String? text;
  final double size;
  final AntAvatarShape shape;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final bg = backgroundColor ?? alias.colorPrimaryBackground;
    final fg = color ?? alias.colorPrimary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: shape == AntAvatarShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == AntAvatarShape.square
            ? BorderRadius.circular(size * 0.2)
            : null,
      ),
      child: Center(
        child: child ??
            (text != null
                ? Text(
                    text!.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: fg,
                      fontSize: size * 0.45,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null),
      ),
    );
  }
}

enum AntAvatarShape { circle, square }
