import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/input/input_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('InputStyle.resolve', () {
    test(
      'normal: borderColor=colorBorder, background=colorBackgroundContainer',
      () {
        final s = InputStyle.resolve(
          alias: alias,
          status: AntStatus.defaultStatus,
          hovered: false,
          focused: false,
          disabled: false,
        );
        expect(s.borderColor, alias.colorBorder);
        expect(s.background, alias.colorBackgroundContainer);
        expect(s.focusRing, isNull);
      },
    );

    test('hover → borderColor=colorPrimaryHover', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: true,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
    });

    test('focused → borderColor=colorPrimary + focusRing', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: false,
        focused: true,
        disabled: false,
      );
      expect(s.borderColor, alias.colorPrimary);
      expect(s.focusRing, isNotNull);
    });

    test('disabled → background=colorFillSecondary', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.defaultStatus,
        hovered: false,
        focused: false,
        disabled: true,
      );
      expect(s.background, alias.colorFillSecondary);
    });

    test('status=error → borderColor=colorError', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.error,
        hovered: false,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorError);
    });

    test('status=warning → borderColor=colorWarning', () {
      final s = InputStyle.resolve(
        alias: alias,
        status: AntStatus.warning,
        hovered: false,
        focused: false,
        disabled: false,
      );
      expect(s.borderColor, alias.colorWarning);
    });
  });

  group('InputStyle.sizeSpec', () {
    test('middle height = alias.controlHeight, fontSize = alias.fontSize', () {
      final s = InputStyle.sizeSpec(
        alias: alias,
        size: AntComponentSize.middle,
      );
      expect(s.height, alias.controlHeight);
      expect(s.fontSize, alias.fontSize);
    });
    test('small / large heights', () {
      expect(
        InputStyle.sizeSpec(alias: alias, size: AntComponentSize.small).height,
        24,
      );
      expect(
        InputStyle.sizeSpec(alias: alias, size: AntComponentSize.large).height,
        40,
      );
    });
  });
}
