import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntPopover', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntPopover(title: 'T', content: 'C', child: Text('trigger'))));
      expect(find.text('trigger'), findsOneWidget);
    });
  });
  group('AntDrawer', () {
    testWidgets('opens via manager', (tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(size: Size(800, 600)),
          child: AntConfigProvider(theme: AntThemeData(),
            child: Overlay(initialEntries: [OverlayEntry(builder: (_) =>
              Builder(builder: (ctx) => GestureDetector(
                onTap: () => AntDrawer.show(ctx, title: const Text('Drawer'), child: const Text('Content')),
                child: const Text('open'),
              ))
            )]),
          ),
        ),
      ));
      await tester.tap(find.text('open')); await tester.pump(); await tester.pump(); await tester.pump();
      expect(find.text('Content'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5)); await tester.pump();
    });
  });
}
