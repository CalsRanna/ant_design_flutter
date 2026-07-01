import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal host with overlay for AntOverlayManager testing.
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
  group('AntMessage', () {
    testWidgets('success shows message text', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () => AntMessage.success(context, 'Operation completed'),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      // Multiple pumps for overlay to appear
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Operation completed'), findsOneWidget);

      // Advance time past auto-dismiss to clean up timers
      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
    });

    testWidgets('error shows message text', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () => AntMessage.error(context, 'Something went wrong'),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pump();
    });

    testWidgets('message auto-dismisses after duration', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntMessage.success(
                  context,
                  'Quick message',
                  duration: const Duration(milliseconds: 100),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Quick message'), findsOneWidget);

      // Advance past auto-dismiss
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump();
      await tester.pump();

      expect(find.text('Quick message'), findsNothing);
    });

    testWidgets('loading does not auto-dismiss', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () => AntMessage.loading(context, 'Processing'),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Processing'), findsOneWidget);

      // Even after 5 seconds, loading message should still be there
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();

      expect(find.text('Processing'), findsOneWidget);
    });
  });
}
