import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// At least one of [child], [icon] must be non-null.
class Button extends StatefulWidget {
  const Button({
    Key? key,
    this.block = false,
    this.danger = false,
    this.disabled = false,
    this.ghost = false,
    this.icon,
    this.loading = false,
    this.shape = ButtonShape.square,
    this.size = Size.medium,
    this.type = ButtonType.normal,
    this.onClick,
    this.child,
  })  : assert(child != null || icon != null,
            'Child and icon can not be both null'),
        super(key: key);

  final bool block;
  final bool danger;
  final bool disabled;
  final bool ghost;
  final Widget? icon;
  final bool loading;
  final ButtonShape shape;
  final Size size;
  final ButtonType type;
  final void Function()? onClick;
  final Widget? child;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  bool clicked = false;
  bool hovered = false;

  late AnimationController animatedController;

  @override
  void initState() {
    animatedController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    animatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = 32;
    if (Size.large == widget.size) {
      height = 40;
    }
    if (Size.small == widget.size) {
      height = 24;
    }

    double padding = 15;
    if (Size.small == widget.size) {
      padding = 7;
    }
    if (null != widget.icon && null == widget.child) {
      padding = (height - 16) / 2;
    }

    BorderRadius? borderRadius = BorderRadius.circular(2);
    if (ButtonShape.circle == widget.shape) {
      borderRadius = null;
    }
    if (ButtonShape.round == widget.shape) {
      borderRadius = BorderRadius.circular(height / 2);
    }

    MouseCursor cursor = SystemMouseCursors.click;
    if (widget.disabled || widget.loading) {
      cursor = SystemMouseCursors.forbidden;
    }

    Map<String, Color> colors = _calculateColors();

    BoxShape shape = widget.shape == ButtonShape.circle
        ? BoxShape.circle
        : BoxShape.rectangle;

    Radius radius = const Radius.circular(2);
    if (ButtonShape.circle == widget.shape) {
      radius = const Radius.circular(0);
    }
    if (ButtonShape.round == widget.shape) {
      radius = Radius.circular(height / 2);
    }

    Widget child = _buildChild();

    Widget dashedButton = DottedBorder(
      color: colors['border']!,
      borderType: widget.shape == ButtonShape.circle
          ? BorderType.Circle
          : BorderType.RRect,
      padding: const EdgeInsets.all(0),
      radius: radius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colors['button'], shape: shape),
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: child,
      ),
    );

    Widget normalButton = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors['button'],
        border: Border.all(color: colors['border']!),
        borderRadius: borderRadius,
        shape: shape,
      ),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );

    return DefaultTextStyle.merge(
      style: TextStyle(color: colors['text'], fontSize: 14, height: 1),
      child: IconTheme(
        data: IconThemeData(color: colors['text'], size: 16),
        child: MouseRegion(
          cursor: cursor,
          onEnter: _handleEnter,
          onExit: _handleExit,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            child:
                widget.type == ButtonType.dashed ? dashedButton : normalButton,
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    Widget? loadingIcon = RotationTransition(
      turns: animatedController,
      child: const Icon(Icons.loading),
    );

    if (widget.child != null && widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.loading ? loadingIcon : widget.icon!,
          const SizedBox(width: 8),
          widget.child!,
        ],
      );
    } else {
      if (widget.child != null && widget.icon == null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.loading) loadingIcon,
            const SizedBox(width: 8),
            widget.child!,
          ],
        );
      } else {
        return widget.loading ? loadingIcon : widget.icon!;
      }
    }
  }

  Map<String, Color> _calculateColors() {
    var colors = {
      'button': Colors.gray_1,
      'text': Colors.gray_10,
      'border': Colors.gray_5,
    };

    // button color
    colors['button'] = Colors.blue_6;
    if (widget.type == ButtonType.primary) {
      colors['button'] = Colors.blue_6;
      if (hovered) {
        colors['button'] = Colors.blue_5;
      }
      if (clicked) {
        colors['button'] = Colors.blue_7;
      }
      if (widget.disabled || widget.loading) {
        colors['button'] = Colors.blue_5;
      }
    } else {
      colors['button'] = Colors.gray_1;
      if (hovered && widget.type == ButtonType.text) {
        colors['button'] = Colors.gray_2;
      }
      if (widget.disabled || widget.loading) {
        colors['button'] = Colors.gray_2;
      }
    }

    // text color, include icon color
    if (widget.type == ButtonType.primary) {
      colors['text'] = Colors.gray_1;
    } else if (widget.type == ButtonType.link) {
      colors['text'] = Colors.blue_6;
    } else {
      colors['text'] = Colors.gray_10;
    }
    if ([
      ButtonType.normal,
      ButtonType.dashed,
      ButtonType.link,
    ].contains(widget.type)) {
      if (hovered) {
        colors['text'] = Colors.blue_5;
      }
      if (clicked) {
        colors['text'] = Colors.blue_7;
      }
    }

    // border color
    if (widget.type == ButtonType.primary) {
      colors['border'] = Colors.blue_6;
      if (widget.disabled || widget.loading) {
        colors['border'] = Colors.blue_5;
      }
    }
    if ([
      ButtonType.text,
      ButtonType.link,
    ].contains(widget.type)) {
      colors['border'] = Colors.gray_1;
    }
    if ([
      ButtonType.primary,
      ButtonType.normal,
      ButtonType.dashed,
    ].contains(widget.type)) {
      if (!widget.disabled && !widget.loading) {
        if (hovered) {
          colors['border'] = Colors.blue_5;
        }
        if (clicked) {
          colors['border'] = Colors.blue_7;
        }
      }
    }
    if (widget.type == ButtonType.text && hovered) {
      colors['border'] = Colors.gray_2;
    }
    return colors;
  }

  void _handleEnter(PointerEnterEvent event) {
    if (!widget.disabled && !widget.loading) {
      setState(() => hovered = true);
    }
  }

  void _handleExit(PointerExitEvent event) {
    if (!widget.disabled && !widget.loading) {
      setState(() => hovered = false);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled && !widget.loading) {
      setState(() {
        clicked = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled && !widget.loading) {
      setState(() {
        clicked = false;
      });
      if (widget.onClick != null) {
        widget.onClick!();
      }
    }
  }
}

enum ButtonShape { circle, round, square }

enum ButtonType { dashed, ghost, link, normal, primary, text }
