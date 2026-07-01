import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 输入自动补全。对齐 AntD v5 `AutoComplete`。
class AntAutoComplete extends StatefulWidget {
  const AntAutoComplete({
    required this.options,
    super.key,
    this.value,
    this.onChanged,
    this.onSelect,
    this.placeholder = '',
  });
  final List<String> options;
  final String? value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSelect;
  final String placeholder;

  @override
  State<AntAutoComplete> createState() => _AntAutoCompleteState();
}

class _AntAutoCompleteState extends State<AntAutoComplete> {
  bool _open = false;
  late String _text;

  @override
  void initState() { super.initState(); _text = widget.value ?? ''; }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final filtered = widget.options.where((o) => o.toLowerCase().contains(_text.toLowerCase())).toList();

    return AntPortal(
      placement: AntPlacement.bottomLeft, visible: _open && filtered.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
        child: Row(children: [
          Expanded(child: Text(_text.isEmpty ? widget.placeholder : _text,
            style: TextStyle(color: _text.isEmpty ? alias.colorTextTertiary : alias.colorText, fontSize: alias.fontSize))),
        ]),
      ),
      overlayBuilder: (c) => Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(alias.borderRadius),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final opt in filtered)
            GestureDetector(
              onTap: () { setState(() { _text = opt; _open = false; }); widget.onSelect?.call(opt); widget.onChanged?.call(opt); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(opt, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize))),
            ),
        ]),
      ),
    );
  }
}
