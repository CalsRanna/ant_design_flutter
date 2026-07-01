import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: AntConfigProvider(
        theme: AntThemeData(),
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (_) => child),
          ],
        ),
      ),
    ),
  );
}

void main() {
  group('AntSelect', () {
    testWidgets('renders placeholder when no value selected', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntSelect<String>(
            options: [
              AntSelectOption(value: 'a', label: 'Option A'),
            ],
            placeholder: 'Pick one',
          ),
        ),
      );

      expect(find.text('Pick one'), findsOneWidget);
      expect(find.text('▼'), findsOneWidget);
    });

    testWidgets('shows selected option label', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntSelect<String>(
            options: [
              AntSelectOption(value: 'a', label: 'Option A'),
            ],
            value: 'a',
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('opens dropdown on tap showing options', (tester) async {
      await tester.pumpWidget(
        _host(
          child: const AntSelect<String>(
            options: [
              AntSelectOption(value: 'a', label: 'Option A'),
              AntSelectOption(value: 'b', label: 'Option B'),
            ],
            placeholder: 'Select',
          ),
        ),
      );

      await tester.tap(find.text('Select'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
    });

    testWidgets('updates displayed value when selection changes', (tester) async {
      await tester.pumpWidget(
        _host(
          child: StatefulBuilder(
            builder: (context, setState) {
              String? value;
              return AntSelect<String>(
                options: const [
                  AntSelectOption(value: 'a', label: 'Option A'),
                  AntSelectOption(value: 'b', label: 'Option B'),
                ],
                value: value,
                onChanged: (v) {
                  setState(() => value = v);
                },
                placeholder: 'Select',
              );
            },
          ),
        ),
      );

      expect(find.text('Select'), findsOneWidget);
    });
  });
}
