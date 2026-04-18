import 'package:ant_design_flutter/src/theme/map_token.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

AntMapToken _sampleMapToken() => AntMapToken(
  colorPrimary: List<Color>.generate(10, (i) => Color(0xFF000000 | i)),
  colorSuccess: List<Color>.generate(10, (i) => Color(0xFF100000 | i)),
  colorWarning: List<Color>.generate(10, (i) => Color(0xFF200000 | i)),
  colorError: List<Color>.generate(10, (i) => Color(0xFF300000 | i)),
  colorInfo: List<Color>.generate(10, (i) => Color(0xFF400000 | i)),
  colorNeutral: List<Color>.generate(13, (i) => Color(0xFF500000 | i)),
  controlHeight: 32,
  controlHeightSmall: 24,
  controlHeightLarge: 40,
  fontSize: 14,
  fontSizeSmall: 12,
  fontSizeLarge: 16,
  fontSizeExtraLarge: 20,
  lineHeight: 1.5714,
  borderRadius: 6,
  borderRadiusSmall: 4,
  borderRadiusLarge: 8,
  boxShadow: const <BoxShadow>[
    BoxShadow(color: Color(0x26000000), blurRadius: 16),
  ],
  boxShadowSecondary: const <BoxShadow>[
    BoxShadow(color: Color(0x1A000000), blurRadius: 8),
  ],
);

void main() {
  group('AntMapToken', () {
    test('exposes 19 fields via constructor', () {
      final t = _sampleMapToken();
      expect(t.colorPrimary, hasLength(10));
      expect(t.colorNeutral, hasLength(13));
      expect(t.controlHeight, 32);
      expect(t.controlHeightSmall, 24);
      expect(t.controlHeightLarge, 40);
      expect(t.fontSize, 14);
      expect(t.fontSizeSmall, 12);
      expect(t.fontSizeLarge, 16);
      expect(t.fontSizeExtraLarge, 20);
      expect(t.lineHeight, closeTo(1.5714, 0.0001));
      expect(t.borderRadius, 6);
      expect(t.borderRadiusSmall, 4);
      expect(t.borderRadiusLarge, 8);
      expect(t.boxShadow, hasLength(1));
      expect(t.boxShadowSecondary, hasLength(1));
    });

    test('== compares list contents (not identity)', () {
      final a = _sampleMapToken();
      final b = _sampleMapToken();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('== returns false when a color list differs', () {
      final a = _sampleMapToken();
      final b = a.copyWith(
        colorPrimary: List<Color>.generate(10, (_) => const Color(0xFFFFFFFF)),
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith overrides a single field', () {
      final a = _sampleMapToken();
      final b = a.copyWith(controlHeight: 36);
      expect(b.controlHeight, 36);
      expect(b.controlHeightSmall, a.controlHeightSmall);
    });
  });
}
