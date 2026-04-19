import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AntRadioGroup: tapping option fires onChanged with value',
    (tester) async {
      String? current;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntRadioGroup<String>(
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
      expect(current, 'b');
    },
  );

  testWidgets('AntRadioGroup disabled swallows taps', (tester) async {
    var changed = false;
    await tester.pumpWidget(
      AntApp(
        home: Center(
          child: AntRadioGroup<String>(
            disabled: true,
            options: const [AntOption(value: 'a', label: 'A')],
            value: null,
            onChanged: (_) => changed = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('A'));
    expect(changed, isFalse);
  });
}
