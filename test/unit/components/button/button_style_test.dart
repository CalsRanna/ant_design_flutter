import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/button/button_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('ButtonStyle.resolve — primary', () {
    test('normal', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimary);
      expect(s.foreground, const Color(0xFFFFFFFF));
      expect(s.borderColor, isNull);
    });
    test('hover', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimaryHover);
    });
    test('pressed', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {WidgetState.pressed},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorPrimaryActive);
    });
  });

  group('ButtonStyle.resolve — default', () {
    test('normal has border=colorBorder, background=colorBackgroundContainer',
        () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.defaultStyle,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorBackgroundContainer);
      expect(s.foreground, alias.colorText);
      expect(s.borderColor, alias.colorBorder);
    });
    test('hover: border=primaryHover, foreground=primaryHover', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.defaultStyle,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.borderColor, alias.colorPrimaryHover);
      expect(s.foreground, alias.colorPrimaryHover);
    });
  });

  group('ButtonStyle.resolve — text', () {
    test('normal transparent', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.text,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.background, const Color(0x00000000));
      expect(s.foreground, alias.colorText);
    });
    test('hover uses colorFillSecondary', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.text,
        states: const {WidgetState.hovered},
        danger: false,
        ghost: false,
      );
      expect(s.background, alias.colorFillSecondary);
    });
  });

  group('ButtonStyle.resolve — link', () {
    test('foreground=colorPrimary normal', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.link,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.foreground, alias.colorPrimary);
      expect(s.background, const Color(0x00000000));
    });
  });

  group('ButtonStyle.resolve — dashed', () {
    test('flags dashedBorder true', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.dashed,
        states: const {},
        danger: false,
        ghost: false,
      );
      expect(s.dashedBorder, isTrue);
      expect(s.borderColor, alias.colorBorder);
    });
  });

  group('ButtonStyle.resolve — danger', () {
    test('primary danger swaps to colorError', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: true,
        ghost: false,
      );
      expect(s.background, alias.colorError);
    });
  });

  group('ButtonStyle.resolve — ghost', () {
    test('primary ghost: transparent background, primary foreground', () {
      final s = ButtonStyle.resolve(
        alias: alias,
        type: AntButtonType.primary,
        states: const {},
        danger: false,
        ghost: true,
      );
      expect(s.background, const Color(0x00000000));
      expect(s.foreground, alias.colorPrimary);
    });
  });

  group('ButtonStyle.resolve — disabled', () {
    test('overrides all types', () {
      for (final type in AntButtonType.values) {
        final s = ButtonStyle.resolve(
          alias: alias,
          type: type,
          states: const {WidgetState.disabled},
          danger: false,
          ghost: false,
        );
        expect(
          s.background,
          alias.colorFillSecondary,
          reason: 'disabled background for $type',
        );
        expect(
          s.foreground,
          alias.colorTextDisabled,
          reason: 'disabled foreground for $type',
        );
      }
    });
  });

  group('ButtonStyle.sizeSpec', () {
    test('small: padding 7, fontSize 14', () {
      final s = ButtonStyle.sizeSpec(
        alias: alias,
        size: AntComponentSize.small,
      );
      expect(s.horizontalPadding, 7);
      expect(s.fontSize, 14);
      expect(s.height, 24);
    });
    test('middle: padding 15, fontSize 14, height=alias.controlHeight', () {
      final s = ButtonStyle.sizeSpec(
        alias: alias,
        size: AntComponentSize.middle,
      );
      expect(s.horizontalPadding, 15);
      expect(s.fontSize, 14);
      expect(s.height, alias.controlHeight);
    });
    test('large: padding 15, fontSize 16, height=40', () {
      final s = ButtonStyle.sizeSpec(
        alias: alias,
        size: AntComponentSize.large,
      );
      expect(s.horizontalPadding, 15);
      expect(s.fontSize, 16);
      expect(s.height, 40);
    });
  });
}
