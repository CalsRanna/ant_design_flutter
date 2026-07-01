import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTabs', () {
    testWidgets('renders tab labels', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntTabs(
            tabs: [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(key: 'b', label: 'Tab B', child: Text('Content B')),
            ],
          ),
        ),
      );

      expect(find.text('Tab A'), findsOneWidget);
      expect(find.text('Tab B'), findsOneWidget);
    });

    testWidgets('shows content of first tab by default', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntTabs(
            tabs: [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(key: 'b', label: 'Tab B', child: Text('Content B')),
            ],
          ),
        ),
      );

      expect(find.text('Content A'), findsOneWidget);
      expect(find.text('Content B'), findsNothing);
    });

    testWidgets('switches content on tab tap', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntTabs(
            tabs: [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(key: 'b', label: 'Tab B', child: Text('Content B')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Tab B'));
      await tester.pump();

      expect(find.text('Content A'), findsNothing);
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('onChange is called on tab switch', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        AntApp(
          home: AntTabs(
            tabs: const [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(key: 'b', label: 'Tab B', child: Text('Content B')),
            ],
            onChange: (key) => changedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('Tab B'));
      await tester.pump();

      expect(changedKey, 'b');
    });

    testWidgets('disabled tab cannot be tapped', (tester) async {
      String? changedKey;
      await tester.pumpWidget(
        AntApp(
          home: AntTabs(
            tabs: const [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(
                key: 'b',
                label: 'Tab B',
                child: Text('Content B'),
                disabled: true,
              ),
            ],
            onChange: (key) => changedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('Tab B'));
      await tester.pump();

      // onChange should not be called
      expect(changedKey, isNull);
      // Content should still show first tab
      expect(find.text('Content A'), findsOneWidget);
    });

    testWidgets('activeKey controls active tab externally', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntTabs(
            activeKey: 'b',
            tabs: [
              AntTabItem(key: 'a', label: 'Tab A', child: Text('Content A')),
              AntTabItem(key: 'b', label: 'Tab B', child: Text('Content B')),
            ],
          ),
        ),
      );

      expect(find.text('Content A'), findsNothing);
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        const AntApp(
          home: AntTabs(
            tabs: [
              AntTabItem(
                key: 'a',
                label: 'Tab A',
                child: Text('Content A'),
                icon: Text('[icon]'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('[icon]'), findsOneWidget);
    });
  });
}
