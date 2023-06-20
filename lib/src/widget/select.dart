import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/enum/status.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/material.dart'
    show InputBorder, InputDecoration, TextField;
import 'package:flutter/widgets.dart';

class Select<T> extends StatefulWidget {
  const Select({
    Key? key,
    this.allowClear = false,
    this.autoClearSearchValue = true,
    this.bordered = true,
    this.clearIcon,
    this.controller,
    this.defaultActiveFirstOption = true,
    this.defaultOpen = false,
    this.disabled = false,
    this.dropdownSelectWidth,
    this.dropdownBuilder,
    this.filterOption,
    this.filterSort,
    this.labelInValue = false,
    this.listHeight = 256,
    this.loading = false,
    this.maxTagCount,
    this.maxTagPlaceholder,
    this.maxTagTextLength,
    this.menuItemSelectedIcon,
    this.mode = SelectMode.normal,
    this.notFoundContent = const Text('Not Found'),
    this.onBlur,
    this.onChange,
    this.onClear,
    this.onDeselect,
    this.onDropdownVisibleChange,
    this.onFocus,
    this.onInputKeyDown,
    this.onMouseEnter,
    this.onMouseLeave,
    this.onPopupScroll,
    this.onSearch,
    this.onSelect,
    this.optionFilterProp = OptionProp.value,
    this.optionLabelProp = OptionProp.children,
    this.options,
    this.placeholder,
    this.removeIcon,
    this.showArrow,
    this.showSearch = false,
    this.size = Size.middle,
    this.status,
    this.suffixIcon,
    this.tagBuilder,
    this.tokenSeparators,
    this.virtual = true,
    required this.children,
  }) : super(key: key);

  final bool allowClear;
  final bool autoClearSearchValue;
  final bool bordered;
  final Widget? clearIcon;
  final SelectController? controller;
  final bool defaultActiveFirstOption;
  final bool defaultOpen;
  final bool disabled;
  final double? dropdownSelectWidth;
  final Widget Function()? dropdownBuilder;
  final bool Function()? filterOption;
  final int Function()? filterSort;
  final bool labelInValue;
  final double listHeight;
  final bool loading;
  final int? maxTagCount;
  final Widget? maxTagPlaceholder;
  final int? maxTagTextLength;
  final Widget? menuItemSelectedIcon;
  final SelectMode mode;
  final Widget notFoundContent;
  final void Function()? onBlur;
  final void Function()? onChange;
  final void Function()? onClear;
  final void Function()? onDeselect;
  final void Function()? onDropdownVisibleChange;
  final void Function()? onFocus;
  final void Function()? onInputKeyDown;
  final void Function()? onMouseEnter;
  final void Function()? onMouseLeave;
  final void Function()? onPopupScroll;
  final void Function()? onSearch;
  final void Function()? onSelect;
  final OptionProp optionFilterProp;
  final OptionProp optionLabelProp;
  final Map<String, dynamic>? options;
  final String? placeholder;
  final Widget? removeIcon;
  final bool? showArrow;
  final bool showSearch;
  final Size size;
  final Status? status;
  final Widget? suffixIcon;
  final Widget Function()? tagBuilder;
  final List<String>? tokenSeparators;
  final bool virtual;
  final List<Option<T>> children;

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> with SingleTickerProviderStateMixin {
  static const height = {
    Size.small: 24.0,
    Size.middle: 32.0,
    Size.large: 40.0,
  };

  bool actived = false;
  late OverlayEntry entry;
  FocusNode focusNode = FocusNode();
  bool hovered = false;
  LayerLink link = LayerLink();
  TextEditingController textEditingController = TextEditingController();
  late AnimationController animatedController;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_focusNodeListener);
    setState(() {
      textEditingController.text =
          widget.controller?.selected[0].toString() ?? '';
    });
    textEditingController.addListener(() {
      widget.controller?.selected[0] = textEditingController.text;
    });
    animatedController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    focusNode.removeListener(_focusNodeListener);
    focusNode.dispose();
    textEditingController.dispose();
    animatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) {
        if (!widget.disabled) {
          setState(() {
            hovered = true;
          });
        }
      },
      onExit: (_) {
        if (!widget.disabled) {
          setState(() {
            hovered = false;
          });
        }
      },
      child: GestureDetector(
        child: CompositedTransformTarget(
          link: link,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.disabled
                    ? Colors.gray_5
                    : actived || hovered
                        ? Colors.blue_6
                        : Colors.gray_5,
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: actived
                  ? const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.blue_6,
                        offset: Offset(1, 1),
                        spreadRadius: 0.1,
                      ),
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.blue_6,
                        offset: Offset(-1, -1),
                        spreadRadius: 0.1,
                      ),
                    ]
                  : null,
              color: widget.disabled ? Colors.gray_3 : Colors.white,
            ),
            height: height[widget.size],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.placeholder,
                        hintStyle:
                            const TextStyle(color: Colors.gray_5, fontSize: 14),
                        isCollapsed: true,
                      ),
                      enabled: !widget.disabled,
                      focusNode: focusNode,
                      mouseCursor: widget.disabled
                          ? SystemMouseCursors.forbidden
                          : SystemMouseCursors.click,
                      readOnly: true,
                      showCursor: widget.showSearch,
                      style: TextStyle(
                        color: widget.disabled ? Colors.gray_5 : Colors.gray_10,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                widget.loading
                    ? RotationTransition(
                        turns: animatedController,
                        child: const Icon(
                          Icons.loading,
                        ),
                      )
                    : widget.allowClear && hovered
                        ? GestureDetector(
                            onTap: _handleClear,
                            child: const Icon(Icons.clear),
                          )
                        : const Icon(Icons.chevron_down)
              ],
            ),
          ),
        ),
        onTap: () {
          if (!widget.disabled) {
            FocusScope.of(context).requestFocus(focusNode);
          }
        },
      ),
    );
  }

  void _focusNodeListener() {
    if (focusNode.hasFocus) {
      setState(() {
        actived = true;
      });
      var size = context.size;
      entry = OverlayEntry(
        builder: (context) => Positioned(
          width: size?.width,
          child: CompositedTransformFollower(
            followerAnchor: Alignment.topCenter,
            link: link,
            offset: const Offset(0, 8),
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomCenter,
            child: _SelectDropdown(
                children: widget.children
                    .map((child) => GestureDetector(
                          child: _DecoratedOption(
                            selected: child.value == textEditingController.text,
                            child: child,
                          ),
                          onTap: () => _handleTap(child),
                        ))
                    .toList()),
          ),
        ),
      );
      Overlay.of(context).insert(entry);
    } else {
      setState(() {
        actived = false;
      });
      entry.remove();
    }
  }

  void _handleTap(Option option) {
    if (!option.disabled) {
      setState(() {
        textEditingController.text = option.value;
      });
      widget.controller?.selected = [option.value];
      focusNode.unfocus();
    }
  }

  void _handleClear() {
    if (!widget.disabled) {
      setState(() {
        textEditingController.text = '';
      });
      widget.controller?.selected = [''];
      focusNode.unfocus();
    }
  }
}

class SelectController<T> extends ChangeNotifier {
  List<T> selected = [];
}

class Option<T> extends StatelessWidget {
  const Option({
    Key? key,
    this.child,
    this.disabled = false,
    this.title,
    required this.value,
  }) : super(key: key);

  final Widget? child;
  final bool disabled;
  final String? title;
  final T value;

  @override
  Widget build(BuildContext context) {
    return child ?? Text(value.toString());
  }
}

class _DecoratedOption<T> extends StatefulWidget {
  const _DecoratedOption({
    Key? key,
    required this.child,
    required this.selected,
  }) : super(key: key);

  final Option child;
  final bool selected;

  @override
  State<_DecoratedOption<T>> createState() => __DecoratedOptionState<T>();
}

class __DecoratedOptionState<T> extends State<_DecoratedOption<T>> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.child.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        if (!widget.child.disabled) {
          hovered = true;
        }
      }),
      onExit: (_) => setState(() {
        hovered = false;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: widget.selected
              ? Colors.blue_1
              : hovered
                  ? Colors.gray_2
                  : null,
        ),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: DefaultTextStyle(
          style: TextStyle(
            color: widget.child.disabled ? Colors.gray_5 : Colors.gray_10,
            fontSize: 14,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _SelectDropdown extends StatelessWidget {
  const _SelectDropdown({Key? key, this.children}) : super(key: key);

  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 256),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.gray_3,
            offset: Offset(4, 4),
            spreadRadius: 0.1,
          ),
          BoxShadow(
            blurRadius: 4,
            color: Colors.gray_3,
            offset: Offset(-4, 0),
            spreadRadius: 0.1,
          ),
        ]),
        child: ListView(
          children: children ?? <Widget>[],
        ),
      ),
    );
  }
}

enum OptionProp { children, label, value }

enum SelectMode { multiple, normal, tags }
