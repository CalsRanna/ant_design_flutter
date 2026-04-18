import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child}) => Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Overlay(
          initialEntries: [OverlayEntry(builder: (_) => child)],
        ),
      ),
    );

Future<BuildContext> _pumpHost(WidgetTester tester) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(_host(
    child: Builder(builder: (ctx) {
      capturedContext = ctx;
      return const SizedBox.shrink();
    }),
  ));
  return capturedContext;
}

void main() {
  group('AntOverlayHost — message slot', () {
    testWidgets('stacks messages vertically near top, centered',
        (tester) async {
      final ctx = await _pumpHost(tester);

      for (final key in const [
        ValueKey('msg-a'),
        ValueKey('msg-b'),
        ValueKey('msg-c'),
      ]) {
        AntOverlayManager.show(
          context: ctx,
          slot: AntOverlaySlot.message,
          builder: (_) => SizedBox(key: key, width: 100, height: 32),
        );
      }
      await tester.pumpAndSettle();

      final a = tester.getRect(find.byKey(const ValueKey('msg-a')));
      final b = tester.getRect(find.byKey(const ValueKey('msg-b')));
      final c = tester.getRect(find.byKey(const ValueKey('msg-c')));

      expect(a.top, lessThan(b.top));
      expect(b.top, lessThan(c.top));
      expect(b.top - a.bottom, closeTo(8, 0.5));
      expect(c.top - b.bottom, closeTo(8, 0.5));
      for (final rect in [a, b, c]) {
        expect(rect.center.dx, closeTo(400, 0.5));
      }
    });
  });

  group('AntOverlayHost — notification slot', () {
    testWidgets('stacks near top-right with 24 px margin', (tester) async {
      final ctx = await _pumpHost(tester);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.notification,
        builder: (_) => const SizedBox(
          key: ValueKey('notif-a'),
          width: 200,
          height: 60,
        ),
      );
      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.notification,
        builder: (_) => const SizedBox(
          key: ValueKey('notif-b'),
          width: 200,
          height: 60,
        ),
      );
      await tester.pumpAndSettle();

      final a = tester.getRect(find.byKey(const ValueKey('notif-a')));
      final b = tester.getRect(find.byKey(const ValueKey('notif-b')));

      expect(a.right, closeTo(800 - 24, 0.5));
      expect(b.right, closeTo(800 - 24, 0.5));
      expect(a.top, lessThan(b.top));
      expect(b.top - a.bottom, closeTo(8, 0.5));
    });
  });

  group('AntOverlayHost — modal slot', () {
    testWidgets('show replaces previous modal (singleton)', (tester) async {
      final ctx = await _pumpHost(tester);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
          key: ValueKey('modal-a'),
          width: 200,
          height: 120,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('modal-a')), findsOneWidget);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
          key: ValueKey('modal-b'),
          width: 200,
          height: 120,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('modal-a')), findsNothing);
      expect(find.byKey(const ValueKey('modal-b')), findsOneWidget);
    });

    testWidgets('modal content is centered', (tester) async {
      final ctx = await _pumpHost(tester);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.modal,
        builder: (_) => const SizedBox(
          key: ValueKey('m'),
          width: 200,
          height: 100,
        ),
      );
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(const ValueKey('m')));
      expect(rect.center.dx, closeTo(400, 0.5));
      expect(rect.center.dy, closeTo(300, 0.5));
    });
  });

  group('AntOverlayHost — drawer slot', () {
    testWidgets('drawer sits on the right edge', (tester) async {
      final ctx = await _pumpHost(tester);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.drawer,
        builder: (_) => const SizedBox(
          key: ValueKey('d'),
          width: 240,
          height: 600,
        ),
      );
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.byKey(const ValueKey('d')));
      expect(rect.right, closeTo(800, 0.5));
      expect(rect.top, closeTo(0, 0.5));
      expect(rect.bottom, closeTo(600, 0.5));
    });
  });
}
