import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
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
}
