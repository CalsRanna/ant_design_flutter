import 'dart:async';

import 'package:ant_design_flutter/src/enum/placement.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:ant_design_flutter/src/widget/app.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';

class AntNotification {
  static void open(
    BuildContext context, {
    double bottom = 24,
    Widget? btn,
    Widget? closeIcon,
    required Widget description,
    Duration? duration = const Duration(milliseconds: 4500),
    Widget? icon,
    required Widget message,
    Placement placement = Placement.topRight,
    double top = 24,
    void Function()? onClick,
    void Function()? onClose,
  }) {
    var tops = GlobalQuery.of(context)?.notificationTops;
    var _top = top;
    if (tops != null) {
      var heights = tops.values.toList();
      for (int i = 0; i < heights.length; i++) {
        _top += heights[i] + 16;
      }
    }
    var key = GlobalKey();
    var entry = OverlayEntry(
      builder: (_) => _Notification(
        key: key,
        bottom: bottom,
        btn: btn,
        closeIcon: closeIcon,
        description: description,
        duration: duration,
        icon: icon,
        message: message,
        placement: placement,
        top: _top,
        onClick: onClick,
        onClose: onClose,
      ),
    );
    Overlay.of(context)?.insert(entry);
    var height = key.currentContext?.size?.height ?? 120;
    GlobalQuery.of(context)?.insertNotification(key, height);
    if (duration != null) {
      Timer(duration, () {
        entry.remove();
        GlobalQuery.of(context)?.removeNotification(key);
      });
    }
  }
}

class _Notification extends StatelessWidget {
  const _Notification({
    Key? key,
    required this.bottom,
    this.btn,
    this.closeIcon,
    required this.description,
    this.duration,
    this.icon,
    required this.message,
    required this.placement,
    required this.top,
    this.onClick,
    this.onClose,
  }) : super(key: key);

  final double bottom;
  final Widget? btn;
  final Widget? closeIcon;
  final Widget description;
  final Duration? duration;
  final Widget? icon;
  final Widget message;
  final Placement placement;
  final double top;
  final void Function()? onClick;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      children: [
        DefaultTextStyle.merge(
          child: message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        MouseRegion(
          child: GestureDetector(
            child: closeIcon ??
                const Icon(Icons.close, color: Colors.gray_5, size: 16),
            onTap: () => _handleClose(context),
          ),
          cursor: SystemMouseCursors.click,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );

    Widget footer = Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: btn,
      ),
    );

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        child: Material(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            child: Column(
              children: [
                header,
                const SizedBox(height: 8),
                description,
                if (btn != null) footer,
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            width: 384,
          ),
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.gray_1,
        ),
        padding: EdgeInsets.only(right: bottom, top: top),
      ),
    );
  }

  void _handleClose(BuildContext context) {
    Navigator.of(context).pop();
    onClose?.call();
  }
}
