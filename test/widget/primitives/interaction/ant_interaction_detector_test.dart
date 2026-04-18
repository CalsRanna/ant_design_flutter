import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntInteractionDetector — default render', () {
    testWidgets('builder receives empty states initially', (tester) async {
      Set<WidgetState>? observed;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            builder: (context, states) {
              observed = states;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      expect(observed, isNotNull);
      expect(observed, isEmpty);
    });

    testWidgets('builder receives {disabled} when enabled: false',
        (tester) async {
      Set<WidgetState>? observed;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            enabled: false,
            builder: (context, states) {
              observed = states;
              return const SizedBox(width: 10, height: 10);
            },
          ),
        ),
      );
      expect(observed, {WidgetState.disabled});
    });
  });

  group('AntInteractionDetector — hover', () {
    testWidgets('states include hovered while pointer is inside',
        (tester) async {
      var captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              builder: (context, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(captured, contains(WidgetState.hovered));

      await gesture.moveTo(Offset.zero);
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.hovered)));
    });

    testWidgets('onHover fires once per transition', (tester) async {
      final transitions = <bool>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onHover: transitions.add,
              builder: (_, _) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();

      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      await gesture.moveBy(const Offset(1, 1));
      await tester.pump();
      await gesture.moveTo(Offset.zero);
      await tester.pump();

      expect(transitions, <bool>[true, false]);
    });

    testWidgets('hover suppressed when disabled', (tester) async {
      final transitions = <bool>[];
      var captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              enabled: false,
              onHover: transitions.add,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();

      expect(transitions, isEmpty);
      expect(captured, isNot(contains(WidgetState.hovered)));
      expect(captured, contains(WidgetState.disabled));
    });
  });

  group('AntInteractionDetector — tap & pressed', () {
    testWidgets('pressed state toggles around tap', (tester) async {
      final snapshots = <Set<WidgetState>>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () {},
              builder: (_, states) {
                snapshots.add(Set.of(states));
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(snapshots.last, contains(WidgetState.pressed));

      await gesture.up();
      await tester.pump();
      expect(snapshots.last, isNot(contains(WidgetState.pressed)));
    });

    testWidgets('onTap fires when enabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () => taps++,
              builder: (_, _) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SizedBox));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('onTap suppressed when disabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              enabled: false,
              onTap: () => taps++,
              builder: (_, _) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SizedBox));
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('pressed clears on tap cancel', (tester) async {
      var taps = 0;
      var captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              onTap: () => taps++,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(captured, contains(WidgetState.pressed));

      await gesture.cancel();
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.pressed)));
      expect(taps, 0);
    });

    testWidgets('pressed clears when enabled flips to false mid-press',
        (tester) async {
      var captured = <WidgetState>{};
      Widget buildApp({required bool enabled}) => Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: AntInteractionDetector(
                enabled: enabled,
                onTap: () {},
                builder: (_, states) {
                  captured = states;
                  return const SizedBox(width: 50, height: 50);
                },
              ),
            ),
          );

      await tester.pumpWidget(buildApp(enabled: true));
      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(SizedBox)));
      await tester.pump();
      expect(captured, contains(WidgetState.pressed));

      // disable while still pressed — pressed must clear
      await tester.pumpWidget(buildApp(enabled: false));
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.pressed)));
      expect(captured, contains(WidgetState.disabled));

      await gesture.up();
    });
  });

  group('AntInteractionDetector — focus & keyboard', () {
    testWidgets('focused state tracks FocusNode', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var captured = <WidgetState>{};
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              focusNode: node,
              builder: (_, states) {
                captured = states;
                return const SizedBox(width: 50, height: 50);
              },
            ),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      expect(captured, contains(WidgetState.focused));

      node.unfocus();
      await tester.pump();
      expect(captured, isNot(contains(WidgetState.focused)));
    });

    testWidgets('Enter and Space trigger onTap while focused',
        (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: AntInteractionDetector(
              focusNode: node,
              onTap: () => taps++,
              builder: (_, _) => const SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('focusable: false skips tab traversal', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            focusNode: node,
            focusable: false,
            builder: (_, _) => const SizedBox(width: 10, height: 10),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      expect(node.hasFocus, isFalse);
    });

    testWidgets('disabled widget drops focus and ignores key events',
        (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      var taps = 0;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AntInteractionDetector(
            focusNode: node,
            enabled: false,
            onTap: () => taps++,
            builder: (_, _) => const SizedBox(width: 10, height: 10),
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();
      expect(node.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 0);
    });
  });
}
