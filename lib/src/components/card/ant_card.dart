import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 卡片。对齐 AntD v5 `Card`。
class AntCard extends StatelessWidget {
  const AntCard({
    required this.child,
    super.key,
    this.title,
    this.extra,
    this.actions,
  });

  final Widget child;
  final Widget? title;
  final Widget? extra;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      decoration: BoxDecoration(
        color: alias.colorBackgroundContainer,
        borderRadius: BorderRadius.circular(alias.borderRadius),
        border: Border.all(color: alias.colorBorderSecondary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || extra != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: alias.fontSize, fontWeight: FontWeight.w600, color: alias.colorText),
                        child: title!,
                      ),
                    ),
                  if (extra != null) extra!,
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
          if (actions != null && actions!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: alias.colorSplit)),
              ),
              child: Row(children: actions!.map((a) => Expanded(child: a)).toList()),
            ),
        ],
      ),
    );
  }
}
