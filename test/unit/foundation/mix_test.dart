import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/mix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mixColor', () {
    test('weight 0 returns base unchanged', () {
      final result = mixColor(
        const Color(0xFF1677FF),
        const Color(0xFFFFFFFF),
        0,
      );
      expect(result, const Color(0xFF1677FF));
    });

    test('weight 100 returns mixed color', () {
      final result = mixColor(
        const Color(0xFF1677FF),
        const Color(0xFFFFFFFF),
        100,
      );
      expect(result, const Color(0xFFFFFFFF));
    });

    test('weight 50 returns midpoint', () {
      final result = mixColor(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        50,
      );
      expect((result.r * 255).round(), closeTo(128, 1));
      expect((result.g * 255).round(), closeTo(128, 1));
      expect((result.b * 255).round(), closeTo(128, 1));
    });

    test('preserves alpha from base color', () {
      final result = mixColor(
        const Color(0x80FF0000),
        const Color(0xFF00FF00),
        50,
      );
      expect((result.a * 255).round(), 128);
    });
  });
}
