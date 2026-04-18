import 'package:ant_design_flutter/src/foundation/color/generate.dart';
import 'package:ant_design_flutter/src/foundation/typography.dart';
import 'package:ant_design_flutter/src/theme/algorithm/theme_algorithm.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/theme/map_token.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter/painting.dart';

/// AntD v5 默认主题算法。
///
/// Dark / Compact 算法推迟至 2.1；本类是 Phase 1 唯一实现。
class DefaultAlgorithm implements AntThemeAlgorithm {
  const DefaultAlgorithm();

  /// 固定 13 阶灰阶，对齐 AntD v5 `grey` 预设。
  static const List<Color> _greyScale = <Color>[
    Color(0xFFFFFFFF),
    Color(0xFFFAFAFA),
    Color(0xFFF5F5F5),
    Color(0xFFF0F0F0),
    Color(0xFFD9D9D9),
    Color(0xFFBFBFBF),
    Color(0xFF8C8C8C),
    Color(0xFF595959),
    Color(0xFF434343),
    Color(0xFF262626),
    Color(0xFF1F1F1F),
    Color(0xFF141414),
    Color(0xFF000000),
  ];

  static const List<BoxShadow> _defaultShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 28,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> _secondaryShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  @override
  AntMapToken mapFromSeed(AntSeedToken seed) {
    return AntMapToken(
      colorPrimary: generatePalette(seed.colorPrimary),
      colorSuccess: generatePalette(seed.colorSuccess),
      colorWarning: generatePalette(seed.colorWarning),
      colorError: generatePalette(seed.colorError),
      colorInfo: generatePalette(seed.colorInfo),
      colorNeutral: _greyScale,
      controlHeight: 32,
      controlHeightSmall: 24,
      controlHeightLarge: 40,
      fontSize: Typography.fontSize,
      fontSizeSmall: Typography.fontSizeSmall,
      fontSizeLarge: Typography.fontSizeLarge,
      fontSizeExtraLarge: Typography.fontSizeExtraLarge,
      lineHeight: Typography.lineHeight,
      borderRadius: seed.borderRadius,
      borderRadiusSmall: (seed.borderRadius - 2).clamp(0, double.infinity),
      borderRadiusLarge: seed.borderRadius + 2,
      boxShadow: _defaultShadow,
      boxShadowSecondary: _secondaryShadow,
    );
  }

  @override
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map) {
    final textBase = seed.colorTextBase;
    return AntAliasToken(
      colorPrimary: seed.colorPrimary,
      colorPrimaryHover: map.colorPrimary[4],
      colorPrimaryActive: map.colorPrimary[6],
      colorPrimaryBackground: map.colorPrimary[0],
      colorPrimaryBackgroundHover: map.colorPrimary[1],
      colorPrimaryBorder: map.colorPrimary[2],
      colorSuccess: seed.colorSuccess,
      colorWarning: seed.colorWarning,
      colorError: seed.colorError,
      colorInfo: seed.colorInfo,
      colorText: _withAlpha(textBase, 0.88),
      colorTextSecondary: _withAlpha(textBase, 0.65),
      colorTextTertiary: _withAlpha(textBase, 0.45),
      colorTextDisabled: _withAlpha(textBase, 0.25),
      colorBackgroundContainer: seed.colorBackgroundBase,
      colorBackgroundElevated: seed.colorBackgroundBase,
      colorBackgroundLayout: map.colorNeutral[1],
      colorBorder: map.colorNeutral[4],
      colorBorderSecondary: map.colorNeutral[3],
      colorFill: _withAlpha(textBase, 0.15),
      colorFillSecondary: _withAlpha(textBase, 0.06),
      colorSplit: _withAlpha(textBase, 0.06),
      controlHeight: map.controlHeight,
      borderRadius: map.borderRadius,
      fontSize: map.fontSize,
    );
  }

  static Color _withAlpha(Color base, double alpha) {
    return Color.fromARGB(
      (alpha * 255).round().clamp(0, 255),
      (base.r * 255).round(),
      (base.g * 255).round(),
      (base.b * 255).round(),
    );
  }
}
