import 'dart:ui';

import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntThemeData', () {
    test('default constructor builds map and alias eagerly', () {
      final theme = AntThemeData();
      expect(theme.map.colorPrimary, hasLength(10));
      expect(theme.alias.colorPrimary, theme.seed.colorPrimary);
    });

    test('custom seed propagates through map and alias', () {
      final theme = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      expect(theme.seed.colorPrimary, const Color(0xFF722ED1));
      expect(theme.map.colorPrimary[5], const Color(0xFF722ED1));
      expect(theme.alias.colorPrimary, const Color(0xFF722ED1));
    });

    test('same seed + same algorithm → equal map/alias', () {
      final a = AntThemeData();
      final b = AntThemeData();
      expect(a.map, equals(b.map));
      expect(a.alias, equals(b.alias));
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different seed → different theme', () {
      final a = AntThemeData();
      final b = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF000000)),
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith replaces seed and recomputes map/alias', () {
      final base = AntThemeData();
      final modified = base.copyWith(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      expect(modified.seed.colorPrimary, const Color(0xFF722ED1));
      expect(modified.map.colorPrimary[5], const Color(0xFF722ED1));
      expect(modified, isNot(equals(base)));
    });
  });
}
