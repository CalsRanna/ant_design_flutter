import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 级联选择（简版）。对齐 AntD v5 `Cascader`。
class AntCascader extends StatefulWidget {
  const AntCascader({required this.options, super.key, this.value, this.onChanged, this.placeholder = '请选择'});
  final List<AntCascaderOption> options; final List<String>? value; final ValueChanged<List<String>>? onChanged; final String placeholder;
  @override
  State<AntCascader> createState() => _AntCascaderState();
}

class _AntCascaderState extends State<AntCascader> {
  bool _open = false;
  List<AntCascaderOption> _currentLevel = [];
  AntCascaderOption? _selected1;
  AntCascaderOption? _selected2;

  @override
  void initState() { super.initState(); _currentLevel = widget.options; }

  void _select(int idx, AntCascaderOption opt) {
    if (opt.children != null && opt.children!.isNotEmpty) {
      setState(() {
        if (idx == 0) { _selected1 = opt; _currentLevel = opt.children!; }
        else if (idx == 1) { _selected2 = opt; }
      });
    } else {
      final result = <String>[];
      if (_selected1 != null) result.add(_selected1!.label);
      if (_selected2 != null) result.add(_selected2!.label);
      result.add(opt.label);
      widget.onChanged?.call(result);
      setState(() => _open = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final display = widget.value?.join(' / ') ?? widget.placeholder;

    return AntPortal(
      placement: AntPlacement.bottomLeft, visible: _open,
      child: GestureDetector(
        onTap: () => setState(() { _open = !_open; _currentLevel = widget.options; _selected1 = null; _selected2 = null; }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
          child: Text(display, style: TextStyle(color: widget.value != null ? alias.colorText : alias.colorTextTertiary, fontSize: alias.fontSize)),
        ),
      ),
      overlayBuilder: (c) => Container(
        decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(alias.borderRadius),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))]),
        child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _Column(options: widget.options, alias: alias, selected: _selected1, onSelect: (o) => _select(0, o)),
          if (_selected1?.children != null) _Column(options: _selected1!.children!, alias: alias, selected: _selected2, onSelect: (o) => _select(1, o)),
          if (_selected2?.children != null) _Column(options: _selected2!.children!, alias: alias, selected: null, onSelect: (o) => _select(2, o)),
        ]),
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.options, required this.alias, required this.selected, required this.onSelect});
  final List<AntCascaderOption> options; final AntAliasToken alias; final AntCascaderOption? selected; final ValueChanged<AntCascaderOption> onSelect;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxHeight: 200), width: 120,
    decoration: BoxDecoration(border: Border(right: BorderSide(color: alias.colorSplit))),
    child: ListView(shrinkWrap: true, children: options.map((o) => GestureDetector(
      onTap: () => onSelect(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: o == selected ? alias.colorPrimaryBackground : null,
        child: Row(children: [
          Expanded(child: Text(o.label, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize - 1))),
          if (o.children != null && o.children!.isNotEmpty)
            Text('›', style: TextStyle(color: alias.colorTextTertiary)),
        ]),
      ),
    )).toList()),
  );
}

class AntCascaderOption {
  const AntCascaderOption({required this.label, required this.value, this.children});
  final String label; final String value; final List<AntCascaderOption>? children;
}
