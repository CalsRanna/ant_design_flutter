import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 评分。对齐 AntD v5 `Rate`。
class AntRate extends StatelessWidget {
  const AntRate({
    super.key,
    this.value = 0,
    this.count = 5,
    this.onChanged,
    this.disabled = false,
  });

  final int value;
  final int count;
  final ValueChanged<int>? onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= count; i++)
          GestureDetector(
            onTap: disabled ? null : () => onChanged?.call(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                i <= value ? '★' : '☆',
                style: TextStyle(
                  color: i <= value ? alias.colorWarning : alias.colorFillSecondary,
                  fontSize: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
