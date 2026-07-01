import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 树形控件。对齐 AntD v5 `Tree`。
class AntTree extends StatefulWidget {
  const AntTree({required this.treeData, super.key, this.onSelect});
  final List<AntTreeNode> treeData; final ValueChanged<String>? onSelect;
  @override
  State<AntTree> createState() => _AntTreeState();
}

class _AntTreeState extends State<AntTree> {
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.treeData.map((n) => _NodeWidget(node: n, alias: alias, depth: 0, onSelect: widget.onSelect)).toList());
  }
}

class AntTreeNode {
  const AntTreeNode({required this.title, required this.key, this.children});
  final String title; final String key; final List<AntTreeNode>? children;
}

class _NodeWidget extends StatefulWidget {
  const _NodeWidget({required this.node, required this.alias, required this.depth, required this.onSelect});
  final AntTreeNode node; final AntAliasToken alias; final int depth; final ValueChanged<String>? onSelect;
  @override
  State<_NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<_NodeWidget> {
  bool _expanded = true;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.node.children != null && widget.node.children!.isNotEmpty;
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () {
          if (hasChildren) setState(() => _expanded = !_expanded);
          setState(() => _selected = true);
          widget.onSelect?.call(widget.node.key);
        },
        child: Container(
          padding: EdgeInsets.only(left: widget.depth * 20.0, top: 2, bottom: 2, right: 8),
          color: _selected ? widget.alias.colorPrimaryBackground : null,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (hasChildren)
              Padding(padding: const EdgeInsets.only(right: 4),
                child: Text(_expanded ? '▼' : '▶', style: TextStyle(fontSize: 8, color: widget.alias.colorTextTertiary))),
            Text(widget.node.title, style: TextStyle(color: widget.alias.colorText, fontSize: widget.alias.fontSize)),
          ]),
        ),
      ),
      if (hasChildren && _expanded)
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.node.children!.map((c) => _NodeWidget(node: c, alias: widget.alias, depth: widget.depth + 1, onSelect: widget.onSelect)).toList()),
    ]);
  }
}
