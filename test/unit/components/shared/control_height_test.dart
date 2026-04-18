import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/_shared/control_height.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveControlHeight', () {
    final alias = AntThemeData().alias;

    test('small returns 24', () {
      expect(resolveControlHeight(alias, AntComponentSize.small), 24);
    });

    test('middle returns alias.controlHeight (32 for default theme)', () {
      expect(
        resolveControlHeight(alias, AntComponentSize.middle),
        alias.controlHeight,
      );
      expect(alias.controlHeight, 32);
    });

    test('large returns 40', () {
      expect(resolveControlHeight(alias, AntComponentSize.large), 40);
    });
  });
}
