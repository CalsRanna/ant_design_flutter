import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 面包屑。对齐 AntD v5 `Breadcrumb`。
class AntBreadcrumb extends StatelessWidget {
  const AntBreadcrumb({required this.items, super.key, this.separator});

  final List<AntBreadcrumbItem> items;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sep = separator ?? Text('/', style: TextStyle(color: alias.colorTextTertiary, fontSize: alias.fontSize));

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: sep),
          GestureDetector(
            onTap: items[i].onClick,
            child: Text(
              items[i].title,
              style: TextStyle(
                color: i == items.length - 1 ? alias.colorTextTertiary : alias.colorPrimary,
                fontSize: alias.fontSize,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AntBreadcrumbItem {
  const AntBreadcrumbItem({required this.title, this.onClick});
  final String title;
  final VoidCallback? onClick;
}
