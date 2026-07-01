import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSpin', () {
    testWidgets('renders', (tester) async { await tester.pumpWidget(const AntApp(home: AntSpin())); });
    testWidgets('with child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntSpin(child: Text('c'), spinning: false)));
      expect(find.text('c'), findsOneWidget);
    });
  });
  group('AntProgress', () {
    testWidgets('renders percent', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntProgress(percent: 50)));
      expect(find.text('50%'), findsOneWidget);
    });
  });
  group('AntBadge', () {
    testWidgets('count', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntBadge(count: 5, child: Text('x'))));
      expect(find.text('5'), findsOneWidget);
    });
    testWidgets('hides zero', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntBadge(count: 0, child: Text('x'))));
      expect(find.text('0'), findsNothing);
    });
    testWidgets('overflow', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntBadge(count: 100, overflowCount: 99, child: Text('x'))));
      expect(find.text('99+'), findsOneWidget);
    });
  });
  group('AntAvatar', () {
    testWidgets('text', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAvatar(text: 'Bob')));
      expect(find.text('B'), findsOneWidget);
    });
  });
}
