import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTree', () {
    testWidgets('renders nodes', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntTree(treeData: [AntTreeNode(title: 'Root', key: '1')])));
      expect(find.text('Root'), findsOneWidget);
    });
  });
  group('AntResult', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntResult(title: 'Done!', status: AntResultStatus.success)));
      expect(find.text('Done!'), findsOneWidget);
    });
  });
  group('AntCalendar', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntCalendar()));
    });
  });
  group('AntTimePicker', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntTimePicker(placeholder: 'Pick time')));
      expect(find.text('Pick time'), findsOneWidget);
    });
  });
  group('AntUpload', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntUpload(child: Text('Upload'))));
      expect(find.text('Upload'), findsOneWidget);
    });
  });
  group('AntAnchor', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAnchor(items: [AntAnchorItem(key: '1', title: 'Section 1')])));
      expect(find.text('Section 1'), findsOneWidget);
    });
  });
  group('AntAffix', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAffix(child: Text('Sticky'))));
      expect(find.text('Sticky'), findsOneWidget);
    });
  });
  group('AntBackTop', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(const AntApp(home: Stack(children: [AntBackTop()])));
    });
  });
}
