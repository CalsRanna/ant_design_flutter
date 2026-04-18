import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Alias Token：组件消费的语义层。字段 25 个，MVP 17 组件覆盖所需。
///
/// 详见 spec § 3.3。组件只从此层取值，禁止绕过读 Map/Seed。
@immutable
class AntAliasToken {
  const AntAliasToken({
    required this.colorPrimary,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorPrimaryBackground,
    required this.colorPrimaryBackgroundHover,
    required this.colorPrimaryBorder,
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextTertiary,
    required this.colorTextDisabled,
    required this.colorBackgroundContainer,
    required this.colorBackgroundElevated,
    required this.colorBackgroundLayout,
    required this.colorBorder,
    required this.colorBorderSecondary,
    required this.colorFill,
    required this.colorFillSecondary,
    required this.colorSplit,
    required this.controlHeight,
    required this.borderRadius,
    required this.fontSize,
  });

  // primary 衍生态
  final Color colorPrimary;
  final Color colorPrimaryHover;
  final Color colorPrimaryActive;

  /// 对应 AntD `colorPrimaryBg`。
  final Color colorPrimaryBackground;

  /// 对应 AntD `colorPrimaryBgHover`。
  final Color colorPrimaryBackgroundHover;

  final Color colorPrimaryBorder;

  // 语义色
  final Color colorSuccess;
  final Color colorWarning;
  final Color colorError;
  final Color colorInfo;

  // 文本 4 级
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextTertiary;
  final Color colorTextDisabled;

  /// 对应 AntD `colorBgContainer`。
  final Color colorBackgroundContainer;

  /// 对应 AntD `colorBgElevated`。
  final Color colorBackgroundElevated;

  /// 对应 AntD `colorBgLayout`。
  final Color colorBackgroundLayout;

  // 边框
  final Color colorBorder;
  final Color colorBorderSecondary;

  // 填充 / split
  final Color colorFill;
  final Color colorFillSecondary;
  final Color colorSplit;

  // 尺寸 & 字体
  final double controlHeight;
  final double borderRadius;
  final double fontSize;

  AntAliasToken copyWith({
    Color? colorPrimary,
    Color? colorPrimaryHover,
    Color? colorPrimaryActive,
    Color? colorPrimaryBackground,
    Color? colorPrimaryBackgroundHover,
    Color? colorPrimaryBorder,
    Color? colorSuccess,
    Color? colorWarning,
    Color? colorError,
    Color? colorInfo,
    Color? colorText,
    Color? colorTextSecondary,
    Color? colorTextTertiary,
    Color? colorTextDisabled,
    Color? colorBackgroundContainer,
    Color? colorBackgroundElevated,
    Color? colorBackgroundLayout,
    Color? colorBorder,
    Color? colorBorderSecondary,
    Color? colorFill,
    Color? colorFillSecondary,
    Color? colorSplit,
    double? controlHeight,
    double? borderRadius,
    double? fontSize,
  }) {
    return AntAliasToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorPrimaryHover: colorPrimaryHover ?? this.colorPrimaryHover,
      colorPrimaryActive: colorPrimaryActive ?? this.colorPrimaryActive,
      colorPrimaryBackground:
          colorPrimaryBackground ?? this.colorPrimaryBackground,
      colorPrimaryBackgroundHover:
          colorPrimaryBackgroundHover ?? this.colorPrimaryBackgroundHover,
      colorPrimaryBorder: colorPrimaryBorder ?? this.colorPrimaryBorder,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorText: colorText ?? this.colorText,
      colorTextSecondary: colorTextSecondary ?? this.colorTextSecondary,
      colorTextTertiary: colorTextTertiary ?? this.colorTextTertiary,
      colorTextDisabled: colorTextDisabled ?? this.colorTextDisabled,
      colorBackgroundContainer:
          colorBackgroundContainer ?? this.colorBackgroundContainer,
      colorBackgroundElevated:
          colorBackgroundElevated ?? this.colorBackgroundElevated,
      colorBackgroundLayout:
          colorBackgroundLayout ?? this.colorBackgroundLayout,
      colorBorder: colorBorder ?? this.colorBorder,
      colorBorderSecondary: colorBorderSecondary ?? this.colorBorderSecondary,
      colorFill: colorFill ?? this.colorFill,
      colorFillSecondary: colorFillSecondary ?? this.colorFillSecondary,
      colorSplit: colorSplit ?? this.colorSplit,
      controlHeight: controlHeight ?? this.controlHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntAliasToken &&
        other.colorPrimary == colorPrimary &&
        other.colorPrimaryHover == colorPrimaryHover &&
        other.colorPrimaryActive == colorPrimaryActive &&
        other.colorPrimaryBackground == colorPrimaryBackground &&
        other.colorPrimaryBackgroundHover == colorPrimaryBackgroundHover &&
        other.colorPrimaryBorder == colorPrimaryBorder &&
        other.colorSuccess == colorSuccess &&
        other.colorWarning == colorWarning &&
        other.colorError == colorError &&
        other.colorInfo == colorInfo &&
        other.colorText == colorText &&
        other.colorTextSecondary == colorTextSecondary &&
        other.colorTextTertiary == colorTextTertiary &&
        other.colorTextDisabled == colorTextDisabled &&
        other.colorBackgroundContainer == colorBackgroundContainer &&
        other.colorBackgroundElevated == colorBackgroundElevated &&
        other.colorBackgroundLayout == colorBackgroundLayout &&
        other.colorBorder == colorBorder &&
        other.colorBorderSecondary == colorBorderSecondary &&
        other.colorFill == colorFill &&
        other.colorFillSecondary == colorFillSecondary &&
        other.colorSplit == colorSplit &&
        other.controlHeight == controlHeight &&
        other.borderRadius == borderRadius &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode => Object.hashAll(<Object>[
    colorPrimary,
    colorPrimaryHover,
    colorPrimaryActive,
    colorPrimaryBackground,
    colorPrimaryBackgroundHover,
    colorPrimaryBorder,
    colorSuccess,
    colorWarning,
    colorError,
    colorInfo,
    colorText,
    colorTextSecondary,
    colorTextTertiary,
    colorTextDisabled,
    colorBackgroundContainer,
    colorBackgroundElevated,
    colorBackgroundLayout,
    colorBorder,
    colorBorderSecondary,
    colorFill,
    colorFillSecondary,
    colorSplit,
    controlHeight,
    borderRadius,
    fontSize,
  ]);
}
