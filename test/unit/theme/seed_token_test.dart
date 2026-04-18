import 'dart:ui';

import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSeedToken', () {
    test('default constructor uses AntD v5 defaults', () {
      const token = AntSeedToken();
      expect(token.colorPrimary, const Color(0xFF1677FF));
      expect(token.colorSuccess, const Color(0xFF52C41A));
      expect(token.colorWarning, const Color(0xFFFAAD14));
      expect(token.colorError, const Color(0xFFFF4D4F));
      expect(token.colorInfo, const Color(0xFF1677FF));
      expect(token.colorTextBase, const Color(0xFF000000));
      expect(token.colorBackgroundBase, const Color(0xFFFFFFFF));
      expect(token.fontFamily, isNull);
      expect(token.fontSize, 14);
      expect(token.borderRadius, 6);
      expect(token.sizeUnit, 4);
      expect(token.sizeStep, 4);
      expect(token.wireframe, isFalse);
      expect(token.motion, isTrue);
    });

    test('copyWith overrides single field', () {
      const base = AntSeedToken();
      final purple = base.copyWith(colorPrimary: const Color(0xFF722ED1));
      expect(purple.colorPrimary, const Color(0xFF722ED1));
      expect(purple.colorSuccess, base.colorSuccess);
    });

    test('== and hashCode are value-based', () {
      const a = AntSeedToken();
      const b = AntSeedToken();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      final c = a.copyWith(colorPrimary: const Color(0xFF000000));
      expect(a, isNot(equals(c)));
    });

    test('copyWith returns new instance (not same reference)', () {
      const base = AntSeedToken();
      final copy = base.copyWith();
      expect(identical(base, copy), isFalse);
      expect(base, equals(copy));
    });
  });
}
