import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 穿梭框（简版）。对齐 AntD v5 `Transfer`。
class AntTransfer extends StatefulWidget {
  const AntTransfer({
    required this.dataSource,
    required this.targetKeys,
    required this.onChange,
    super.key,
    this.titles = const ['源', '目标'],
  });
  final List<AntTransferItem> dataSource;
  final List<String> targetKeys;
  final void Function(List<String> targetKeys, String direction) onChange;
  final List<String> titles;

  @override
  State<AntTransfer> createState() => _AntTransferState();
}

class _AntTransferState extends State<AntTransfer> {
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sourceItems = widget.dataSource.where((d) => !widget.targetKeys.contains(d.key)).toList();
    final targetItems = widget.dataSource.where((d) => widget.targetKeys.contains(d.key)).toList();

    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Panel(title: widget.titles[0], items: sourceItems, alias: alias, onTransfer: (keys) => widget.onChange([...widget.targetKeys, ...keys], 'right')),
      const SizedBox(width: 8),
      Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(4)),
          child: const Text('→'))),
        const SizedBox(height: 8),
        GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(4)),
          child: const Text('←'))),
      ])),
      const SizedBox(width: 8),
      _Panel(title: widget.titles[1], items: targetItems, alias: alias, onTransfer: (keys) => widget.onChange(widget.targetKeys.where((k) => !keys.contains(k)).toList(), 'left')),
    ]);
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.items, required this.alias, required this.onTransfer});
  final String title; final List<AntTransferItem> items; final AntAliasToken alias; final ValueChanged<List<String>> onTransfer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: alias.colorSplit))),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: alias.colorText))),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('暂无数据'))
              : ListView(shrinkWrap: true, children: items.map((item) =>
                  Container(padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: alias.colorSplit))),
                    child: Text(item.title, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize - 1))),
          ).toList()),
        ),
      ]),
    );
  }
}

class AntTransferItem {
  const AntTransferItem({required this.key, required this.title});
  final String key; final String title;
}
