import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSwitch', () {
    testWidgets('tap toggles via onChanged', (tester) async {
      var checked = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => AntApp(
            home: Center(
              child: AntSwitch(
                checked: checked,
                onChanged: (v) => setState(() => checked = v),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      await tester.pumpAndSettle();
      expect(checked, isTrue);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              disabled: true,
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      expect(changed, isFalse);
    });

    testWidgets('loading swallows taps and renders spinner', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              loading: true,
              onChanged: (_) => changed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AntSwitch));
      expect(changed, isFalse);
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('middle renders 28x16', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(checked: false, onChanged: (_) {}),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntSwitch));
      expect(size.width, 28);
      expect(size.height, 16);
    });

    testWidgets('small renders 22x14', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntSwitch(
              checked: false,
              size: AntComponentSize.small,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntSwitch));
      expect(size.width, 22);
      expect(size.height, 14);
    });
  });
}
