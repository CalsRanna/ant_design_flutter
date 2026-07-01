import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntCarousel', () {
    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntCarousel(children: [Text('A'), Text('B')])));
      expect(find.text('A'), findsOneWidget);
    });
  });
  group('AntCascader', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntCascader(options: [AntCascaderOption(label: 'A', value: 'a')], placeholder: 'Select')));
      expect(find.text('Select'), findsOneWidget);
    });
  });
  group('AntTransfer', () {
    testWidgets('renders titles', (tester) async {
      await tester.pumpWidget(AntApp(home: AntTransfer(
        dataSource: const [AntTransferItem(key: '1', title: 'Item 1')], targetKeys: const [], onChange: (_, __) {},
        titles: const ['Source', 'Target'],
      )));
      expect(find.text('Source'), findsOneWidget);
    });
  });
  group('AntTreeSelect', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntTreeSelect(treeData: [AntTreeSelectNode(label: 'A', value: 'a')], placeholder: 'Pick')));
      expect(find.text('Pick'), findsOneWidget);
    });
  });
}
