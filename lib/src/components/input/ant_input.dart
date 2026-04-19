import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/component_status.dart';
import 'package:ant_design_flutter/src/components/input/_clear_icon.dart';
import 'package:ant_design_flutter/src/components/input/input_style.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 的单行输入框。
///
/// 内部使用 `package:flutter/widgets.dart` 的 `EditableText`，不引入 material。
/// 长按 / 右键唤出的选区工具栏由平台原生提供（`selectionControls` 留 null）。
/// 2.1 评估是否补 widgets-only toolbar。
class AntInput extends StatefulWidget {
  const AntInput({
    super.key,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.size = AntComponentSize.middle,
    this.status = AntStatus.defaultStatus,
    this.disabled = false,
    this.readOnly = false,
    this.allowClear = false,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.controller,
    this.focusNode,
  });

  final String? value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final AntComponentSize size;
  final AntStatus status;
  final bool disabled;
  final bool readOnly;
  final bool allowClear;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<AntInput> createState() => _AntInputState();
}

class _AntInputState extends State<AntInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocus;
  bool _hovered = false;
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());
  FocusNode get _focus => widget.focusNode ?? (_internalFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
    _focus.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant AntInput old) {
    super.didUpdateWidget(old);
    if (widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_handleFocus);
      _internalFocus?.dispose();
      _internalFocus = null;
      _focus.addListener(_handleFocus);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocus);
    _internalFocus?.dispose();
    _internalController?.dispose();
    super.dispose();
  }

  void _handleFocus() => setState(() => _focused = _focus.hasFocus);

  void _handleChanged(String value) {
    if (widget.disabled || widget.readOnly) return;
    widget.onChanged?.call(value);
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sizeSpec = InputStyle.sizeSpec(alias: alias, size: widget.size);
    final style = InputStyle.resolve(
      alias: alias,
      status: widget.status,
      hovered: _hovered,
      focused: _focused,
      disabled: widget.disabled,
    );

    final textStyle = TextStyle(
      color: widget.disabled ? alias.colorTextDisabled : alias.colorText,
      fontSize: sizeSpec.fontSize,
    );

    final showClear =
        widget.allowClear &&
        _hovered &&
        !widget.disabled &&
        _controller.text.isNotEmpty;

    final editable = EditableText(
      controller: _controller,
      focusNode: _focus,
      style: textStyle,
      cursorColor: alias.colorPrimary,
      backgroundCursorColor: alias.colorBorder,
      readOnly: widget.disabled || widget.readOnly,
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
      inputFormatters: widget.maxLength == null
          ? null
          : [LengthLimitingTextInputFormatter(widget.maxLength)],
      selectionColor: alias.colorPrimaryBackground,
    );

    final textWithPlaceholder = Stack(
      children: [
        if ((widget.value ?? _controller.text).isEmpty &&
            widget.placeholder != null)
          IgnorePointer(
            child: Text(
              widget.placeholder!,
              style: textStyle.copyWith(color: alias.colorTextTertiary),
            ),
          ),
        editable,
      ],
    );

    final row = Row(
      children: [
        if (widget.prefix != null) ...[
          widget.prefix!,
          const SizedBox(width: 4),
        ],
        Expanded(child: textWithPlaceholder),
        if (showClear) ...[
          GestureDetector(
            onTap: _handleClear,
            child: ClearIcon(color: alias.colorTextTertiary),
          ),
          const SizedBox(width: 4),
        ],
        if (widget.suffix != null) ...[
          const SizedBox(width: 4),
          widget.suffix!,
        ],
      ],
    );

    final decoration = BoxDecoration(
      color: style.background,
      borderRadius: BorderRadius.circular(alias.borderRadius),
      border: Border.all(color: style.borderColor),
      boxShadow: style.focusRing == null
          ? null
          : [
              BoxShadow(color: style.focusRing!, spreadRadius: 2),
            ],
    );

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.text,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        height: sizeSpec.height,
        padding: EdgeInsets.symmetric(horizontal: sizeSpec.horizontalPadding),
        decoration: decoration,
        child: row,
      ),
    );
  }
}
