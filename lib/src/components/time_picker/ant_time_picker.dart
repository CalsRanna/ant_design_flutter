import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 时间选择（简版）。对齐 AntD v5 `TimePicker`。
/// MVP 使用简化的选取方式。
class AntTimePicker extends StatelessWidget {
  const AntTimePicker({super.key, this.value, this.onChanged, this.placeholder = '选择时间', this.disabled = false});
  final String? value; final ValueChanged<String>? onChanged; final String placeholder; final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call('12:00'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: alias.colorBorder), borderRadius: BorderRadius.circular(alias.borderRadius)),
        child: Text(value ?? placeholder,
          style: TextStyle(color: value != null ? alias.colorText : alias.colorTextTertiary, fontSize: alias.fontSize)),
      ),
    );
  }
}
