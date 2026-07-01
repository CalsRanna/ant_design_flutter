import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntTable', () {
    final data = [
      {'name': 'Alice', 'age': 30, 'city': 'Beijing'},
      {'name': 'Bob', 'age': 25, 'city': 'Shanghai'},
      {'name': 'Charlie', 'age': 35, 'city': 'Shenzhen'},
    ];

    testWidgets('renders column headers and data', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntTable(
            columns: const [
              AntColumn(title: 'Name', dataIndex: 'name'),
              AntColumn(title: 'Age', dataIndex: 'age'),
            ],
            data: data,
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
    });

    testWidgets('shows sort indicator on sortable column', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntTable(
            columns: const [
              AntColumn(title: 'Name', dataIndex: 'name'),
              AntColumn(
                title: 'Age',
                dataIndex: 'age',
                sorter: _compareAge,
              ),
            ],
            data: data,
          ),
        ),
      );

      expect(find.text('⇅'), findsOneWidget);
    });

    testWidgets('clicking sortable header toggles sort', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntTable(
            columns: const [
              AntColumn(title: 'Name', dataIndex: 'name'),
              AntColumn(
                title: 'Age',
                dataIndex: 'age',
                sorter: _compareAge,
              ),
            ],
            data: data,
          ),
        ),
      );

      // Click Age header to sort ascending
      await tester.tap(find.text('Age'));
      await tester.pump();

      expect(find.text('▲'), findsOneWidget);
    });

    testWidgets('custom render builds custom widget', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: AntTable(
            columns: const [
              AntColumn(title: 'Name', dataIndex: 'name'),
              AntColumn(
                title: 'Age',
                dataIndex: 'age',
                render: _renderAge,
              ),
            ],
            data: data,
          ),
        ),
      );

      // Custom render should show "X years old"
      expect(find.text('30 years'), findsOneWidget);
    });
  });
}

int _compareAge(Map<String, dynamic> a, Map<String, dynamic> b) {
  final ageA = a['age'] as int;
  final ageB = b['age'] as int;
  return ageA.compareTo(ageB);
}

Widget _renderAge(dynamic value, Map<String, dynamic> record) {
  return Text('$value years');
}
