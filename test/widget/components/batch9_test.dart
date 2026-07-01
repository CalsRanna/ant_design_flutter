import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntBreadcrumb', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntBreadcrumb(items: [
        AntBreadcrumbItem(title: 'Home'), AntBreadcrumbItem(title: 'Page'),
      ])));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Page'), findsOneWidget);
      expect(find.text('/'), findsOneWidget);
    });
  });
  group('AntDropdown', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntDropdown(
        overlay: [AntDropdownItem(title: 'Item 1')],
        child: Text('trigger'),
      )));
      expect(find.text('trigger'), findsOneWidget);
    });
  });
  group('AntPagination', () {
    testWidgets('renders page numbers', (tester) async {
      await tester.pumpWidget(AntApp(home: AntPagination(current: 1, total: 50, onChange: (_) {})));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });
    testWidgets('hides when single page', (tester) async {
      await tester.pumpWidget(AntApp(home: AntPagination(current: 1, total: 5, onChange: (_) {})));
      expect(find.text('1'), findsNothing);
    });
  });
  group('AntSteps', () {
    testWidgets('renders step titles', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntSteps(current: 0, items: [
        AntStepItem(title: 'Step 1'), AntStepItem(title: 'Step 2'),
      ])));
      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Step 2'), findsOneWidget);
    });
  });
}
