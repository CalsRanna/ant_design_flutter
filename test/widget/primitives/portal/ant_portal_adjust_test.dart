import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child, Size size = const Size(800, 600)}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (_) => child),
        ],
      ),
    ),
  );
}

void main() {
  const overlayKey = ValueKey('overlay');
  const targetKey = ValueKey('target');

  Widget buildCase({
    required AntPlacement placement,
    required bool autoAdjustOverflow,
    required Alignment targetAlignment,
    Size overlaySize = const Size(40, 100),
  }) =>
      _host(
        child: Align(
          alignment: targetAlignment,
          child: AntPortal(
            visible: true,
            placement: placement,
            autoAdjustOverflow: autoAdjustOverflow,
            overlayBuilder: (_) => SizedBox(
              key: overlayKey,
              width: overlaySize.width,
              height: overlaySize.height,
            ),
            child: const SizedBox(
              key: targetKey,
              width: 40,
              height: 20,
            ),
          ),
        ),
      );

  testWidgets('flips top→bottom when target hugs screen top', (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.topCenter,
    ));
    await tester.pumpAndSettle();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(
      overlay.top,
      closeTo(target.bottom, 0.5),
      reason: 'should have flipped to bottom',
    );
  });

  testWidgets('does not flip when autoAdjustOverflow: false',
      (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: false,
      targetAlignment: Alignment.topCenter,
    ));
    await tester.pumpAndSettle();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(
      overlay.bottom,
      closeTo(target.top, 0.5),
      reason: 'must stay on top even when overflowing',
    );
  });

  testWidgets('flips only once per mount', (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.top,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.topCenter,
    ));
    await tester.pumpAndSettle();
    // Extra pumps must not trigger re-flipping.
    await tester.pump();
    await tester.pump();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(overlay.top, closeTo(target.bottom, 0.5));
  });

  testWidgets('flips left→right when target hugs screen left',
      (tester) async {
    await tester.pumpWidget(buildCase(
      placement: AntPlacement.left,
      autoAdjustOverflow: true,
      targetAlignment: Alignment.centerLeft,
      overlaySize: const Size(120, 20),
    ));
    await tester.pumpAndSettle();

    final target = tester.getRect(find.byKey(targetKey));
    final overlay = tester.getRect(find.byKey(overlayKey));
    expect(
      overlay.left,
      closeTo(target.right, 0.5),
      reason: 'should have flipped to right',
    );
  });
}
