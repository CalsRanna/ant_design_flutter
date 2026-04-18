import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntCheckbox', () {
    testWidgets('tap toggles checked via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckbox(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
                label: const Text('agree'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('agree'));
      await tester.pump();
      expect(checked, isTrue);

      await tester.tap(find.text('agree'));
      await tester.pump();
      expect(checked, isFalse);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckbox(
              checked: false,
              disabled: true,
              onChanged: (_) => changed = true,
              label: const Text('x'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('x'));
      await tester.pump();
      expect(changed, isFalse);
    });

    testWidgets('renders without label', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckbox(checked: true, onChanged: (_) {}),
          ),
        ),
      );
      expect(find.byType(AntCheckbox), findsOneWidget);
    });
  });
}
