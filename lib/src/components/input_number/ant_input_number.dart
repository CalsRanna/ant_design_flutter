import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 数字输入。对齐 AntD v5 `InputNumber`。
class AntInputNumber extends StatefulWidget {
  const AntInputNumber({
    super.key,
    this.value,
    this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.disabled = false,
  });

  final int? value;
  final ValueChanged<int>? onChanged;
  final int? min;
  final int? max;
  final int step;
  final bool disabled;

  @override
  State<AntInputNumber> createState() => _AntInputNumberState();
}

class _AntInputNumberState extends State<AntInputNumber> {
  late int _value;

  @override
  void initState() { super.initState(); _value = widget.value ?? 0; }

  void _change(int delta) {
    if (widget.disabled) return;
    final newVal = _value + delta;
    if (widget.min != null && newVal < widget.min!) return;
    if (widget.max != null && newVal > widget.max!) return;
    setState(() => _value = newVal);
    widget.onChanged?.call(newVal);
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: alias.colorBorder),
        borderRadius: BorderRadius.circular(alias.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn('-', () => _change(-widget.step), alias),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text('$_value', style: TextStyle(color: alias.colorText, fontSize: alias.fontSize)),
          ),
          _Btn('+', () => _change(widget.step), alias),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn(this.text, this.onTap, this.alias);
  final String text; final VoidCallback onTap; final AntAliasToken alias;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border(right: text == '-' ? BorderSide(color: alias.colorBorder) : BorderSide.none),
      ),
      child: Text(text, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize)),
    ),
  );
}
