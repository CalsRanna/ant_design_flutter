import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 选择器组件。
///
/// 对齐 AntD v5 `Select` 组件。MVP 实现单选的搜索 / 下拉选择。
///
/// 推迟到 2.1：`mode`（multiple/tags）、`showSearch`、`allowClear`、
/// `labelInValue`、`optionFilterProp`、`virtual`、`maxTagCount`。
class AntSelect<T> extends StatefulWidget {
  const AntSelect({
    required this.options,
    super.key,
    this.value,
    this.onChanged,
    this.placeholder = '请选择',
    this.disabled = false,
    this.width,
  });

  final List<AntSelectOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String placeholder;
  final bool disabled;
  final double? width;

  @override
  State<AntSelect<T>> createState() => _AntSelectState<T>();
}

class _AntSelectState<T> extends State<AntSelect<T>> {
  bool _open = false;

  void _toggle() {
    if (widget.disabled) return;
    setState(() => _open = !_open);
  }

  void _select(T value) {
    widget.onChanged?.call(value);
    setState(() => _open = false);
  }

  AntSelectOption<T>? _findSelected() {
    for (final o in widget.options) {
      if (o.value == widget.value) return o;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final selectedOption = _findSelected();

    return SizedBox(
      width: widget.width,
      child: AntPortal(
        placement: AntPlacement.bottomLeft,
        visible: _open,
        offset: const Offset(0, 4),
        child: AntInteractionDetector(
          enabled: !widget.disabled,
          cursor: SystemMouseCursors.click,
          onTap: _toggle,
          builder: (context, states) {
            final borderColor = states.contains(WidgetState.focused)
                ? alias.colorPrimary
                : alias.colorBorder;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.disabled
                    ? alias.colorFillSecondary
                    : alias.colorBackgroundContainer,
                borderRadius: BorderRadius.circular(alias.borderRadius),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      selectedOption?.label ?? widget.placeholder,
                      style: TextStyle(
                        color: selectedOption != null
                            ? alias.colorText
                            : alias.colorTextTertiary,
                        fontSize: alias.fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _open ? '▲' : '▼',
                    style: TextStyle(
                      color: alias.colorTextTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        overlayBuilder: (context) => _SelectDropdown<T>(
          options: widget.options,
          value: widget.value,
          alias: alias,
          onSelect: _select,
        ),
      ),
    );
  }
}

/// 选择器选项。
class AntSelectOption<T> {
  const AntSelectOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final String label;
  final bool disabled;
}

class _SelectDropdown<T> extends StatelessWidget {
  const _SelectDropdown({
    required this.options,
    required this.value,
    required this.alias,
    required this.onSelect,
  });

  final List<AntSelectOption<T>> options;
  final T? value;
  final AntAliasToken alias;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 256),
      decoration: BoxDecoration(
        color: alias.colorBackgroundElevated,
        borderRadius: BorderRadius.circular(alias.borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final option in options)
            GestureDetector(
              onTap: option.disabled ? null : () => onSelect(option.value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: option.value == value
                    ? alias.colorPrimaryBackground
                    : null,
                child: Text(
                  option.label,
                  style: TextStyle(
                    color: option.disabled
                        ? alias.colorTextDisabled
                        : option.value == value
                            ? alias.colorPrimary
                            : alias.colorText,
                    fontSize: alias.fontSize,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
