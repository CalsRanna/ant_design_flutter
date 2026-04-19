import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AntParagraph renders text with 1em bottom padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const AntApp(home: AntParagraph('body')),
    );
    expect(find.text('body'), findsOneWidget);
    final padding = tester.widget<Padding>(
      find
          .ancestor(of: find.text('body'), matching: find.byType(Padding))
          .first,
    );
    final context = tester.element(find.text('body'));
    final alias = AntTheme.aliasOf(context);
    expect(
      (padding.padding as EdgeInsets).bottom,
      alias.fontSize, // 1em
    );
  });

  testWidgets('AntParagraph danger type propagates to AntText', (tester) async {
    await tester.pumpWidget(
      const AntApp(home: AntParagraph('err', type: AntTextType.danger)),
    );
    final context = tester.element(find.text('err'));
    final alias = AntTheme.aliasOf(context);
    final text = tester.widget<Text>(find.text('err'));
    expect(text.style?.color, alias.colorError);
  });
}
