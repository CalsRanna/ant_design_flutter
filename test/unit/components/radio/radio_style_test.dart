import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/radio/radio_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('RadioStyle.resolve', () {
    test('unselected: border=colorBorder, inner=null', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: false,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorBorder);
      expect(s.innerDotColor, isNull);
    });

    test('unselected hover: border=colorPrimary', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: false,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
    });

    test('selected: border=colorPrimary, inner=colorPrimary', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: true,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.innerDotColor, alias.colorPrimary);
    });

    test('disabled selected: inner=colorTextDisabled', () {
      final s = RadioStyle.resolve(
        alias: alias,
        selected: true,
        hovered: false,
        disabled: true,
      );
      expect(s.innerDotColor, alias.colorTextDisabled);
    });
  });
}
