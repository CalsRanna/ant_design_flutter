import 'package:ant_design_flutter/enum/size.dart';
import 'package:ant_design_flutter/style/color.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// At least one of [child], [icon] must be non-null.
class Button extends StatefulWidget {
  const Button({
    Key? key,
    this.child,
    this.block = false,
    this.danger = false,
    this.disabled = false,
    this.ghost = false,
    this.href,
    this.htmlType = ButtonHtmlType.button,
    this.icon,
    this.loading = false,
    this.shape = ButtonShape.square,
    this.size = AntSize.medium,
    this.target,
    this.type = ButtonType.normal,
    this.onClick,
  })  : assert(child != null || icon != null,
            'Child and icon can not be both null'),
        super(key: key);

  final Widget? child;
  final bool block;
  final bool danger;
  final bool disabled;
  final bool ghost;
  final String? href;
  final ButtonHtmlType htmlType;
  final Widget? icon;
  final bool? loading;
  final ButtonShape shape;
  final AntSize size;
  final String? target;
  final ButtonType type;
  final void Function()? onClick;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _hovered = false;
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: _buildTextColor(),
        fontSize: 14,
      ),
      child: IconTheme(
        data: IconThemeData(color: _buildTextColor(), size: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: _handleEnter,
          onExit: _handleExit,
          child: GestureDetector(
            child: widget.type == ButtonType.dashed
                ? DottedBorder(
                    child: Container(
                      padding: _calculatePadding(),
                      decoration: BoxDecoration(
                        color: _buildColor(),
                        shape: widget.shape == ButtonShape.circle
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                      ),
                      child: _buildChild(),
                    ),
                    color: _buildBorderColor(),
                    borderType: widget.shape == ButtonShape.circle
                        ? BorderType.Circle
                        : BorderType.RRect,
                    padding: const EdgeInsets.all(0),
                    radius: const Radius.circular(2),
                  )
                : Container(
                    padding: _calculatePadding(),
                    decoration: BoxDecoration(
                      color: _buildColor(),
                      border: Border.all(color: _buildBorderColor()),
                      borderRadius: widget.shape == ButtonShape.circle
                          ? null
                          : BorderRadius.circular(2),
                      shape: widget.shape == ButtonShape.circle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                    ),
                    child: _buildChild(),
                  ),
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
          ),
        ),
      ),
    );
  }

  void _handleEnter(PointerEnterEvent event) {
    setState(() {
      _hovered = true;
    });
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      _hovered = false;
    });
  }

  Color? _buildTextColor() {
    Color? color;
    if (widget.type == ButtonType.primary) {
      color = Colors.gray_1;
    } else if (widget.type == ButtonType.link) {
      color = Colors.blue_6;
    } else {
      color = Colors.gray_10;
    }
    if ([
      ButtonType.normal,
      ButtonType.dashed,
      ButtonType.link,
    ].contains(widget.type)) {
      if (_hovered) {
        color = Colors.blue_5;
      }
      if (_clicked) {
        color = Colors.blue_7;
      }
    }
    return color;
  }

  EdgeInsets _calculatePadding() {
    EdgeInsets padding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 15);
    if (widget.shape == ButtonShape.circle && widget.child == null) {
      padding = const EdgeInsets.all(7);
    }
    return padding;
  }

  Color? _buildColor() {
    Color? color;
    if (widget.type == ButtonType.primary) {
      color = Colors.blue_6;
      if (_hovered) {
        color = Colors.blue_5;
      }
      if (_clicked) {
        color = Colors.blue_7;
      }
    } else {
      color = Colors.gray_1;
      if (_hovered && widget.type == ButtonType.text) {
        color = Colors.gray_2;
      }
    }
    return color;
  }

  Color _buildBorderColor() {
    Color? color = Colors.gray_1;
    if (widget.type == ButtonType.primary) {
      color = Colors.blue_6;
    } else if (widget.type == ButtonType.normal) {
      color = Colors.gray_5;
    } else if (widget.type == ButtonType.dashed) {
      color = Colors.gray_5;
    } else {
      color = Colors.gray_1;
    }
    if ([
      ButtonType.primary,
      ButtonType.normal,
      ButtonType.dashed,
    ].contains(widget.type)) {
      if (_hovered) {
        color = Colors.blue_5;
      }
      if (_clicked) {
        color = Colors.blue_7;
      }
    }
    if (widget.type == ButtonType.text && _hovered) {
      color = Colors.gray_2;
    }
    return color;
  }

  Widget _buildChild() {
    if (widget.child != null && widget.icon != null) {
      return Row(
        children: [
          widget.icon!,
          const SizedBox(width: 8),
          widget.child!,
        ],
      );
    } else {
      return widget.child ?? widget.icon!;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _clicked = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _clicked = false;
    });
    if (widget.onClick != null) {
      widget.onClick!();
    }
  }
}

enum ButtonHtmlType { button, submit, reset }
enum ButtonShape { square, circle, round }
enum ButtonType { primary, ghost, dashed, link, text, normal }
