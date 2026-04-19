import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Tag 视觉派生结果。
@immutable
class TagStyle {
  const TagStyle({
    required this.background,
    required this.foreground,
    required this.borderColor,
  });

  /// 普通 Tag：根据 [color] 派生 background / foreground / border。
  ///
  /// `color == null` 时走 alias 的 fillSecondary + colorText 中性配色；
  /// 显式 color 时按 sRGB luminance 自动选对比文字色。
  factory TagStyle.resolveDefault({
    required AntAliasToken alias,
    required Color? color,
  }) {
    if (color == null) {
      return TagStyle(
        background: alias.colorFillSecondary,
        foreground: alias.colorText,
        borderColor: alias.colorBorder,
      );
    }
    final foreground =
        _luminance(color) > 0.5 ? alias.colorText : const Color(0xFFFFFFFF);
    return TagStyle(
      background: color,
      foreground: foreground,
      borderColor: _withAlpha(color, 0.4),
    );
  }

  /// 可选中 Tag：checked 状态切配色。
  factory TagStyle.resolveCheckable({
    required AntAliasToken alias,
    required bool checked,
  }) {
    if (checked) {
      return TagStyle(
        background: alias.colorPrimary,
        foreground: const Color(0xFFFFFFFF),
        borderColor: alias.colorPrimary,
      );
    }
    return TagStyle(
      background: alias.colorFillSecondary,
      foreground: alias.colorText,
      borderColor: alias.colorBorder,
    );
  }

  final Color background;
  final Color foreground;
  final Color borderColor;
}

/// sRGB relative luminance（简化版，未做 gamma 反变换，对比色挑选够用）。
double _luminance(Color c) {
  return 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
}

Color _withAlpha(Color c, double alpha) {
  return Color.fromARGB(
    (alpha * 255).round().clamp(0, 255),
    (c.r * 255).round(),
    (c.g * 255).round(),
    (c.b * 255).round(),
  );
}
