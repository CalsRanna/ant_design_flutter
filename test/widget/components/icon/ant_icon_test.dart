import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// 测试用 IconData：跟 Flutter 内置 Icons.check 同码点，避免依赖 material。
const IconData _testIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

void main() {
  group('AntIcon', () {
    testWidgets('default middle size renders 16px', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(_testIcon),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 16);
    });

    testWidgets('small renders 14px, large renders 20px', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntIcon(_testIcon, size: AntComponentSize.small),
              AntIcon(_testIcon, size: AntComponentSize.large),
            ],
          ),
        ),
      );
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons[0].size, 14);
      expect(icons[1].size, 20);
    });

    testWidgets('color is passed through', (tester) async {
      const red = Color(0xFFFF0000);
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AntIcon(_testIcon, color: red),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, red);
    });

    testWidgets('color null defers to IconTheme.color', (tester) async {
      const blue = Color(0xFF0000FF);
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: IconTheme(
            data: IconThemeData(color: blue),
            child: AntIcon(_testIcon),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, isNull); // AntIcon 不强制 color
    });
  });
}
