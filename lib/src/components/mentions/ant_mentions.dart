import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 提及/@提醒（简版）。对齐 AntD v5 `Mentions`。
class AntMentions extends StatefulWidget {
  const AntMentions({required this.options, super.key, this.value, this.onChanged, this.placeholder = ''});
  final List<String> options; final String? value; final ValueChanged<String>? onChanged; final String placeholder;
  @override
  State<AntMentions> createState() => _AntMentionsState();
}

class _AntMentionsState extends State<AntMentions> {
  late String _text;
  @override
  void initState() { super.initState(); _text = widget.value ?? ''; }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final match = _text.contains('@') ? _text.split('@').last.split(' ').first.toLowerCase() : null;
    final suggestions = match != null ? widget.options.where((o) => o.toLowerCase().contains(match)).toList() : <String>[];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_text.isEmpty ? widget.placeholder : _text, style: TextStyle(color: _text.isEmpty ? alias.colorTextTertiary : alias.colorText)),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 4)]),
            child: Column(mainAxisSize: MainAxisSize.min, children: suggestions.map((s) => GestureDetector(
              onTap: () {
                final before = _text.substring(0, _text.lastIndexOf('@'));
                final newText = '$before@$s ';
                setState(() => _text = newText);
                widget.onChanged?.call(newText);
              },
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: Text('@$s', style: TextStyle(color: alias.colorPrimary))),
            )).toList()),
          ),
      ]),
    );
  }
}
