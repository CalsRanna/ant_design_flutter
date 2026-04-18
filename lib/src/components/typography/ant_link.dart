import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 链接样式文字：唯一一个 `AntTypography` 子类走 `AntInteractionDetector`。
///
/// 视觉：normal=colorPrimary / hover=colorPrimaryHover / disabled=colorTextDisabled；
/// focus 时加下划线（键盘导航可见性）。
class AntLink extends StatelessWidget {
  const AntLink(
    this.text, {
    required this.onPressed,
    super.key,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: onPressed,
      builder: (context, states) {
        final Color color;
        if (states.contains(WidgetState.disabled)) {
          color = alias.colorTextDisabled;
        } else if (states.contains(WidgetState.hovered)) {
          color = alias.colorPrimaryHover;
        } else {
          color = alias.colorPrimary;
        }
        final focused = states.contains(WidgetState.focused);
        return Text(
          text,
          style: TextStyle(
            color: color,
            decoration: focused ? TextDecoration.underline : null,
          ),
        );
      },
    );
  }
}
