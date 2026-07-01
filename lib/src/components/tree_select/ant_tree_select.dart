import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 树选择（简版）。对齐 AntD v5 `TreeSelect`。
class AntTreeSelect extends StatefulWidget {
  const AntTreeSelect({required this.treeData, super.key, this.value, this.onChanged, this.placeholder = '请选择', this.multiple = false});
  final List<AntTreeSelectNode> treeData; final String? value; final ValueChanged<String>? onChanged; final String placeholder; final bool multiple;
  @override
  State<AntTreeSelect> createState() => _AntTreeSelectState();
}

class _AntTreeSelectState extends State<AntTreeSelect> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final selectedLabel = _findLabel(widget.treeData, widget.value) ?? widget.placeholder;

    return AntPortal(
      placement: AntPlacement.bottomLeft, visible: _open,
      child: GestureDetector(
        onTap: () => setState(() => _open = !_open),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
          child: Text(selectedLabel, style: TextStyle(color: widget.value != null ? alias.colorText : alias.colorTextTertiary)),
        ),
      ),
      overlayBuilder: (c) => Container(
        constraints: const BoxConstraints(maxHeight: 256),
        decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(alias.borderRadius),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final node in widget.treeData)
            _NodeItem(node: node, alias: alias, depth: 0, selected: widget.value, onSelect: (v) { widget.onChanged?.call(v); setState(() => _open = false); }),
        ]),
      ),
    );
  }

  String? _findLabel(List<AntTreeSelectNode> nodes, String? key) {
    for (final n in nodes) {
      if (n.value == key) return n.label;
      if (n.children != null) { final r = _findLabel(n.children!, key); if (r != null) return r; }
    }
    return null;
  }
}

class _NodeItem extends StatefulWidget {
  const _NodeItem({required this.node, required this.alias, required this.depth, required this.selected, required this.onSelect});
  final AntTreeSelectNode node; final AntAliasToken alias; final int depth; final String? selected; final ValueChanged<String> onSelect;
  @override
  State<_NodeItem> createState() => _NodeItemState();
}

class _NodeItemState extends State<_NodeItem> {
  bool _expanded = true;
  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.node.children != null && widget.node.children!.isNotEmpty;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(
        onTap: () {
          if (hasChildren) setState(() => _expanded = !_expanded);
          widget.onSelect(widget.node.value);
        },
        child: Container(
          padding: EdgeInsets.only(left: widget.depth * 20.0, top: 6, bottom: 6, right: 12),
          color: widget.node.value == widget.selected ? widget.alias.colorPrimaryBackground : null,
          child: Row(children: [
            if (hasChildren) Padding(padding: const EdgeInsets.only(right: 4),
              child: Text(_expanded ? '▼' : '▶', style: TextStyle(fontSize: 8, color: widget.alias.colorTextTertiary))),
            Text(widget.node.label, style: TextStyle(color: widget.alias.colorText, fontSize: widget.alias.fontSize - 1)),
          ]),
        ),
      ),
      if (hasChildren && _expanded) Column(mainAxisSize: MainAxisSize.min, children:
        widget.node.children!.map((c) => _NodeItem(node: c, alias: widget.alias, depth: widget.depth + 1, selected: widget.selected, onSelect: widget.onSelect)).toList()),
    ]);
  }
}

class AntTreeSelectNode {
  const AntTreeSelectNode({required this.label, required this.value, this.children});
  final String label; final String value; final List<AntTreeSelectNode>? children;
}
