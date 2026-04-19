import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntRadio', () {
    testWidgets('tap fires onChanged with value', (tester) async {
      String? picked;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntRadio<String>(
              value: 'a',
              groupValue: null,
              onChanged: (v) => picked = v,
              label: const Text('A'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      expect(picked, 'a');
    });

    testWidgets('disabled swallows taps', (tester) async {
      String? picked;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntRadio<String>(
              value: 'a',
              groupValue: null,
              disabled: true,
              onChanged: (v) => picked = v,
              label: const Text('X'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('X'));
      expect(picked, isNull);
    });
  });
}
