import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/checkbox/checkbox_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('CheckboxStyle.resolve', () {
    test('unchecked: border=colorBorder, fill=white, tick absent', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: false,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorBorder);
      expect(s.fillColor, const Color(0xFFFFFFFF));
      expect(s.tickColor, isNull);
    });

    test('unchecked hover: border=colorPrimary', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: false,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
    });

    test('checked: border/fill=colorPrimary, tick=white', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.fillColor, alias.colorPrimary);
      expect(s.tickColor, const Color(0xFFFFFFFF));
    });

    test('checked hover: border/fill=colorPrimaryHover', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
      expect(s.fillColor, alias.colorPrimaryHover);
    });

    test('disabled: fill=colorFillSecondary, tick=colorTextDisabled', () {
      final s = CheckboxStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: true,
      );
      expect(s.fillColor, alias.colorFillSecondary);
      expect(s.tickColor, alias.colorTextDisabled);
    });
  });
}
