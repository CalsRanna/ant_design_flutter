import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal host with theme + overlay for AntPortal testing.
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
  group('AntTooltip', () {
    testWidgets('renders child without overlay by default', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntTooltip(
            title: 'help text',
            child: Text('hover me'),
          ),
        ),
      );

      expect(find.text('hover me'), findsOneWidget);
      expect(find.text('help text'), findsNothing);
    });

    testWidgets('shows overlay on hover', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const Center(
            child: AntTooltip(
              title: 'help text',
              child: Text('hover me'),
              mouseEnterDelay: 0,
              mouseLeaveDelay: 0,
            ),
          ),
        ),
      );

      // Hover over the child
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('hover me')));
      await tester.pump();
      await tester.pumpAndSettle();

      // Tooltip should be visible
      expect(find.text('hover me'), findsOneWidget);
      expect(find.text('help text'), findsOneWidget);
    });

    testWidgets('hides overlay when mouse leaves and delay is 0',
        (tester) async {
      await tester.pumpWidget(
        _host(
          child: const Center(
            child: AntTooltip(
              title: 'help text',
              child: Text('hover me'),
              mouseEnterDelay: 0,
              mouseLeaveDelay: 0,
            ),
          ),
        ),
      );

      // Hover in
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('hover me')));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('help text'), findsOneWidget);

      // Move mouse away
      await gesture.moveTo(const Offset(-100, -100));
      await tester.pump();
      await tester.pumpAndSettle();

      // Tooltip should be hidden
      expect(find.text('help text'), findsNothing);
    });
  });
}
