import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 锚点。对齐 AntD v5 `Anchor`。
class AntAnchor extends StatelessWidget {
  const AntAnchor({required this.items, super.key, this.onClick});
  final List<AntAnchorItem> items; final ValueChanged<String>? onClick;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final item in items)
        GestureDetector(
          onTap: () => onClick?.call(item.key),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(item.title, style: TextStyle(color: alias.colorPrimary, fontSize: alias.fontSize))),
        ),
    ]);
  }
}

class AntAnchorItem {
  const AntAnchorItem({required this.key, required this.title});
  final String key; final String title;
}
