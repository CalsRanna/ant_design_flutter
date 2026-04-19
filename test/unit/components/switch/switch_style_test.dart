import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/switch/switch_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('SwitchStyle.resolve', () {
    test('unchecked track = colorTextTertiary', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: false,
        hovered: false,
        disabled: false,
      );
      expect(s.trackColor, alias.colorTextTertiary);
    });

    test('checked track = colorPrimary', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: false,
      );
      expect(s.trackColor, alias.colorPrimary);
    });

    test('checked + hover → colorPrimaryHover', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: true,
        disabled: false,
      );
      expect(s.trackColor, alias.colorPrimaryHover);
    });

    test('disabled opacity = 0.4', () {
      final s = SwitchStyle.resolve(
        alias: alias,
        checked: true,
        hovered: false,
        disabled: true,
      );
      expect(s.opacity, 0.4);
    });
  });

  group('SwitchStyle.sizeSpec', () {
    test('middle: 28x16, thumb=14', () {
      final s = SwitchStyle.sizeSpec(AntComponentSize.middle);
      expect(s.width, 28);
      expect(s.height, 16);
      expect(s.thumbDiameter, 14);
    });
    test('small: 22x14, thumb=12', () {
      final s = SwitchStyle.sizeSpec(AntComponentSize.small);
      expect(s.width, 22);
      expect(s.height, 14);
      expect(s.thumbDiameter, 12);
    });
    test('large maps to middle spec', () {
      expect(
        SwitchStyle.sizeSpec(AntComponentSize.large),
        SwitchStyle.sizeSpec(AntComponentSize.middle),
      );
    });
  });
}
