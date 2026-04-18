import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTitle', () {
    testWidgets('h1 renders 38px bold', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('Hello')),
      );
      final text = tester.widget<Text>(find.text('Hello'));
      expect(text.style?.fontSize, 38);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('h5 renders 16px bold', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('H5', level: AntTitleLevel.h5)),
      );
      final text = tester.widget<Text>(find.text('H5'));
      expect(text.style?.fontSize, 16);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('uses alias.colorText', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTitle('Color')),
      );
      final context = tester.element(find.text('Color'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('Color'));
      expect(text.style?.color, alias.colorText);
    });
  });
}
