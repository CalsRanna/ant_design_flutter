import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// [Button] is completely a [Container] but can be clicked.
///
/// Its height is determined by [size] and [shape], and can't override.
///
/// At least one of [child], [icon] must be non-null.
class Button extends StatefulWidget {
  const Button({
    Key? key,
    this.block = false,
    this.danger = false,
    this.disabled = false,
    this.ghost = false,
    this.href,
    this.icon,
    this.loading = false,
    this.shape = ButtonShape.square,
    this.size = Size.middle,
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
  final String? href;
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
  late AnimationController controller;
  bool clicked = false;
  bool hovered = false;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
      if (ButtonShape.round == widget.shape) {
        padding = padding + 8;
      }
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

    Map<String, Color?> colors = calculateColors();

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

    Widget content = buildContent();

    Widget dashedButton = DottedBorder(
      color: colors['border']!,
      borderType: widget.shape == ButtonShape.circle
          ? BorderType.Circle
          : BorderType.RRect,
      dashPattern: const [3, 3],
      padding: const EdgeInsets.all(0),
      radius: radius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colors['content'], shape: shape),
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: content,
      ),
    );

    Widget normalButton = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors['content'],
        border: Border.all(color: colors['border']!),
        borderRadius: borderRadius,
        shape: shape,
      ),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: content,
    );

    Widget child =
        widget.type == ButtonType.dashed ? dashedButton : normalButton;
    if (!widget.block) {
      child = UnconstrainedBox(child: child);
    }

    return DefaultTextStyle.merge(
      style: TextStyle(color: colors['text'], fontSize: 14, height: 1),
      child: IconTheme(
        data: IconThemeData(color: colors['text'], size: 16),
        child: MouseRegion(
          cursor: cursor,
          onEnter: handleEnter,
          onExit: handleExit,
          child: GestureDetector(
            onTapDown: handleTapDown,
            onTapUp: handleTapUp,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    Widget? loadingIcon = RotationTransition(
      turns: controller,
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
            if (widget.loading) const SizedBox(width: 8),
            widget.child!,
          ],
        );
      } else {
        return widget.loading ? loadingIcon : widget.icon!;
      }
    }
  }

  final borderColors = {
    ButtonType.dashed: Colors.gray_5,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.gray_5,
    ButtonType.primary: Colors.blue_6,
    ButtonType.text: Colors.gray_1,
  };
  final contentColors = {
    ButtonType.dashed: Colors.gray_1,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.gray_1,
    ButtonType.primary: Colors.blue_6,
    ButtonType.text: Colors.gray_1,
  };
  final textColors = {
    ButtonType.dashed: Colors.gray_10,
    ButtonType.link: Colors.blue_6,
    ButtonType.normal: Colors.gray_10,
    ButtonType.primary: Colors.gray_1,
    ButtonType.text: Colors.gray_10,
  };
  final clickedBorderColors = {
    ButtonType.dashed: Colors.blue_7,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.blue_7,
    ButtonType.primary: Colors.blue_7,
    ButtonType.text: Colors.gray_3,
  };
  final clickedContetColors = {
    ButtonType.dashed: Colors.gray_1,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.gray_1,
    ButtonType.primary: Colors.blue_7,
    ButtonType.text: Colors.gray_3,
  };
  final clickedTextColors = {
    ButtonType.dashed: Colors.blue_7,
    ButtonType.link: Colors.blue_7,
    ButtonType.normal: Colors.blue_7,
    ButtonType.primary: Colors.gray_1,
    ButtonType.text: Colors.gray_10,
  };
  final hoverdBorderColors = {
    ButtonType.dashed: Colors.blue_5,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.blue_5,
    ButtonType.primary: Colors.blue_5,
    ButtonType.text: Colors.gray_2,
  };
  final hoverdContetColors = {
    ButtonType.dashed: Colors.gray_1,
    ButtonType.link: Colors.gray_1,
    ButtonType.normal: Colors.gray_1,
    ButtonType.primary: Colors.blue_5,
    ButtonType.text: Colors.gray_2,
  };
  final hoverdTextColors = {
    ButtonType.dashed: Colors.blue_5,
    ButtonType.link: Colors.blue_6,
    ButtonType.normal: Colors.blue_5,
    ButtonType.primary: Colors.gray_1,
    ButtonType.text: Colors.gray_10,
  };
  Map<String, Color?> calculateColors() {
    var colors = {
      'border': borderColors[widget.type],
      'content': contentColors[widget.type],
      'text': textColors[widget.type],
    };
    if (clicked) {
      colors['border'] = clickedBorderColors[widget.type];
      colors['content'] = clickedContetColors[widget.type];
      colors['text'] = clickedTextColors[widget.type];
    } else if (hovered || widget.loading) {
      colors['border'] = hoverdBorderColors[widget.type];
      colors['content'] = hoverdContetColors[widget.type];
      colors['text'] = hoverdTextColors[widget.type];
    }
    return colors;
  }

  void handleEnter(PointerEnterEvent event) {
    if (!widget.disabled && !widget.loading) {
      setState(() => hovered = true);
    }
  }

  void handleExit(PointerExitEvent event) {
    if (!widget.disabled && !widget.loading) {
      setState(() => hovered = false);
    }
  }

  void handleTapDown(TapDownDetails details) {
    if (!widget.disabled && !widget.loading) {
      setState(() {
        clicked = true;
      });
    }
  }

  void handleTapUp(TapUpDetails details) {
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
