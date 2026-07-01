import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntInputNumber', () {
    testWidgets('renders value', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntInputNumber(value: 5)));
      expect(find.text('5'), findsOneWidget);
    });
    testWidgets('increments on plus', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntInputNumber(value: 5)));
      await tester.tap(find.text('+')); await tester.pump();
      expect(find.text('6'), findsOneWidget);
    });
    testWidgets('decrements on minus', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntInputNumber(value: 5)));
      await tester.tap(find.text('-')); await tester.pump();
      expect(find.text('4'), findsOneWidget);
    });
  });
  group('AntSlider', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntSlider(value: 50)));
    });
  });
  group('AntRate', () {
    testWidgets('renders stars', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntRate(value: 3)));
      expect(find.text('★'), findsNWidgets(3));
      expect(find.text('☆'), findsNWidgets(2));
    });
  });
}
