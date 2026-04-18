import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/hsv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Hsv.fromColor', () {
    test('pure red → hue 0, saturation 1, value 1', () {
      final hsv = Hsv.fromColor(const Color(0xFFFF0000));
      expect(hsv.hue, closeTo(0, 0.5));
      expect(hsv.saturation, closeTo(1, 0.001));
      expect(hsv.value, closeTo(1, 0.001));
    });

    test('pure white → saturation 0, value 1', () {
      final hsv = Hsv.fromColor(const Color(0xFFFFFFFF));
      expect(hsv.saturation, closeTo(0, 0.001));
      expect(hsv.value, closeTo(1, 0.001));
    });

    test('pure black → value 0', () {
      final hsv = Hsv.fromColor(const Color(0xFF000000));
      expect(hsv.value, closeTo(0, 0.001));
    });

    test('AntD primary #1677FF → hue ~215', () {
      final hsv = Hsv.fromColor(const Color(0xFF1677FF));
      expect(hsv.hue, closeTo(215.3, 0.5));
      expect(hsv.saturation, closeTo(0.914, 0.01));
      expect(hsv.value, closeTo(1, 0.01));
    });
  });

  group('Hsv.toColor', () {
    test('round-trip preserves RGB within 1', () {
      const inputs = <int>[0xFF1677FF, 0xFF52C41A, 0xFFFAAD14, 0xFFFF4D4F];
      for (final input in inputs) {
        final original = Color(input);
        final rebuilt = Hsv.fromColor(original).toColor();
        expect(((rebuilt.r - original.r) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'red drift for ${input.toRadixString(16)}');
        expect(((rebuilt.g - original.g) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'green drift for ${input.toRadixString(16)}');
        expect(((rebuilt.b - original.b) * 255).abs(), lessThanOrEqualTo(1),
            reason: 'blue drift for ${input.toRadixString(16)}');
      }
    });

    test('alpha defaults to 1 and can be overridden', () {
      const hsv = Hsv(0, 1, 1);
      expect(hsv.toColor().a, closeTo(1, 0.001));
      expect(hsv.toColor(alpha: 0.5).a, closeTo(128 / 255, 0.01));
    });
  });
}
