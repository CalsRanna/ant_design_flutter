import 'package:flutter/widgets.dart';

class AutoComplete extends StatefulWidget {
  const AutoComplete(
      {Key? key,
      this.allowClear = false,
      this.autoFocus = false,
      this.backfill = false,
      this.chidlren,
      this.defaultActiveFirstOption = true,
      this.defaultOpen,
      this.defaultValue,
      this.disabled = false,
      this.dropdownMatchSelectWidth,
      this.filterOption = true,
      this.getPopupContainer,
      this.notFoundContent,
      this.open,
      this.options,
      this.placeholder,
      this.status,
      this.value,
      this.onBlur,
      this.onChange,
      this.onDropdownVisibleChange,
      this.onFocus,
      this.onSearch,
      this.onSelect,
      this.onClear})
      : super(key: key);

  final bool allowClear;
  final bool autoFocus;
  final bool backfill;
  final List<Widget>? chidlren;
  final bool defaultActiveFirstOption;
  final bool? defaultOpen;
  final String? defaultValue;
  final bool disabled;
  final double? dropdownMatchSelectWidth;
  final bool filterOption;
  final Widget Function()? getPopupContainer;
  final Widget? notFoundContent;
  final bool? open;
  final List<Map<String, String>>? options;
  final String? placeholder;
  final AutoCompleteStatus? status;
  final String? value;
  final void Function()? onBlur;
  final void Function(String value)? onChange;
  final void Function(bool open)? onDropdownVisibleChange;
  final void Function()? onFocus;
  final void Function(String value)? onSearch;
  final void Function(String value, Map<String, String> option)? onSelect;
  final void Function()? onClear;

  @override
  State<AutoComplete> createState() => _AutoCompleteState();

  void blur() {}

  void focus() {}
}

class _AutoCompleteState extends State<AutoComplete> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum AutoCompleteStatus { error, warning }
