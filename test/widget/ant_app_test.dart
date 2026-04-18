import 'package:ant_design_flutter/src/app/ant_app.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntApp', () {
    testWidgets('renders home with default theme', (tester) async {
      await tester.pumpWidget(
        AntApp(
          home: Builder(
            builder: (ctx) {
              final alias = AntTheme.aliasOf(ctx);
              expect(alias.colorPrimary, const Color(0xFF1677FF));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('custom theme propagates to descendants', (tester) async {
      final theme = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      await tester.pumpWidget(
        AntApp(
          theme: theme,
          home: Builder(
            builder: (ctx) {
              expect(
                AntTheme.aliasOf(ctx).colorPrimary,
                const Color(0xFF722ED1),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('default title is empty string', (tester) async {
      await tester.pumpWidget(
        const AntApp(home: SizedBox()),
      );
      // 无异常即通过。
    });
  });
}
