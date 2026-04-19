import 'package:ant_design_flutter/src/components/checkbox/ant_option.dart';
import 'package:ant_design_flutter/src/components/radio/ant_radio.dart';
import 'package:flutter/widgets.dart';

/// 单选组：`options` 驱动，受控 `value` + `onChanged`。
class AntRadioGroup<T> extends StatelessWidget {
  const AntRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.disabled = false,
    this.direction = Axis.horizontal,
  });

  final List<AntOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final bool disabled;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (opt) => Padding(
            padding: direction == Axis.horizontal
                ? const EdgeInsets.only(right: 12)
                : const EdgeInsets.only(bottom: 8),
            child: AntRadio<T>(
              value: opt.value,
              groupValue: value,
              disabled: disabled || opt.disabled,
              onChanged: disabled ? null : onChanged,
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
