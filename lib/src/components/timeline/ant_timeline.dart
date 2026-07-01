import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 时间线。对齐 AntD v5 `Timeline`。
class AntTimeline extends StatelessWidget {
  const AntTimeline({required this.items, super.key});
  final List<AntTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < items.length; i++)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(width: 24, child: Column(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(
                color: items[i].color ?? alias.colorPrimary, shape: BoxShape.circle,
                border: Border.all(color: alias.colorPrimaryBackground, width: 2),
              )),
              if (i < items.length - 1) Expanded(
                child: Container(width: 1, color: alias.colorSplit),
              ),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Padding(
              padding: EdgeInsets.only(top: items[i].color != null ? 0 : 0, bottom: i < items.length - 1 ? 16 : 0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(items[i].title, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize, fontWeight: FontWeight.w600)),
                if (items[i].description != null) Text(items[i].description!, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize - 2)),
              ]),
            )),
          ]),
        ),
    ]);
  }
}

class AntTimelineItem {
  const AntTimelineItem({required this.title, this.description, this.color});
  final String title; final String? description; final Color? color;
}
