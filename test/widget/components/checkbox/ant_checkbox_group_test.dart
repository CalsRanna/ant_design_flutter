import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntCheckboxGroup', () {
    testWidgets('renders one checkbox per option', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckboxGroup<String>(
              options: const [
                AntOption(value: 'a', label: 'A'),
                AntOption(value: 'b', label: 'B'),
                AntOption(value: 'c', label: 'C'),
              ],
              value: const ['a'],
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(AntCheckbox), findsNWidgets(3));
    });

    testWidgets('tapping option emits updated list', (tester) async {
      var current = <String>['a'];
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntCheckboxGroup<String>(
                options: const [
                  AntOption(value: 'a', label: 'A'),
                  AntOption(value: 'b', label: 'B'),
                ],
                value: current,
                onChanged: (v) => setState(() => current = v),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(current, unorderedEquals(['a', 'b']));

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(current, ['b']);
    });

    testWidgets('disabled group swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntCheckboxGroup<String>(
              disabled: true,
              options: const [AntOption(value: 'a', label: 'A')],
              value: const [],
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, isFalse);
    });
  });
}
