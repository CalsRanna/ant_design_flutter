import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 结果页。对齐 AntD v5 `Result`。
class AntResult extends StatelessWidget {
  const AntResult({required this.title, super.key, this.subtitle, this.status = AntResultStatus.info, this.extra, this.children});
  final String title; final String? subtitle; final AntResultStatus status; final Widget? extra; final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final (String icon, Color color) = switch (status) {
      AntResultStatus.success => ('✓', alias.colorSuccess),
      AntResultStatus.error => ('✕', alias.colorError),
      AntResultStatus.warning => ('⚠', alias.colorWarning),
      AntResultStatus.info => ('ℹ', alias.colorPrimary),
    };

    return Center(
      child: Padding(padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(icon, style: TextStyle(fontSize: 48, color: color)),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: alias.colorText)),
          if (subtitle != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(subtitle!, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize))),
          if (extra != null) Padding(padding: const EdgeInsets.only(top: 24), child: extra!),
          if (children != null) Padding(padding: const EdgeInsets.only(top: 16), child: Column(children: children!)),
        ]),
      ),
    );
  }
}

enum AntResultStatus { success, error, warning, info }
