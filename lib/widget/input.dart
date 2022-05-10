import 'package:ant_design_flutter/enum/size.dart';
import 'package:ant_design_flutter/enum/status.dart';
import 'package:ant_design_flutter/style/color.dart';
import 'package:flutter/material.dart'
    show InputBorder, InputDecoration, TextField;
import 'package:flutter/widgets.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    this.addonAfter,
    this.addonBefore,
    this.allowClear = false,
    this.bordered = true,
    this.disabled = false,
    this.maxLength,
    this.onChange,
    this.onPressEnter,
    this.showCount = false,
    this.status,
    this.placeholder,
    this.prefix,
    this.size = AntSize.medium,
    this.suffix,
    this.type = InputType.text,
    this.value,
  }) : super(key: key);

  final Widget? addonAfter;
  final Widget? addonBefore;
  final bool allowClear;
  final bool bordered;
  final bool disabled;
  final int? maxLength;
  final void Function()? onChange;
  final void Function()? onPressEnter;
  final bool showCount;
  final Status? status;
  final String? placeholder;
  final Widget? prefix;
  final AntSize size;
  final Widget? suffix;
  final InputType type;
  final String? value;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  static const height = {
    AntSize.small: 24.0,
    AntSize.medium: 32.0,
    AntSize.large: 40.0,
  };

  bool actived = false;
  FocusNode focusNode = FocusNode();
  bool hovered = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_focusNodeListener);
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        child: Container(
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: const TextStyle(color: Colors.gray_5, fontSize: 14),
                isCollapsed: true,
              ),
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: actived || hovered ? Colors.blue_6 : Colors.gray_5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          height: height[widget.size],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        onTap: () => FocusScope.of(context).requestFocus(focusNode),
      ),
      cursor: SystemMouseCursors.text,
      onEnter: (_) => setState(() {
        hovered = true;
      }),
      onExit: (_) => setState(() {
        hovered = false;
      }),
    );
  }

  void _focusNodeListener() {
    if (focusNode.hasFocus) {
      setState(() {
        actived = true;
      });
    } else {
      setState(() {
        actived = false;
      });
    }
  }
}

enum InputType { text }

class InputController extends ChangeNotifier {
  String? value;
}
