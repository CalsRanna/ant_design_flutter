import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 让 AntPortal 能拿到 Overlay 的最小 host。
Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => child),
        ],
      ),
    ),
  );
}

void main() {
  group('AntPortal — lifecycle', () {
    testWidgets('overlayBuilder not invoked when visible: false',
        (tester) async {
      var built = 0;
      await tester.pumpWidget(
        _host(
          child: Center(
            child: AntPortal(
              overlayBuilder: (_) {
                built++;
                return const SizedBox(width: 20, height: 20);
              },
              child: const SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      );
      expect(built, 0);
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });

    testWidgets('overlay inserts when visible flips to true', (tester) async {
      late StateSetter setState0;
      var visible = false;
      await tester.pumpWidget(
        _host(
          child: StatefulBuilder(
            builder: (context, setState) {
              setState0 = setState;
              return Center(
                child: AntPortal(
                  visible: visible,
                  overlayBuilder: (_) => const ColoredBox(
                    key: ValueKey('tooltip-content'),
                    color: Color(0xFFFF0000),
                    child: SizedBox(width: 20, height: 20),
                  ),
                  child: const SizedBox(width: 10, height: 10),
                ),
              );
            },
          ),
        ),
      );
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);

      setState0(() => visible = true);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tooltip-content')), findsOneWidget);

      setState0(() => visible = false);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });

    testWidgets('overlay removed on dispose', (tester) async {
      await tester.pumpWidget(
        _host(
          child: Center(
            child: AntPortal(
              visible: true,
              overlayBuilder: (_) => const ColoredBox(
                key: ValueKey('tooltip-content'),
                color: Color(0xFFFF0000),
                child: SizedBox(width: 20, height: 20),
              ),
              child: const SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tooltip-content')), findsOneWidget);

      // Replace the entire tree — AntPortal is disposed.
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tooltip-content')), findsNothing);
    });
  });

  group('AntPortal — placement geometry', () {
    const overlayKey = ValueKey('overlay');
    const targetKey = ValueKey('target');

    Widget buildCase(AntPlacement placement, {Offset offset = Offset.zero}) =>
        _host(
          child: Center(
            child: AntPortal(
              visible: true,
              placement: placement,
              offset: offset,
              autoAdjustOverflow: false,
              overlayBuilder: (_) => const SizedBox(
                key: overlayKey,
                width: 40,
                height: 20,
              ),
              child: const SizedBox(
                key: targetKey,
                width: 60,
                height: 30,
              ),
            ),
          ),
        );

    testWidgets('top: overlay bottom edge aligns with target top',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.top));
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.bottom, closeTo(target.top, 0.5));
      expect(overlay.center.dx, closeTo(target.center.dx, 0.5));
    });

    testWidgets(
        'bottomRight: overlay top-right aligns with target bottom-right',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.bottomRight));
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.top, closeTo(target.bottom, 0.5));
      expect(overlay.right, closeTo(target.right, 0.5));
    });

    testWidgets('left: overlay right edge aligns with target left',
        (tester) async {
      await tester.pumpWidget(buildCase(AntPlacement.left));
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.right, closeTo(target.left, 0.5));
      expect(overlay.center.dy, closeTo(target.center.dy, 0.5));
    });

    testWidgets('offset shifts overlay', (tester) async {
      await tester.pumpWidget(
        buildCase(AntPlacement.top, offset: const Offset(0, -8)),
      );
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(targetKey));
      final overlay = tester.getRect(find.byKey(overlayKey));
      expect(overlay.bottom, closeTo(target.top - 8, 0.5));
    });
  });
}
