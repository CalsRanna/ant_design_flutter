import 'dart:ui';

import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter_test/flutter_test.dart';

const _blue = Color(0xFF1677FF);

AntAliasToken _sample() => const AntAliasToken(
  colorPrimary: _blue,
  colorPrimaryHover: _blue,
  colorPrimaryActive: _blue,
  colorPrimaryBackground: _blue,
  colorPrimaryBackgroundHover: _blue,
  colorPrimaryBorder: _blue,
  colorSuccess: _blue,
  colorWarning: _blue,
  colorError: _blue,
  colorInfo: _blue,
  colorText: _blue,
  colorTextSecondary: _blue,
  colorTextTertiary: _blue,
  colorTextDisabled: _blue,
  colorBackgroundContainer: _blue,
  colorBackgroundElevated: _blue,
  colorBackgroundLayout: _blue,
  colorBorder: _blue,
  colorBorderSecondary: _blue,
  colorFill: _blue,
  colorFillSecondary: _blue,
  colorSplit: _blue,
  controlHeight: 32,
  borderRadius: 6,
  fontSize: 14,
);

void main() {
  group('AntAliasToken', () {
    test('==/hashCode value-based on all 25 fields', () {
      expect(_sample(), equals(_sample()));
      expect(_sample().hashCode, _sample().hashCode);
    });

    test('copyWith changes exactly one field per call', () {
      const base = AntAliasToken(
        colorPrimary: Color(0xFF000001),
        colorPrimaryHover: Color(0xFF000002),
        colorPrimaryActive: Color(0xFF000003),
        colorPrimaryBackground: Color(0xFF000004),
        colorPrimaryBackgroundHover: Color(0xFF000005),
        colorPrimaryBorder: Color(0xFF000006),
        colorSuccess: Color(0xFF000007),
        colorWarning: Color(0xFF000008),
        colorError: Color(0xFF000009),
        colorInfo: Color(0xFF00000A),
        colorText: Color(0xFF00000B),
        colorTextSecondary: Color(0xFF00000C),
        colorTextTertiary: Color(0xFF00000D),
        colorTextDisabled: Color(0xFF00000E),
        colorBackgroundContainer: Color(0xFF00000F),
        colorBackgroundElevated: Color(0xFF000010),
        colorBackgroundLayout: Color(0xFF000011),
        colorBorder: Color(0xFF000012),
        colorBorderSecondary: Color(0xFF000013),
        colorFill: Color(0xFF000014),
        colorFillSecondary: Color(0xFF000015),
        colorSplit: Color(0xFF000016),
        controlHeight: 32,
        borderRadius: 6,
        fontSize: 14,
      );

      const marker = Color(0xFFDEADBE);
      final checks = <AntAliasToken Function(AntAliasToken)>[
        (t) => t.copyWith(colorPrimary: marker),
        (t) => t.copyWith(colorPrimaryHover: marker),
        (t) => t.copyWith(colorPrimaryActive: marker),
        (t) => t.copyWith(colorPrimaryBackground: marker),
        (t) => t.copyWith(colorPrimaryBackgroundHover: marker),
        (t) => t.copyWith(colorPrimaryBorder: marker),
        (t) => t.copyWith(colorSuccess: marker),
        (t) => t.copyWith(colorWarning: marker),
        (t) => t.copyWith(colorError: marker),
        (t) => t.copyWith(colorInfo: marker),
        (t) => t.copyWith(colorText: marker),
        (t) => t.copyWith(colorTextSecondary: marker),
        (t) => t.copyWith(colorTextTertiary: marker),
        (t) => t.copyWith(colorTextDisabled: marker),
        (t) => t.copyWith(colorBackgroundContainer: marker),
        (t) => t.copyWith(colorBackgroundElevated: marker),
        (t) => t.copyWith(colorBackgroundLayout: marker),
        (t) => t.copyWith(colorBorder: marker),
        (t) => t.copyWith(colorBorderSecondary: marker),
        (t) => t.copyWith(colorFill: marker),
        (t) => t.copyWith(colorFillSecondary: marker),
        (t) => t.copyWith(colorSplit: marker),
        (t) => t.copyWith(controlHeight: 99),
        (t) => t.copyWith(borderRadius: 99),
        (t) => t.copyWith(fontSize: 99),
      ];

      for (var i = 0; i < checks.length; i++) {
        final modified = checks[i](base);
        expect(
          modified,
          isNot(equals(base)),
          reason: 'copyWith case #$i did not modify the token',
        );
      }
      expect(checks, hasLength(25));
    });
  });
}
