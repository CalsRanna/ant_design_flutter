import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Radio 视觉派生结果。
@immutable
class RadioStyle {
  const RadioStyle({required this.borderColor, required this.innerDotColor});

  /// 根据 [selected] / [hovered] / [disabled] 派生 border / innerDot 色。
  factory RadioStyle.resolve({
    required AntAliasToken alias,
    required bool selected,
    required bool hovered,
    required bool disabled,
  }) {
    if (disabled) {
      return RadioStyle(
        borderColor: alias.colorBorder,
        innerDotColor: selected ? alias.colorTextDisabled : null,
      );
    }
    if (!selected) {
      return RadioStyle(
        borderColor: hovered ? alias.colorPrimary : alias.colorBorder,
        innerDotColor: null,
      );
    }
    final primary = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    return RadioStyle(borderColor: primary, innerDotColor: primary);
  }

  final Color borderColor;

  /// null 表示 unselected（不画内圆点）。
  final Color? innerDotColor;
}
