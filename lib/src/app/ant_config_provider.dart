import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';

/// 主题注入。包裹应用根；组件通过 `AntTheme.of(context)` 访问。
class AntConfigProvider extends InheritedWidget {
  const AntConfigProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  final AntThemeData theme;

  static AntThemeData of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<AntConfigProvider>();
    assert(
      widget != null,
      'No AntConfigProvider found. '
          'Wrap your app in AntApp or AntConfigProvider.',
    );
    return widget!.theme;
  }

  static AntThemeData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AntConfigProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(AntConfigProvider old) => theme != old.theme;
}

/// 语法糖：`AntTheme.aliasOf(context).colorPrimary` 比
/// `AntConfigProvider.of(context).alias.colorPrimary` 简短。
abstract final class AntTheme {
  static AntThemeData of(BuildContext context) =>
      AntConfigProvider.of(context);

  static AntAliasToken aliasOf(BuildContext context) => of(context).alias;
}
