import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 悬浮按钮。对齐 AntD v5 `FloatButton`。
class AntFloatButton extends StatelessWidget {
  const AntFloatButton({
    required this.icon,
    required this.onTap,
    super.key,
    this.tooltip,
    this.shape = AntFloatShape.circle,
  });

  final Widget icon;
  final VoidCallback onTap;
  final String? tooltip;
  final AntFloatShape shape;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final child = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: alias.colorPrimary,
        shape: shape == AntFloatShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == AntFloatShape.square ? BorderRadius.circular(8) : null,
        boxShadow: [BoxShadow(color: const Color(0x26000000), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Center(child: IconTheme(data: const IconThemeData(color: Color(0xFFFFFFFF), size: 18), child: icon)),
    );

    final button = GestureDetector(onTap: onTap, child: child);

    if (tooltip != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tooltip!, style: TextStyle(color: alias.colorTextTertiary, fontSize: 12)),
          const SizedBox(height: 4),
          button,
        ],
      );
    }
    return button;
  }
}

enum AntFloatShape { circle, square }
