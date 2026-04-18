import 'dart:ui';

import 'package:ant_design_flutter/src/theme/algorithm/default_algorithm.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const algorithm = DefaultAlgorithm();

  group('mapFromSeed', () {
    test('colorPrimary is 10-length palette with seed at index 5', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      expect(map.colorPrimary, hasLength(10));
      expect(map.colorPrimary[5], seed.colorPrimary);
    });

    test('colorNeutral is 13-length fixed grey scale', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      expect(map.colorNeutral, hasLength(13));
      // 首尾接近白 / 黑
      expect(
        (map.colorNeutral.first.r * 255).round(),
        greaterThanOrEqualTo(250),
      );
      expect((map.colorNeutral.last.r * 255).round(), lessThanOrEqualTo(20));
    });

    test('control heights follow AntD defaults', () {
      final map = algorithm.mapFromSeed(const AntSeedToken());
      expect(map.controlHeight, 32);
      expect(map.controlHeightSmall, 24);
      expect(map.controlHeightLarge, 40);
    });

    test('font sizes follow Typography constants', () {
      final map = algorithm.mapFromSeed(const AntSeedToken());
      expect(map.fontSize, 14);
      expect(map.fontSizeSmall, 12);
      expect(map.fontSizeLarge, 16);
      expect(map.fontSizeExtraLarge, 20);
    });

    test('border radius derives from seed', () {
      final map = algorithm.mapFromSeed(const AntSeedToken(borderRadius: 8));
      expect(map.borderRadius, 8);
      expect(map.borderRadiusSmall, lessThan(map.borderRadius));
      expect(map.borderRadiusLarge, greaterThan(map.borderRadius));
    });
  });

  group('aliasFromMap', () {
    test('maps key fields from seed / map correctly', () {
      const seed = AntSeedToken();
      final map = algorithm.mapFromSeed(seed);
      final alias = algorithm.aliasFromMap(seed, map);

      expect(alias.colorPrimary, seed.colorPrimary);
      expect(alias.colorPrimaryHover, map.colorPrimary[4]);
      expect(alias.colorPrimaryActive, map.colorPrimary[6]);
      expect(alias.colorPrimaryBackground, map.colorPrimary[0]);
      expect(alias.colorPrimaryBackgroundHover, map.colorPrimary[1]);
      expect(alias.colorPrimaryBorder, map.colorPrimary[2]);

      expect(alias.colorSuccess, seed.colorSuccess);
      expect(alias.colorWarning, seed.colorWarning);
      expect(alias.colorError, seed.colorError);
      expect(alias.colorInfo, seed.colorInfo);

      expect(alias.colorText.a, greaterThan(200 / 255));
      expect(alias.colorTextSecondary.a, lessThan(alias.colorText.a));
      expect(alias.colorTextTertiary.a, lessThan(alias.colorTextSecondary.a));
      expect(alias.colorTextDisabled.a, lessThan(alias.colorTextTertiary.a));

      expect(alias.colorBackgroundContainer, seed.colorBackgroundBase);
      expect(alias.colorBackgroundElevated, seed.colorBackgroundBase);
      expect(alias.colorBackgroundLayout, map.colorNeutral[1]);

      expect(alias.colorBorder, map.colorNeutral[4]);
      expect(alias.colorBorderSecondary, map.colorNeutral[3]);

      expect(alias.colorFill, isA<Color>());
      expect(alias.colorFillSecondary, isA<Color>());
      expect(alias.colorSplit, isA<Color>());

      expect(alias.controlHeight, map.controlHeight);
      expect(alias.borderRadius, map.borderRadius);
      expect(alias.fontSize, map.fontSize);
    });

    test('purple seed produces purple primary alias', () {
      const seed = AntSeedToken(colorPrimary: Color(0xFF722ED1));
      final map = algorithm.mapFromSeed(seed);
      final alias = algorithm.aliasFromMap(seed, map);
      expect(alias.colorPrimary, const Color(0xFF722ED1));
    });
  });
}
