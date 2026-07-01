import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntRow/AntCol', () {
    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntRow(children: [AntCol(child: Text('A')), AntCol(child: Text('B'))])));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });
  });
  group('AntLayout', () {
    testWidgets('renders layout', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntLayout(child: Column(children: [
        AntHeader(child: Text('H')), AntContent(child: Text('C')), AntFooter(child: Text('F')),
      ]))));
      expect(find.text('H'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
    });
  });
  group('AntList', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(AntApp(home: AntList(
        dataSource: ['a', 'b', 'c'], header: const Text('header'),
        renderItem: (item, i) => Text('$item'),
      )));
      expect(find.text('a'), findsOneWidget);
      expect(find.text('header'), findsOneWidget);
    });
  });
  group('AntTimeline', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntTimeline(items: [
        AntTimelineItem(title: 'Step 1'), AntTimelineItem(title: 'Step 2'),
      ])));
      expect(find.text('Step 1'), findsOneWidget);
    });
  });
  group('AntDescriptions', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntDescriptions(items: [
        AntDescriptionItem(label: 'Name', value: 'Alice'),
      ])));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });
  });
}
