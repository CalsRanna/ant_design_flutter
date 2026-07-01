import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntAutoComplete', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntAutoComplete(options: ['a', 'b'], placeholder: 'Search')));
      expect(find.text('Search'), findsOneWidget);
    });
  });
  group('AntColorPicker', () {
    testWidgets('renders colors', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntColorPicker()));
      // Should render default color swatches
    });
  });
  group('AntMentions', () {
    testWidgets('renders placeholder', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntMentions(options: ['alice', 'bob'], placeholder: '@mention')));
      expect(find.text('@mention'), findsOneWidget);
    });
  });
  group('AntWatermark', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntWatermark(text: 'DRAFT', child: Text('content'))));
      expect(find.text('content'), findsOneWidget);
    });
  });
}
