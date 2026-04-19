import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/tag/tag_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final alias = AntThemeData().alias;

  group('TagStyle.resolveDefault', () {
    test('no color → fill=colorFillSecondary, foreground=colorText', () {
      final s = TagStyle.resolveDefault(alias: alias, color: null);
      expect(s.background, alias.colorFillSecondary);
      expect(s.foreground, alias.colorText);
      expect(s.borderColor, alias.colorBorder);
    });

    test('light color → foreground = colorText (dark text on light bg)', () {
      const lightYellow = Color(0xFFFFF8B8);
      final s = TagStyle.resolveDefault(alias: alias, color: lightYellow);
      expect(s.background, lightYellow);
      expect(s.foreground, alias.colorText);
    });

    test('dark color → foreground = white', () {
      const navy = Color(0xFF000080);
      final s = TagStyle.resolveDefault(alias: alias, color: navy);
      expect(s.background, navy);
      expect(s.foreground, const Color(0xFFFFFFFF));
    });
  });

  group('TagStyle.resolveCheckable', () {
    test('checked → colorPrimary background, white foreground', () {
      final s = TagStyle.resolveCheckable(alias: alias, checked: true);
      expect(s.background, alias.colorPrimary);
      expect(s.foreground, const Color(0xFFFFFFFF));
    });

    test('unchecked → colorFillSecondary background, colorText foreground', () {
      final s = TagStyle.resolveCheckable(alias: alias, checked: false);
      expect(s.background, alias.colorFillSecondary);
      expect(s.foreground, alias.colorText);
    });
  });
}
