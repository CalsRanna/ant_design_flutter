import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _DependencyProbe extends StatefulWidget {
  const _DependencyProbe();

  @override
  State<_DependencyProbe> createState() => _DependencyProbeState();
}

class _DependencyProbeState extends State<_DependencyProbe> {
  int didChangeCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AntConfigProvider.of(context);
    didChangeCount++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  group('AntConfigProvider.of', () {
    testWidgets('returns nearest theme', (tester) async {
      final theme = AntThemeData();
      AntThemeData? captured;
      await tester.pumpWidget(
        AntConfigProvider(
          theme: theme,
          child: Builder(
            builder: (ctx) {
              captured = AntConfigProvider.of(ctx);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(captured, same(theme));
    });

    testWidgets('asserts when no provider in tree', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (ctx) {
            expect(() => AntConfigProvider.of(ctx), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });
  });

  group('AntConfigProvider.maybeOf', () {
    testWidgets('returns null when no provider in tree', (tester) async {
      AntThemeData? captured;
      await tester.pumpWidget(
        Builder(
          builder: (ctx) {
            captured = AntConfigProvider.maybeOf(ctx);
            return const SizedBox();
          },
        ),
      );
      expect(captured, isNull);
    });
  });

  group('nested override', () {
    testWidgets('inner provider replaces outer', (tester) async {
      final outer = AntThemeData();
      final inner = AntThemeData(
        seed: const AntSeedToken(colorPrimary: Color(0xFF722ED1)),
      );
      AntThemeData? seen;
      await tester.pumpWidget(
        AntConfigProvider(
          theme: outer,
          child: AntConfigProvider(
            theme: inner,
            child: Builder(
              builder: (ctx) {
                seen = AntConfigProvider.of(ctx);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(seen!.seed.colorPrimary, const Color(0xFF722ED1));
    });
  });

  group('updateShouldNotify', () {
    testWidgets('notifies dependents only when theme changes', (tester) async {
      Widget buildTree(AntThemeData theme) {
        return AntConfigProvider(
          theme: theme,
          child: const _DependencyProbe(),
        );
      }

      await tester.pumpWidget(buildTree(AntThemeData()));
      final state = tester.state<_DependencyProbeState>(
        find.byType(_DependencyProbe),
      );
      expect(state.didChangeCount, 1);

      await tester.pumpWidget(buildTree(AntThemeData()));
      expect(
        state.didChangeCount,
        1,
        reason: 'equal theme must not trigger didChangeDependencies',
      );

      await tester.pumpWidget(
        buildTree(
          AntThemeData(
            seed: const AntSeedToken(colorPrimary: Color(0xFF000000)),
          ),
        ),
      );
      expect(state.didChangeCount, 2);
    });
  });

  group('_DependencyProbe (test helper check)', () {
    testWidgets('increments didChangeCount per notification', (tester) async {
      final theme = AntThemeData();
      await tester.pumpWidget(
        AntConfigProvider(theme: theme, child: const _DependencyProbe()),
      );
      final state = tester.state<_DependencyProbeState>(
        find.byType(_DependencyProbe),
      );
      expect(state.didChangeCount, 1);
    });
  });

  group('AntTheme syntax sugar', () {
    testWidgets('aliasOf shortcut works', (tester) async {
      final theme = AntThemeData();
      await tester.pumpWidget(
        AntConfigProvider(
          theme: theme,
          child: Builder(
            builder: (ctx) {
              expect(AntTheme.of(ctx), same(theme));
              expect(AntTheme.aliasOf(ctx), same(theme.alias));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
