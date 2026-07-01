import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntSegmented', () {
    testWidgets('renders options', (tester) async {
      await tester.pumpWidget(AntApp(home: AntSegmented<String>(
        options: const [AntSegmentedOption(value: 'a', label: 'A'), AntSegmentedOption(value: 'b', label: 'B')],
        value: 'a', onChanged: (_) {},
      )));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });
  });
  group('AntStatistic', () {
    testWidgets('renders title and value', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntStatistic(title: 'Sales', value: 12345)));
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('12345'), findsOneWidget);
    });
  });
  group('AntFloatButton', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(AntApp(home: AntFloatButton(icon: const Text('+'), onTap: () {})));
      expect(find.text('+'), findsOneWidget);
    });
  });
}
