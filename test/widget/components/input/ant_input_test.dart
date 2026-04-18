import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/input/_clear_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntInput', () {
    testWidgets('renders placeholder when empty', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntInput(placeholder: 'name')),
      );
      expect(find.text('name'), findsOneWidget);
    });

    testWidgets('typing triggers onChanged', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(onChanged: (v) => last = v)),
      );
      await tester.enterText(find.byType(EditableText), 'hi');
      expect(last, 'hi');
    });

    testWidgets('disabled swallows input', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(disabled: true, onChanged: (v) => last = v)),
      );
      // disabled 下 EditableText.readOnly=true，tester.enterText 仍会注入，
      // 但 onChanged 不触发（因为我们内部拦截）。
      await tester.enterText(find.byType(EditableText), 'x');
      expect(last, '');
    });

    testWidgets('allowClear clears text on tap', (tester) async {
      var current = 'abc';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: AntInput(
              allowClear: true,
              value: current,
              onChanged: (v) => setState(() => current = v),
            ),
          ),
        ),
      );

      // 模拟 hover 使 clear icon 显示
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(AntInput)));
      await tester.pump();

      // 直接命中 ClearIcon widget
      expect(find.byType(ClearIcon), findsOneWidget);
      await tester.tap(find.byType(ClearIcon));
      await tester.pump();
      expect(current, '');
    });

    testWidgets('maxLength limits input', (tester) async {
      var last = '';
      await tester.pumpWidget(
        AntApp(home: AntInput(maxLength: 3, onChanged: (v) => last = v)),
      );
      await tester.enterText(find.byType(EditableText), 'abcdef');
      expect(last.length, 3);
    });
  });
}
