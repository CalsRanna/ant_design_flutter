import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntMenu', () {
    testWidgets('renders menu item labels', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntMenu(
            items: [
              AntMenuItemData(key: 'home', label: 'Home'),
              AntMenuItemData(key: 'about', label: 'About'),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('calls onSelect when item tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(
        AntApp(
          home: AntMenu(
            items: [
              AntMenuItemData(key: 'home', label: 'Home'),
            ],
            onSelect: (key) => selected = key,
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(selected, 'home');
    });

    testWidgets('disabled item does not trigger onSelect', (tester) async {
      String? selected;
      await tester.pumpWidget(
        AntApp(
          home: AntMenu(
            items: [
              AntMenuItemData(key: 'home', label: 'Home', disabled: true),
            ],
            onSelect: (key) => selected = key,
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(selected, isNull);
    });

    testWidgets('renders submenu expand arrow', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntMenu(
            items: [
              AntSubMenuData(
                key: 'more',
                label: 'More',
                children: [
                  AntMenuItemData(key: 'detail', label: 'Detail'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('More'), findsOneWidget);
      expect(find.text('▾'), findsOneWidget);
    });

    testWidgets('submenu expands and shows children on click', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntMenu(
            items: [
              AntSubMenuData(
                key: 'more',
                label: 'More',
                children: [
                  AntMenuItemData(key: 'detail', label: 'Detail'),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('More'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Detail'), findsOneWidget);
    });
  });
}
