import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntText', () {
    testWidgets('default normal type uses colorText', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('hello')),
      );
      final context = tester.element(find.text('hello'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, alias.colorText);
    });

    testWidgets('danger type uses colorError', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('danger', type: AntTextType.danger)),
      );
      final context = tester.element(find.text('danger'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('danger'));
      expect(text.style?.color, alias.colorError);
    });

    testWidgets('strong makes fontWeight w600', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('b', strong: true)),
      );
      final text = tester.widget<Text>(find.text('b'));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('italic / underline / delete propagate', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntText(
            'styled',
            italic: true,
            underline: true,
            delete: true,
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('styled'));
      expect(text.style?.fontStyle, FontStyle.italic);
      expect(
        text.style?.decoration,
        TextDecoration.combine(const [
          TextDecoration.underline,
          TextDecoration.lineThrough,
        ]),
      );
    });

    testWidgets('size small uses alias.fontSize - 2', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntText('s', size: AntComponentSize.small)),
      );
      final context = tester.element(find.text('s'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('s'));
      expect(text.style?.fontSize, alias.fontSize - 2);
    });
  });
}
