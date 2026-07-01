import 'package:flutter/widgets.dart';
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntDivider', () {
    testWidgets('renders plain divider', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntDivider()));
      // Should not crash
    });
    testWidgets('renders with text', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntDivider(text: 'Section')));
      expect(find.text('Section'), findsOneWidget);
    });
  });
  group('AntSpace', () {
    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntSpace(children: [Text('A'), Text('B')])));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });
  });
  group('AntEmpty', () {
    testWidgets('renders default description', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntEmpty()));
      expect(find.text('No data'), findsOneWidget);
    });
    testWidgets('renders custom description', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntEmpty(description: 'Nothing here')));
      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
  group('AntAlert', () {
    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAlert(message: 'Info message')));
      expect(find.text('Info message'), findsOneWidget);
    });
    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAlert(message: 'Title', description: 'Detail')));
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Detail'), findsOneWidget);
    });
    testWidgets('closable shows close button', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAlert(message: 'X', closable: true)));
      expect(find.text('✕'), findsOneWidget);
    });
  });
}
