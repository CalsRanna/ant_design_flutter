import 'package:ant_design_flutter/src/components/checkbox/ant_checkbox.dart';
import 'package:ant_design_flutter/src/components/checkbox/ant_option.dart';
import 'package:flutter/widgets.dart';

/// 多选组：`options` 驱动，受控 `value` + `onChanged`。
class AntCheckboxGroup<T> extends StatelessWidget {
  const AntCheckboxGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final List<T> value;
  final ValueChanged<List<T>>? onChanged;
  final bool disabled;
  final Axis direction;

  void _toggle(T v, bool checked) {
    final next = [...value];
    if (checked) {
      if (!next.contains(v)) next.add(v);
    } else {
      next.remove(v);
    }
    onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (opt) => Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(bottom: 8),
            child: AntCheckbox(
              checked: value.contains(opt.value),
              disabled: disabled || opt.disabled,
              onChanged: disabled
                  ? null
                  : (checked) => _toggle(opt.value, checked),
              label: Text(opt.label),
            ),
          ),
        )
        .toList();
    return direction == Axis.horizontal
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }
}
