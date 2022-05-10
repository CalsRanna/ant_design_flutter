import 'dart:async';

import 'package:ant_design_flutter/enum/status.dart';
import 'package:ant_design_flutter/style/color.dart';
import 'package:ant_design_flutter/style/icon.dart';
import 'package:ant_design_flutter/widget/app.dart';
import 'package:flutter/material.dart' show Material;
import 'package:flutter/widgets.dart';

class Message {
  void success(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    void Function()? onClick,
    void Function()? onClose,
  }) {
    _insertEntry(
      context,
      ValueKey(DateTime.now()),
      content,
      duration,
      icon,
      Status.success,
      onClick,
      onClose,
    );
  }

  void error(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    void Function()? onClick,
    void Function()? onClose,
  }) {
    _insertEntry(
      context,
      ValueKey(DateTime.now()),
      content,
      duration,
      icon,
      Status.error,
      onClick,
      onClose,
    );
  }

  void info(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    void Function()? onClick,
    void Function()? onClose,
  }) {
    _insertEntry(
      context,
      ValueKey(DateTime.now()),
      content,
      duration,
      icon,
      Status.info,
      onClick,
      onClose,
    );
  }

  void warning(
    BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    void Function()? onClick,
    void Function()? onClose,
  }) {
    _insertEntry(
      context,
      ValueKey(DateTime.now()),
      content,
      duration,
      icon,
      Status.warning,
      onClick,
      onClose,
    );
  }

  void _insertEntry(
    BuildContext context,
    ValueKey key,
    Widget content,
    Duration duration,
    Widget? icon,
    Status status,
    void Function()? onClick,
    void Function()? onClose,
  ) {
    OverlayEntry entry = OverlayEntry(
      builder: (_) =>
          _Message(key: key, content: content, icon: icon, status: status),
    );
    Overlay.of(context)?.insert(entry);
    var tops = GlobalQuery.of(context)?.tops;
    var top =
        tops != null && tops.isNotEmpty ? tops.length * 56.0 + 32.0 : 32.0;
    GlobalQuery.of(context)?.insert(key, top);
    Timer(duration, () {
      entry.remove();
      GlobalQuery.of(context)?.remove(key);
    });
  }
}

class _Message extends StatelessWidget {
  const _Message({
    Key? key,
    required this.content,
    this.icon,
    required this.status,
  }) : super(key: key);

  final Widget content;
  final Widget? icon;
  final Status status;

  @override
  Widget build(BuildContext context) {
    Map<Status, IconData> icons = {
      Status.success: Icons.success,
      Status.error: Icons.error,
      Status.info: Icons.info,
      Status.warning: Icons.warning
    };
    Map<Status, Color> colors = {
      Status.success: Colors.green_6,
      Status.error: Colors.red_6,
      Status.info: Colors.blue_6,
      Status.warning: Colors.orange_6
    };
    Widget _icon = IconTheme.merge(
      data: IconThemeData(color: colors[status], size: 16),
      child: icon ?? Icon(icons[status]),
    );

    Map<ValueKey, double>? tops = GlobalQuery.of(context)?.tops;

    return Positioned(
      child: Container(
        alignment: Alignment.center,
        child: Material(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            child: Row(
              children: [_icon, const SizedBox(width: 8), content],
              mainAxisSize: MainAxisSize.min,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.gray_1,
        ),
        width: MediaQuery.of(context).size.width,
      ),
      top: tops?[key] ?? 32,
    );
  }
}
