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
  group('AntModal', () {
    testWidgets('shows modal with title', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.confirm(context, title: 'Confirmation');
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

      expect(find.text('Confirmation'), findsOneWidget);
    });

    testWidgets('shows modal with content', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.confirm(
                  context,
                  title: 'Delete',
                  content: 'Are you sure?',
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

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });

    testWidgets('modal has default ok/cancel buttons', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.confirm(context, title: 'Test');
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

      expect(find.text('确定'), findsOneWidget); // okText default
      expect(find.text('取消'), findsOneWidget); // cancelText default
    });

    testWidgets('onOk is called when ok button is tapped', (tester) async {
      var okCalled = false;
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.confirm(
                  context,
                  title: 'Test',
                  onOk: () => okCalled = true,
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

      await tester.tap(find.text('确定'));
      await tester.pump();
      await tester.pump();

      expect(okCalled, isTrue);
    });

    testWidgets('onCancel is called when cancel button is tapped',
        (tester) async {
      var cancelCalled = false;
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.confirm(
                  context,
                  title: 'Test',
                  onCancel: () => cancelCalled = true,
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

      await tester.tap(find.text('取消'));
      await tester.pump();
      await tester.pump();

      expect(cancelCalled, isTrue);
    });

    testWidgets('info modal shows title and default ok text', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                AntModal.info(context, title: 'Information');
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

      expect(find.text('Information'), findsOneWidget);
      expect(find.text('知道了'), findsOneWidget); // default okText
    });
  });
}
