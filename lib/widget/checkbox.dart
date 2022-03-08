import 'package:flutter/widgets.dart';

class Checkbox extends StatefulWidget {
  const Checkbox({
    Key? key,
    required this.child,
    this.autoFocus = false,
    this.checked = false,
    this.defaultChecked = false,
    this.disabled = false,
    this.indeterminate = false,
    this.onChange,
  }) : super(key: key);

  final Widget child;
  final bool autoFocus;
  final bool checked;
  final bool defaultChecked;
  final bool disabled;
  final bool indeterminate;
  final void Function()? onChange;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CheckboxGroup extends StatefulWidget {
  const CheckboxGroup({
    Key? key,
    required this.children,
    this.defaultValue = const [],
    this.disabled = false,
    this.name,
    this.options = const [],
    this.value = const [],
    this.onChange,
  }) : super(key: key);

  final List<Checkbox> children;
  final List<String> defaultValue;
  final bool disabled;
  final String? name;
  final List<CheckboxOption> options;
  final List<String> value;
  final void Function(List<String> checkedValue)? onChange;

  @override
  State<CheckboxGroup> createState() => _CheckboxGroupState();

  void blur() {}

  void focus() {}
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CheckboxOption {
  CheckboxOption({required this.label, required this.value, this.disabled});

  String label;
  String value;
  bool? disabled;
}
