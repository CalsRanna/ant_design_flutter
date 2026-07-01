import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 描述列表。对齐 AntD v5 `Descriptions`。
class AntDescriptions extends StatelessWidget {
  const AntDescriptions({required this.items, super.key, this.column = 3, this.title, this.bordered = false});
  final List<AntDescriptionItem> items; final int column; final Widget? title; final bool bordered;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final rows = <List<AntDescriptionItem>>[];
    for (var i = 0; i < items.length; i += column) {
      rows.add(items.sublist(i, i + column > items.length ? items.length : i + column));
    }

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: title!),
      for (final row in rows)
        Row(children: [
          for (final item in row)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: bordered ? BoxDecoration(border: Border.all(color: alias.colorBorderSecondary)) : null,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.label, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize - 2)),
                  const SizedBox(height: 4),
                  Text(item.value ?? '', style: TextStyle(color: alias.colorText, fontSize: alias.fontSize)),
                ]),
              ),
            ),
        ]),
    ]);
  }
}

class AntDescriptionItem {
  const AntDescriptionItem({required this.label, this.value});
  final String label; final String? value;
}
