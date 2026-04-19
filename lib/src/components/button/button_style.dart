import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// AntButton 的类型。对齐 AntD v5（`default` 关键字冲突 → `defaultStyle`）。
enum AntButtonType { primary, defaultStyle, dashed, text, link }

/// AntButton 的形状。
enum AntButtonShape { rectangle, round, circle }

/// Button 视觉派生（纯数据，可 unit-test）。
///
/// 由 `resolve` + `sizeSpec` 两个静态方法产出，widget 层只负责拼装。
@immutable
class ButtonStyle {
  const ButtonStyle({
    required this.background,
    required this.foreground,
    required this.borderColor,
    required this.dashedBorder,
  });

  /// 根据 [type] / [states] / [danger] / [ghost] 派生 background / foreground / border。
  factory ButtonStyle.resolve({
    required AntAliasToken alias,
    required AntButtonType type,
    required Set<WidgetState> states,
    required bool danger,
    required bool ghost,
  }) {
    if (states.contains(WidgetState.disabled)) {
      return ButtonStyle(
        background: alias.colorFillSecondary,
        foreground: alias.colorTextDisabled,
        borderColor: alias.colorBorder,
        dashedBorder: type == AntButtonType.dashed,
      );
    }

    // 选主色通道：danger=true 时走 error；否则走 primary。
    final primary = danger ? alias.colorError : alias.colorPrimary;
    final primaryHover = danger ? alias.colorError : alias.colorPrimaryHover;
    final primaryActive = danger ? alias.colorError : alias.colorPrimaryActive;

    final hovered = states.contains(WidgetState.hovered);
    final pressed = states.contains(WidgetState.pressed);

    switch (type) {
      case AntButtonType.primary:
        if (ghost) {
          return ButtonStyle(
            background: const Color(0x00000000),
            foreground: pressed
                ? primaryActive
                : hovered
                ? primaryHover
                : primary,
            borderColor: pressed
                ? primaryActive
                : hovered
                ? primaryHover
                : primary,
            dashedBorder: false,
          );
        }
        return ButtonStyle(
          background: pressed
              ? primaryActive
              : hovered
              ? primaryHover
              : primary,
          foreground: const Color(0xFFFFFFFF),
          borderColor: null,
          dashedBorder: false,
        );

      case AntButtonType.defaultStyle:
      case AntButtonType.dashed:
        final isDashed = type == AntButtonType.dashed;
        if (ghost) {
          // ghost=true 只对 primary / default 有意义：default ghost 效果同 default。
          return ButtonStyle(
            background: const Color(0x00000000),
            foreground: alias.colorText,
            borderColor: alias.colorBorder,
            dashedBorder: isDashed,
          );
        }
        return ButtonStyle(
          background: alias.colorBackgroundContainer,
          foreground: pressed
              ? primaryActive
              : hovered
              ? primaryHover
              : alias.colorText,
          borderColor: pressed
              ? primaryActive
              : hovered
              ? primaryHover
              : alias.colorBorder,
          dashedBorder: isDashed,
        );

      case AntButtonType.text:
        return ButtonStyle(
          background: pressed
              ? alias.colorFill
              : hovered
              ? alias.colorFillSecondary
              : const Color(0x00000000),
          foreground: alias.colorText,
          borderColor: null,
          dashedBorder: false,
        );

      case AntButtonType.link:
        return ButtonStyle(
          background: const Color(0x00000000),
          foreground: pressed
              ? primaryActive
              : hovered
              ? primaryHover
              : primary,
          borderColor: null,
          dashedBorder: false,
        );
    }
  }

  /// 填充色（透明用 `Color(0x00000000)`）。
  final Color background;

  /// 文字 / icon 颜色。
  final Color foreground;

  /// 实线 / 虚线时的边框色；null 表示无 border。
  final Color? borderColor;

  /// 是否采用虚线边框（dashed type）。
  final bool dashedBorder;

  /// 根据 [size] 派生高度 / 水平 padding / 字号。
  static ButtonSizeSpec sizeSpec({
    required AntAliasToken alias,
    required AntComponentSize size,
  }) {
    return switch (size) {
      AntComponentSize.small => ButtonSizeSpec(
        height: resolveControlHeight(alias, AntComponentSize.small),
        horizontalPadding: 7,
        fontSize: 14,
      ),
      AntComponentSize.middle => ButtonSizeSpec(
        height: resolveControlHeight(alias, AntComponentSize.middle),
        horizontalPadding: 15,
        fontSize: 14,
      ),
      AntComponentSize.large => ButtonSizeSpec(
        height: resolveControlHeight(alias, AntComponentSize.large),
        horizontalPadding: 15,
        fontSize: 16,
      ),
    };
  }
}

/// 尺寸派生结果。
@immutable
class ButtonSizeSpec {
  const ButtonSizeSpec({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
}
