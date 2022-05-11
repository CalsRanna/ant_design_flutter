import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/enum/status.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/material.dart'
    show InputBorder, InputDecoration, TextField;
import 'package:flutter/widgets.dart';

class InputNumber extends StatefulWidget {
  const InputNumber({
    Key? key,
    this.addonAfter,
    this.addonBefore,
    this.autoFocus = false,
    this.bordered = true,
    this.controller,
    this.controls = true,
    this.decimalSeparator,
    this.disabled = false,
    this.formatter,
    this.keyboard = true,
    this.max = double.maxFinite,
    this.min = double.minPositive,
    this.onChange,
    this.onPressEnter,
    this.onStep,
    this.parser,
    this.placeholder,
    this.precision,
    this.prefix,
    this.readOnly = false,
    this.stringMode = false,
    this.status,
    this.size = Size.medium,
    this.step = 1,
  }) : super(key: key);

  final Widget? addonAfter;
  final Widget? addonBefore;
  final bool autoFocus;
  final bool bordered;
  final InputNumberController? controller;
  final bool controls;
  final String? decimalSeparator;
  final bool disabled;
  final String Function()? formatter;
  final bool keyboard;
  final double max;
  final double min;
  final void Function()? onChange;
  final void Function()? onPressEnter;
  final void Function()? onStep;
  final double Function()? parser;
  final String? placeholder;
  final double? precision;
  final Widget? prefix;
  final bool readOnly;
  final bool stringMode;
  final Status? status;
  final Size size;
  final double step;

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  static const height = {
    Size.small: 24.0,
    Size.medium: 32.0,
    Size.large: 40.0,
  };

  bool actived = false;
  String? clickedIcon;
  FocusNode focusNode = FocusNode();
  bool hovered = false;
  String? hoveredIcon;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_focusNodeListener);
    textEditingController.text = widget.controller?.value?.toString() ?? '';
    textEditingController.addListener(() {
      widget.controller?.value = double.parse(textEditingController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_focusNodeListener);
    focusNode.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.placeholder,
                      hintStyle:
                          const TextStyle(color: Colors.gray_5, fontSize: 14),
                      isCollapsed: true,
                    ),
                    focusNode: focusNode,
                    style: const TextStyle(fontSize: 14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
              Visibility(
                child: Container(
                  child: Column(
                    children: [
                      MouseRegion(
                        child: GestureDetector(
                          child: Container(
                            child: Icon(
                              Icons.chevron_up,
                              color: hoveredIcon != null && hoveredIcon == 'up'
                                  ? Colors.gray_6
                                  : Colors.gray_5,
                              size: 12,
                            ),
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(color: Colors.gray_5),
                              ),
                              color: clickedIcon != null && clickedIcon == 'up'
                                  ? Colors.gray_3
                                  : null,
                            ),
                            height: hoveredIcon == null
                                ? 15
                                : hoveredIcon == 'up'
                                    ? 18
                                    : 12,
                            width: 22,
                          ),
                          onTapDown: (_) {
                            setState(() {
                              clickedIcon = 'up';
                            });
                            double current =
                                double.parse(textEditingController.text);
                            if (current + widget.step <= widget.max) {
                              textEditingController.text =
                                  (current + widget.step).toString();
                              widget.controller?.value = current + widget.step;
                            }
                          },
                          onTapUp: (_) {
                            setState(() {
                              clickedIcon = null;
                            });
                          },
                        ),
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() {
                          hoveredIcon = 'up';
                        }),
                        onExit: (_) => setState(() {
                          hoveredIcon = null;
                        }),
                      ),
                      MouseRegion(
                        child: GestureDetector(
                          child: Container(
                            child: Icon(
                              Icons.chevron_down,
                              color:
                                  hoveredIcon != null && hoveredIcon == 'down'
                                      ? Colors.gray_6
                                      : Colors.gray_5,
                              size: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  clickedIcon != null && clickedIcon == 'down'
                                      ? Colors.gray_3
                                      : null,
                            ),
                            height: hoveredIcon == null
                                ? 15
                                : hoveredIcon == 'down'
                                    ? 18
                                    : 12,
                            width: 22,
                          ),
                          onTapDown: (_) {
                            setState(() {
                              clickedIcon = 'down';
                            });
                            double current =
                                double.parse(textEditingController.text);
                            if (current - widget.step >= widget.min) {
                              textEditingController.text =
                                  (current - widget.step).toString();
                              widget.controller?.value = current - widget.step;
                            }
                          },
                          onTapUp: (_) {
                            setState(() {
                              clickedIcon = null;
                            });
                          },
                        ),
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() {
                          hoveredIcon = 'down';
                        }),
                        onExit: (_) => setState(() {
                          hoveredIcon = null;
                        }),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.gray_5)),
                  ),
                  height: 30,
                  width: 22,
                ),
                visible: hovered,
              )
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: actived || hovered ? Colors.blue_6 : Colors.gray_5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          height: height[widget.size],
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
      textEditingController.text =
          double.parse(textEditingController.text).toString();
      setState(() {
        actived = false;
      });
    }
  }
}

class InputNumberController {
  InputNumberController.fromValue(this.value);

  double? value;
}
