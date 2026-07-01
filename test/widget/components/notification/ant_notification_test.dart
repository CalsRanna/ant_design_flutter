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
  group('AntNotification', () {
    testWidgets('shows notification with message', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntNotification.success(
                  context,
                  message: 'Success',
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

      expect(find.text('Success'), findsOneWidget);

      // Clean up timer
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
    });

    testWidgets('shows notification with description', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntNotification.info(
                  context,
                  message: 'Info',
                  description: 'This is additional info.',
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

      expect(find.text('Info'), findsOneWidget);
      expect(find.text('This is additional info.'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
    });

    testWidgets('shows different types', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntNotification.warning(
                  context,
                  message: 'Warning message',
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

      expect(find.text('Warning message'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
    });

    testWidgets('error notification renders', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntNotification.error(
                  context,
                  message: 'Error occurred',
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

      expect(find.text('Error occurred'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pump();
    });
  });
}
