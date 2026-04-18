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
  await tester.pumpWidget(
    _host(
      child: Builder(
        builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return capturedContext;
}

void main() {
  group('AntOverlayManager — show/dismiss', () {
    testWidgets('shows and dismisses a message entry', (tester) async {
      final ctx = await _pumpHost(tester);

      final handle = AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.message,
        builder: (_) => const ColoredBox(
          key: ValueKey('msg-1'),
          color: Color(0xFFFFFFFF),
          child: SizedBox(width: 100, height: 30),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('msg-1')), findsOneWidget);

      AntOverlayManager.dismiss(handle);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('msg-1')), findsNothing);
    });

    testWidgets('dismiss is idempotent on already-dismissed handle', (
      tester,
    ) async {
      final ctx = await _pumpHost(tester);

      final handle = AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('msg'), height: 10),
      );
      await tester.pumpAndSettle();
      AntOverlayManager.dismiss(handle);
      await tester.pumpAndSettle();
      expect(() => AntOverlayManager.dismiss(handle), returnsNormally);
    });

    testWidgets('dismissAll clears a slot', (tester) async {
      final ctx = await _pumpHost(tester);

      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('a'), height: 10),
      );
      AntOverlayManager.show(
        context: ctx,
        slot: AntOverlaySlot.message,
        builder: (_) => const SizedBox(key: ValueKey('b'), height: 10),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('a')), findsOneWidget);
      expect(find.byKey(const ValueKey('b')), findsOneWidget);

      AntOverlayManager.dismissAll(AntOverlaySlot.message, ctx);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('a')), findsNothing);
      expect(find.byKey(const ValueKey('b')), findsNothing);
    });
  });
}
