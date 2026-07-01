import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 分段控制器。对齐 AntD v5 `Segmented`。
class AntSegmented<T> extends StatelessWidget {
  const AntSegmented({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final List<AntSegmentedOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: alias.colorFillSecondary,
        borderRadius: BorderRadius.circular(alias.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = opt.value == value;
          return GestureDetector(
            onTap: opt.disabled ? null : () => onChanged(opt.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? alias.colorBackgroundContainer : null,
                borderRadius: BorderRadius.circular(alias.borderRadius - 2),
                boxShadow: isSelected
                    ? [BoxShadow(color: const Color(0x0A000000), blurRadius: 2, offset: const Offset(0, 1))]
                    : null,
              ),
              child: Text(
                opt.label,
                style: TextStyle(
                  color: opt.disabled
                      ? alias.colorTextDisabled
                      : isSelected
                          ? alias.colorText
                          : alias.colorTextSecondary,
                  fontSize: alias.fontSize,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AntSegmentedOption<T> {
  const AntSegmentedOption({required this.value, required this.label, this.disabled = false});
  final T value;
  final String label;
  final bool disabled;
}
