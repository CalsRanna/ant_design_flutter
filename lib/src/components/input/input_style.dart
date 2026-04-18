import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/component_status.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Input 视觉派生结果。
@immutable
class InputStyle {
  const InputStyle({
    required this.borderColor,
    required this.background,
    required this.focusRing,
  });

  /// 根据 [status] / [hovered] / [focused] / [disabled] 派生 border / background / focusRing。
  factory InputStyle.resolve({
    required AntAliasToken alias,
    required AntStatus status,
    required bool hovered,
    required bool focused,
    required bool disabled,
  }) {
    final background = disabled
        ? alias.colorFillSecondary
        : alias.colorBackgroundContainer;

    Color borderColor;
    if (status == AntStatus.error) {
      borderColor = alias.colorError;
    } else if (status == AntStatus.warning) {
      borderColor = alias.colorWarning;
    } else if (disabled) {
      borderColor = alias.colorBorder;
    } else if (focused) {
      borderColor = alias.colorPrimary;
    } else if (hovered) {
      borderColor = alias.colorPrimaryHover;
    } else {
      borderColor = alias.colorBorder;
    }

    return InputStyle(
      borderColor: borderColor,
      background: background,
      focusRing: focused && !disabled && status == AntStatus.defaultStatus
          ? alias.colorPrimaryBackground
          : null,
    );
  }

  final Color borderColor;
  final Color background;

  /// focus 时 2px 外环颜色；非 focus 时为 null。
  final Color? focusRing;

  static InputSizeSpec sizeSpec({
    required AntAliasToken alias,
    required AntComponentSize size,
  }) {
    return InputSizeSpec(
      height: resolveControlHeight(alias, size),
      fontSize: switch (size) {
        AntComponentSize.small => alias.fontSize - 2,
        AntComponentSize.middle => alias.fontSize,
        AntComponentSize.large => alias.fontSize + 2,
      },
      horizontalPadding: switch (size) {
        AntComponentSize.small => 7,
        _ => 11,
      },
    );
  }
}

@immutable
class InputSizeSpec {
  const InputSizeSpec({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
  });

  final double height;
  final double fontSize;
  final double horizontalPadding;
}
