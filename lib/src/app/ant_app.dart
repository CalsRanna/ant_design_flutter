import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/theme_data.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 应用根。
///
/// 极小壳：`AntConfigProvider + WidgetsApp`。不带 Navigator routes、
/// Localizations、全局 Overlay host。这些将在 Phase 2+ 的独立能力里加。
/// 需要多页路由的用户可直接用 `WidgetsApp` + `AntConfigProvider`。
class AntApp extends StatelessWidget {
  const AntApp({
    required this.home,
    super.key,
    this.theme,
    this.title = '',
    this.color,
  });

  /// 传 `null` 使用默认 `AntThemeData()`（默认 seed + DefaultAlgorithm）。
  /// 由于 `AntThemeData` 的构造体调了方法，不能是 `const`，
  /// 因此默认值以 nullable 形式表达并在 build 时懒惰创建。
  final AntThemeData? theme;
  final Widget home;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = theme ?? AntThemeData();
    return AntConfigProvider(
      theme: resolvedTheme,
      child: WidgetsApp(
        title: title,
        color: color ?? resolvedTheme.alias.colorPrimary,
        textStyle: TextStyle(
          fontFamily: resolvedTheme.seed.fontFamily,
          fontSize: resolvedTheme.seed.fontSize,
          color: resolvedTheme.alias.colorText,
        ),
        home: home,
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (ctx, _, _) => builder(ctx),
        ),
      ),
    );
  }
}
