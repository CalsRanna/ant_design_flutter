import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Checkbox 视觉派生结果（pure data）。
@immutable
class CheckboxStyle {
  const CheckboxStyle({
    required this.borderColor,
    required this.fillColor,
    required this.tickColor,
  });

  /// 根据 [checked] / [hovered] / [disabled] 派生 border / fill / tick 色。
  factory CheckboxStyle.resolve({
    required AntAliasToken alias,
    required bool checked,
    required bool hovered,
    required bool disabled,
  }) {
    if (disabled) {
      return CheckboxStyle(
        borderColor: alias.colorBorder,
        fillColor: alias.colorFillSecondary,
        tickColor: checked ? alias.colorTextDisabled : null,
      );
    }
    if (!checked) {
      return CheckboxStyle(
        borderColor: hovered ? alias.colorPrimary : alias.colorBorder,
        fillColor: const Color(0xFFFFFFFF),
        tickColor: null,
      );
    }
    final primary = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    return CheckboxStyle(
      borderColor: primary,
      fillColor: primary,
      tickColor: const Color(0xFFFFFFFF),
    );
  }

  final Color borderColor;
  final Color fillColor;

  /// null 表示不画钩 / 点（unchecked 状态）。
  final Color? tickColor;
}
