import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Map Token：算法从 Seed 派生的中间层。组件不直接消费此层；
/// 它只是给 Alias 计算用的中间结果。
///
/// 字段 19 个。详见 spec § 3.2。
@immutable
class AntMapToken {
  const AntMapToken({
    required this.colorPrimary,
    required this.colorSuccess,
    required this.colorWarning,
    required this.colorError,
    required this.colorInfo,
    required this.colorNeutral,
    required this.controlHeight,
    required this.controlHeightSmall,
    required this.controlHeightLarge,
    required this.fontSize,
    required this.fontSizeSmall,
    required this.fontSizeLarge,
    required this.fontSizeExtraLarge,
    required this.lineHeight,
    required this.borderRadius,
    required this.borderRadiusSmall,
    required this.borderRadiusLarge,
    required this.boxShadow,
    required this.boxShadowSecondary,
  });

  /// 10 阶主色：[0] 最浅 → [5] seed → [9] 最深。
  final List<Color> colorPrimary;
  final List<Color> colorSuccess;
  final List<Color> colorWarning;
  final List<Color> colorError;
  final List<Color> colorInfo;

  /// 13 阶灰阶：[0] 最浅 → [12] 最深。
  final List<Color> colorNeutral;

  final double controlHeight;

  /// 对应 AntD `controlHeightSM`。
  final double controlHeightSmall;

  /// 对应 AntD `controlHeightLG`。
  final double controlHeightLarge;

  final double fontSize;

  /// 对应 AntD `fontSizeSM`。
  final double fontSizeSmall;

  /// 对应 AntD `fontSizeLG`。
  final double fontSizeLarge;

  /// 对应 AntD `fontSizeXL`。
  final double fontSizeExtraLarge;

  final double lineHeight;
  final double borderRadius;

  /// 对应 AntD `borderRadiusSM`。
  final double borderRadiusSmall;

  /// 对应 AntD `borderRadiusLG`。
  final double borderRadiusLarge;

  final List<BoxShadow> boxShadow;
  final List<BoxShadow> boxShadowSecondary;

  AntMapToken copyWith({
    List<Color>? colorPrimary,
    List<Color>? colorSuccess,
    List<Color>? colorWarning,
    List<Color>? colorError,
    List<Color>? colorInfo,
    List<Color>? colorNeutral,
    double? controlHeight,
    double? controlHeightSmall,
    double? controlHeightLarge,
    double? fontSize,
    double? fontSizeSmall,
    double? fontSizeLarge,
    double? fontSizeExtraLarge,
    double? lineHeight,
    double? borderRadius,
    double? borderRadiusSmall,
    double? borderRadiusLarge,
    List<BoxShadow>? boxShadow,
    List<BoxShadow>? boxShadowSecondary,
  }) {
    return AntMapToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorNeutral: colorNeutral ?? this.colorNeutral,
      controlHeight: controlHeight ?? this.controlHeight,
      controlHeightSmall: controlHeightSmall ?? this.controlHeightSmall,
      controlHeightLarge: controlHeightLarge ?? this.controlHeightLarge,
      fontSize: fontSize ?? this.fontSize,
      fontSizeSmall: fontSizeSmall ?? this.fontSizeSmall,
      fontSizeLarge: fontSizeLarge ?? this.fontSizeLarge,
      fontSizeExtraLarge: fontSizeExtraLarge ?? this.fontSizeExtraLarge,
      lineHeight: lineHeight ?? this.lineHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
      boxShadow: boxShadow ?? this.boxShadow,
      boxShadowSecondary: boxShadowSecondary ?? this.boxShadowSecondary,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntMapToken &&
        listEquals(other.colorPrimary, colorPrimary) &&
        listEquals(other.colorSuccess, colorSuccess) &&
        listEquals(other.colorWarning, colorWarning) &&
        listEquals(other.colorError, colorError) &&
        listEquals(other.colorInfo, colorInfo) &&
        listEquals(other.colorNeutral, colorNeutral) &&
        other.controlHeight == controlHeight &&
        other.controlHeightSmall == controlHeightSmall &&
        other.controlHeightLarge == controlHeightLarge &&
        other.fontSize == fontSize &&
        other.fontSizeSmall == fontSizeSmall &&
        other.fontSizeLarge == fontSizeLarge &&
        other.fontSizeExtraLarge == fontSizeExtraLarge &&
        other.lineHeight == lineHeight &&
        other.borderRadius == borderRadius &&
        other.borderRadiusSmall == borderRadiusSmall &&
        other.borderRadiusLarge == borderRadiusLarge &&
        listEquals(other.boxShadow, boxShadow) &&
        listEquals(other.boxShadowSecondary, boxShadowSecondary);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(colorPrimary),
    Object.hashAll(colorSuccess),
    Object.hashAll(colorWarning),
    Object.hashAll(colorError),
    Object.hashAll(colorInfo),
    Object.hashAll(colorNeutral),
    controlHeight,
    controlHeightSmall,
    controlHeightLarge,
    fontSize,
    fontSizeSmall,
    fontSizeLarge,
    fontSizeExtraLarge,
    lineHeight,
    borderRadius,
    borderRadiusSmall,
    borderRadiusLarge,
    Object.hashAll(boxShadow),
    Object.hashAll(boxShadowSecondary),
  );
}
