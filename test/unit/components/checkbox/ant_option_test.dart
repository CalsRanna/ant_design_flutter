import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntOption', () {
    test('fields assigned', () {
      const opt = AntOption<int>(value: 1, label: 'one');
      expect(opt.value, 1);
      expect(opt.label, 'one');
      expect(opt.disabled, false);
    });

    test('equality by value/label/disabled', () {
      expect(
        const AntOption<int>(value: 1, label: 'a'),
        const AntOption<int>(value: 1, label: 'a'),
      );
      expect(
        const AntOption<int>(value: 1, label: 'a'),
        isNot(const AntOption<int>(value: 2, label: 'a')),
      );
    });
  });
}
