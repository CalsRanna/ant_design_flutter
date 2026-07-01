import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: AntConfigProvider(
        theme: AntThemeData(),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (_) => child),
          ],
        ),
      ),
    ),
  );
}

void main() {
  group('AntDatePicker', () {
    testWidgets('renders placeholder when no date selected', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntDatePicker(placeholder: 'Pick a date'),
        ),
      );

      expect(find.text('Pick a date'), findsOneWidget);
    });

    testWidgets('shows formatted date when value is set', (tester) async {
      await tester.pumpWidget(
        _host(
          child: AntDatePicker(
            value: DateTime(2026, 7, 1),
          ),
        ),
      );

      expect(find.text('2026-07-01'), findsOneWidget);
    });

    testWidgets('opens calendar on tap', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntDatePicker(placeholder: 'Date'),
        ),
      );

      await tester.tap(find.text('Date'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Calendar header should be visible with month/year
      expect(find.textContaining('年'), findsOneWidget);
      expect(find.textContaining('月'), findsOneWidget);
    });

    testWidgets('navigates months with arrows', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntDatePicker(placeholder: 'Date'),
        ),
      );

      await tester.tap(find.text('Date'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Tap next month arrow
      await tester.tap(find.text('›'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      // Should still show calendar
      expect(find.textContaining('年'), findsOneWidget);

      // Tap prev month arrow twice (to go back)
      await tester.tap(find.text('‹'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.tap(find.text('‹'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('年'), findsOneWidget);
    });
  });
}
