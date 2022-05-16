import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/widgets.dart';

class Checkbox extends StatefulWidget {
  const Checkbox({
    Key? key,
    this.controller,
    this.child,
    this.autoFocus = false,
    this.checked = false,
    this.defaultChecked = false,
    this.disabled = false,
    this.indeterminate = false,
    this.onChange,
  }) : super(key: key);

  final CheckboxController? controller;
  final Widget? child;
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
  bool hovered = false;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      checked = widget.controller?.checked ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        hovered = true;
      }),
      onExit: (_) => setState(() {
        hovered = false;
      }),
      child: GestureDetector(
        onTap: _handleTap,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hovered ? Colors.blue_6 : Colors.gray_5,
                    ),
                    borderRadius: BorderRadiusDirectional.circular(2),
                  ),
                  width: 16,
                  height: 16,
                ),
                checked
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(2),
                          color: Colors.blue_6,
                        ),
                        height: 16,
                        width: 16,
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            widget.child != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: widget.child!,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    setState(() {
      checked = !checked;
    });
    widget.controller?.checked = checked;
    if (widget.onChange != null) {
      widget.onChange!();
    }
  }
}

class CheckboxController extends ChangeNotifier {
  bool checked = false;
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
