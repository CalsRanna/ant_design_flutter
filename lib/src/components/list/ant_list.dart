import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 列表。对齐 AntD v5 `List`。
class AntList extends StatelessWidget {
  const AntList({required this.dataSource, required this.renderItem, super.key, this.header, this.footer, this.bordered = false});
  final List<dynamic> dataSource; final Widget Function(dynamic item, int index) renderItem;
  final Widget? header; final Widget? footer; final bool bordered;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final borderSide = BorderSide(color: alias.colorSplit);
    return Container(
      decoration: bordered ? BoxDecoration(border: Border.all(color: alias.colorBorderSecondary), borderRadius: BorderRadius.circular(alias.borderRadius)) : null,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (header != null) Container(width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: border(borderSide, top: true), child: header!),
        for (var i = 0; i < dataSource.length; i++)
          Container(width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: border(borderSide, top: i > 0 || header != null),
            child: renderItem(dataSource[i], i)),
        if (footer != null) Container(width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: border(borderSide, top: dataSource.isNotEmpty), child: footer!),
      ]),
    );
  }

  BoxDecoration border(BorderSide s, {bool top = false}) => BoxDecoration(
    border: Border(top: top ? s : BorderSide.none, bottom: BorderSide.none, left: BorderSide.none, right: BorderSide.none),
  );
}
