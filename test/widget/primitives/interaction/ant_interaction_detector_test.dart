import 'package:ant_design_flutter/ant_design_flutter.dart';
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
}
