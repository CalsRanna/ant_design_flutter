import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Seed Token：用户唯一需要配置的源。
///
/// 所有字段对齐 AntD v5 `SeedToken` 的核心子集。详见 spec
/// `docs/superpowers/specs/2026-04-18-phase-1-token-system-design.md` § 3.1。
@immutable
class AntSeedToken {
  const AntSeedToken({
    this.colorPrimary = const Color(0xFF1677FF),
    this.colorSuccess = const Color(0xFF52C41A),
    this.colorWarning = const Color(0xFFFAAD14),
    this.colorError = const Color(0xFFFF4D4F),
    this.colorInfo = const Color(0xFF1677FF),
    this.colorTextBase = const Color(0xFF000000),
    this.colorBackgroundBase = const Color(0xFFFFFFFF),
    this.fontFamily,
    this.fontSize = 14,
    this.borderRadius = 6,
    this.sizeUnit = 4,
    this.sizeStep = 4,
    this.wireframe = false,
    this.motion = true,
  });

  final Color colorPrimary;
  final Color colorSuccess;
  final Color colorWarning;
  final Color colorError;
  final Color colorInfo;
  final Color colorTextBase;

  /// 对应 AntD v5 `colorBgBase`。
  final Color colorBackgroundBase;

  final String? fontFamily;
  final double fontSize;
  final double borderRadius;
  final double sizeUnit;
  final double sizeStep;
  final bool wireframe;
  final bool motion;

  AntSeedToken copyWith({
    Color? colorPrimary,
    Color? colorSuccess,
    Color? colorWarning,
    Color? colorError,
    Color? colorInfo,
    Color? colorTextBase,
    Color? colorBackgroundBase,
    String? fontFamily,
    double? fontSize,
    double? borderRadius,
    double? sizeUnit,
    double? sizeStep,
    bool? wireframe,
    bool? motion,
  }) {
    return AntSeedToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorTextBase: colorTextBase ?? this.colorTextBase,
      colorBackgroundBase: colorBackgroundBase ?? this.colorBackgroundBase,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      sizeStep: sizeStep ?? this.sizeStep,
      wireframe: wireframe ?? this.wireframe,
      motion: motion ?? this.motion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntSeedToken &&
        other.colorPrimary == colorPrimary &&
        other.colorSuccess == colorSuccess &&
        other.colorWarning == colorWarning &&
        other.colorError == colorError &&
        other.colorInfo == colorInfo &&
        other.colorTextBase == colorTextBase &&
        other.colorBackgroundBase == colorBackgroundBase &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.borderRadius == borderRadius &&
        other.sizeUnit == sizeUnit &&
        other.sizeStep == sizeStep &&
        other.wireframe == wireframe &&
        other.motion == motion;
  }

  @override
  int get hashCode => Object.hash(
    colorPrimary,
    colorSuccess,
    colorWarning,
    colorError,
    colorInfo,
    colorTextBase,
    colorBackgroundBase,
    fontFamily,
    fontSize,
    borderRadius,
    sizeUnit,
    sizeStep,
    wireframe,
    motion,
  );
}
