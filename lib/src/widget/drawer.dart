import 'package:ant_design_flutter/src/enum/placement.dart';
import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';

class Drawer {
  Drawer(
    BuildContext context, {
    this.key,
    this.autoFocus = true,
    this.afterVisibleChange,
    this.child,
    this.closable = true,
    this.closeIcon,
    this.destroyOnClose = false,
    this.extra,
    this.footer,
    this.forceRender = false,
    this.height,
    this.keyboard = true,
    this.mask = true,
    this.maskClosable = true,
    this.placement = Placement.right,
    this.size = Size.middle,
    this.title,
    this.width,
    this.onClose,
  }) {
    _state = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => _Drawer(
        closable: closable,
        closeIcon: closeIcon,
        extra: extra,
        footer: footer,
        height: height,
        keyboard: keyboard,
        mask: mask,
        maskClosable: maskClosable,
        placement: placement,
        size: size,
        title: title,
        width: width,
        onClose: _handleClose,
        child: child,
      ),
    );
    _state?.insert(_entry!);
    afterVisibleChange?.call(true);
  }

  final Key? key;
  final bool autoFocus;
  final void Function(bool visible)? afterVisibleChange;
  final Widget? child;
  final bool closable;
  final Widget? closeIcon;
  final bool destroyOnClose;
  final Widget? extra;
  final Widget? footer;
  final bool forceRender;
  final double? height;
  final bool keyboard;
  final bool mask;
  final bool maskClosable;
  final Placement placement;
  final Size size;
  final Widget? title;
  final double? width;
  final void Function()? onClose;

  OverlayState? _state;
  OverlayEntry? _entry;

  void _handleClose() {
    _entry?.remove();
    afterVisibleChange?.call(false);
    onClose?.call();
  }
}

class _Drawer extends StatefulWidget {
  const _Drawer({
    Key? key,
    this.child,
    required this.closable,
    this.closeIcon,
    this.extra,
    this.footer,
    this.height,
    required this.keyboard,
    required this.mask,
    required this.maskClosable,
    required this.placement,
    required this.size,
    this.title,
    this.width,
    required this.onClose,
  }) : super(key: key);

  final Widget? child;
  final bool closable;
  final Widget? closeIcon;
  final Widget? extra;
  final Widget? footer;
  final double? height;
  final bool keyboard;
  final bool mask;
  final bool maskClosable;
  final Placement placement;
  final Size size;
  final Widget? title;
  final double? width;
  final void Function() onClose;

  @override
  State<_Drawer> createState() => __DrawerState();
}

class __DrawerState extends State<_Drawer> {
  @override
  Widget build(BuildContext context) {
    Axis direction = Axis.horizontal;
    if ([Placement.top, Placement.bottom].contains(widget.placement)) {
      direction = Axis.vertical;
    }

    double width = widget.width ?? (Size.large == widget.size ? 736 : 378);
    double height = widget.height ?? (Size.large == widget.size ? 736 : 378);
    if ([Placement.bottom, Placement.top].contains(widget.placement)) {
      width = double.infinity;
    }
    if ([Placement.left, Placement.right].contains(widget.placement)) {
      height = double.infinity;
    }

    Widget mask = Expanded(
      child: GestureDetector(
        onTap: _handleClose,
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );

    Widget closeIcon = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleClose,
        child: widget.closeIcon ??
            const Icon(Icons.close, color: Colors.gray_7, size: 16),
      ),
    );

    Widget title = Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.gray_3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          widget.closable ? closeIcon : const SizedBox(),
          SizedBox(width: widget.closable ? 12 : null),
          Expanded(
            child: DefaultTextStyle.merge(
              child: widget.title ?? const SizedBox(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          widget.extra ?? const SizedBox(),
        ],
      ),
    );

    Widget child = Container(
      color: Colors.white,
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.closable || widget.title != null || widget.extra != null
              ? title
              : const SizedBox(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: widget.child,
            ),
          ),
          widget.footer ?? const SizedBox(),
        ],
      ),
    );

    return Material(
      color: const Color.fromARGB(0, 255, 255, 255),
      child: Flex(
        direction: direction,
        children: [Placement.bottom, Placement.right].contains(widget.placement)
            ? [mask, child]
            : [child, mask],
      ),
    );
  }

  void _handleClose() {
    if (widget.maskClosable) {
      widget.onClose.call();
    }
  }
}
