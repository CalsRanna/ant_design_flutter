import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntButton', () {
    testWidgets('default renders child and fires onPressed', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              onPressed: () => tapped++,
              child: const Text('click'),
            ),
          ),
        ),
      );
      expect(find.text('click'), findsOneWidget);
      await tester.tap(find.text('click'));
      expect(tapped, 1);
    });

    testWidgets('disabled swallows taps', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              disabled: true,
              onPressed: () => tapped++,
              child: const Text('d'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('d'));
      expect(tapped, 0);
    });

    testWidgets('loading swallows taps and renders spinner', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              loading: true,
              onPressed: () => tapped++,
              child: const Text('l'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('l'));
      expect(tapped, 0);
      // Spinner child 存在（通过 CustomPaint 间接断言）
      expect(find.byType(CustomPaint), findsWidgets);
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('block=true makes width expand', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: AntButton(
                block: true,
                onPressed: () {},
                child: const Text('b'),
              ),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntButton));
      expect(size.width, 300);
    });

    testWidgets('small size → height 24', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              size: AntComponentSize.small,
              onPressed: () {},
              child: const Text('s'),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(AntButton)).height, 24);
    });

    testWidgets('large size → height 40', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              size: AntComponentSize.large,
              onPressed: () {},
              child: const Text('l'),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(AntButton)).height, 40);
    });

    testWidgets('circle shape → width = height', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Center(
            child: AntButton(
              shape: AntButtonShape.circle,
              onPressed: () {},
              child: const Text('c'),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byType(AntButton));
      expect(size.width, size.height);
    });
  });
}
