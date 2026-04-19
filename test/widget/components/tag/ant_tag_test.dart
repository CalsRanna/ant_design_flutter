import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTag', () {
    testWidgets('default renders child', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: AntTag(child: Text('t'))),
      );
      expect(find.text('t'), findsOneWidget);
    });

    testWidgets('closable=true + tap fires onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntTag(
              closable: true,
              onClose: () => closed = true,
              child: const Text('c'),
            ),
          ),
        ),
      );
      // 通过 GestureDetector finder 直接命中关闭按钮
      expect(find.byType(GestureDetector), findsOneWidget);
      await tester.tap(find.byType(GestureDetector));
      expect(closed, isTrue);
    });
  });

  group('AntCheckableTag', () {
    testWidgets('tap toggles via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckableTag(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
                child: const Text('k'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('k'));
      await tester.pump();
      expect(checked, isTrue);
    });
  });
}
