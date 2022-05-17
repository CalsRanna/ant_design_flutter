import 'package:flutter/widgets.dart';

class Cascader extends StatefulWidget {
  const Cascader(
      {Key? key,
      this.allowClear = true,
      this.autoFocus = false,
      this.bordered = true,
      this.changeOnSelect = false,
      this.defaultValue = const [],
      this.disabled = false,
      this.displayBuilder,
      this.dropdownBuilder,
      this.expandIcon,
      this.expandTrigger = CascaderTrigger.click,
      this.fieldNames,
      this.getPopupContainer,
      this.loadData,
      this.maxTagCount,
      this.maxTagPlaceholder,
      this.notFoundContent = const Text('Not Found'),
      this.open,
      this.options = const [],
      this.placeholder = '请选择',
      this.placement = Alignment.bottomLeft,
      this.showSearch,
      this.size = CascaderSize.middle,
      this.status,
      this.suffixIcon,
      this.tagBuilder,
      this.value,
      this.onChange,
      this.onPopupVisibleChange,
      this.multiple,
      this.searchValue,
      this.onSearch})
      : super(key: key);

  final bool allowClear;
  final bool autoFocus;
  final bool bordered;
  final bool changeOnSelect;
  final List<String> defaultValue;
  final bool disabled;
  final Widget Function(
    String label,
    List<CascaderOption> selectedOptions,
  )? displayBuilder;
  final Widget Function(List<Widget> menus)? dropdownBuilder;
  final Widget? expandIcon;
  final CascaderTrigger expandTrigger;
  final Map? fieldNames;
  final Widget Function()? getPopupContainer;
  final void Function(List<CascaderOption> selectedOptions)? loadData;
  final int? maxTagCount;
  final Widget? maxTagPlaceholder;
  final Widget notFoundContent;
  final bool? open;
  final List<CascaderOption> options;
  final String placeholder;
  final Alignment placement;
  final ShowSearch? showSearch;
  final CascaderSize size;
  final CascaderStatus? status;
  final Widget? suffixIcon;
  final Widget Function()? tagBuilder;
  final List<String>? value;
  final void Function(
    String value,
    List<CascaderOption> selectedOptions,
  )? onChange;
  final void Function(String value)? onPopupVisibleChange;
  final bool? multiple;
  final String? searchValue;
  final void Function(String search)? onSearch;

  @override
  State<Cascader> createState() => _CascaderState();

  void blur() {}

  void focus() {}
}

class _CascaderState extends State<Cascader> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CascaderOption {
  CascaderOption({
    required this.value,
    this.label,
    this.disabled,
    this.children,
    this.isLeaf,
  });

  String value;
  Widget? label;
  bool? disabled;
  List<CascaderOption>? children;
  bool? isLeaf;
}

enum CascaderTrigger { click, hover }

class ShowSearch {
  ShowSearch({
    required this.filter,
    this.limit = 50,
    this.matchInputWidth = true,
    this.builder,
    this.sort,
  });

  bool Function(String inputValue, String path) filter;
  int limit;
  bool matchInputWidth;
  Widget Function(String inputValue, String path)? builder;
  void Function(String a, String b, String inputValue)? sort;
}

enum CascaderSize { large, middle, small }

enum CascaderStatus { error, warning }
