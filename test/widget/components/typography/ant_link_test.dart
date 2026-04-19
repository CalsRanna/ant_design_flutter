import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntLink', () {
    testWidgets('renders with colorPrimary by default', (tester) async {
      await tester.pumpWidget(
        AntApp(home: AntLink('click', onPressed: () {})),
      );
      final context = tester.element(find.text('click'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('click'));
      expect(text.style?.color, alias.colorPrimary);
    });

    testWidgets('hover switches to colorPrimaryHover', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(child: AntLink('h', onPressed: () {})),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('h')));
      await tester.pump();

      final context = tester.element(find.text('h'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('h'));
      expect(text.style?.color, alias.colorPrimaryHover);
    });

    testWidgets('disabled uses colorTextDisabled and swallows taps', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        AntApp(
          home: AntLink(
            'd',
            onPressed: () => tapped = true,
            disabled: true,
          ),
        ),
      );
      await tester.tap(find.text('d'));
      await tester.pump();
      expect(tapped, isFalse);

      final context = tester.element(find.text('d'));
      final alias = AntTheme.aliasOf(context);
      final text = tester.widget<Text>(find.text('d'));
      expect(text.style?.color, alias.colorTextDisabled);
    });
  });
}
