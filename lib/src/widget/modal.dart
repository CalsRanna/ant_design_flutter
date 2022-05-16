import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:ant_design_flutter/src/widget/button.dart';
import 'package:flutter/material.dart' show Material, showDialog;
import 'package:flutter/widgets.dart';

class Modal {
  Modal(
    BuildContext context, {
    void Function()? afterClose,
    String cancelText = '取消',
    bool centered = false,
    bool closable = false,
    Widget? closeIcon,
    required Widget content,
    Widget? icon,
    bool keyboard = true,
    bool mask = true,
    bool maskClosable = false,
    String okText = '确定',
    ButtonType okType = ButtonType.primary,
    required Widget title,
    double width = 520,
    void Function()? onCancel,
    void Function()? onOk,
  }) {
    showDialog(
      context: context,
      builder: (_) => _Modal(
        afterClose: afterClose,
        cancelText: cancelText,
        centered: centered,
        closable: closable,
        closeIcon: closeIcon,
        content: content,
        icon: icon,
        keyboard: keyboard,
        mask: mask,
        maskClosable: maskClosable,
        okText: okText,
        okType: okType,
        title: title,
        width: width,
        onCancel: onCancel,
        onOk: onOk,
      ),
    );
  }

  static void success(
    BuildContext context, {
    void Function()? afterClose,
    String cancelText = '取消',
    bool centered = false,
    bool closable = false,
    Widget? closeIcon,
    required Widget content,
    Widget? icon,
    bool keyboard = true,
    bool mask = true,
    bool maskClosable = false,
    String okText = '确定',
    ButtonType okType = ButtonType.primary,
    required Widget title,
    double width = 416,
    void Function()? onCancel,
    void Function()? onOk,
  }) {
    showDialog(
      context: context,
      builder: (_) => _Modal(
        cancelText: cancelText,
        centered: centered,
        closable: closable,
        content: content,
        keyboard: keyboard,
        mask: mask,
        maskClosable: maskClosable,
        okText: okText,
        okType: okType,
        title: title,
        width: width,
      ),
    );
  }
}

class _Modal extends StatelessWidget {
  const _Modal({
    Key? key,
    this.afterClose,
    required this.cancelText,
    required this.centered,
    required this.closable,
    this.closeIcon,
    required this.content,
    this.icon,
    required this.keyboard,
    required this.mask,
    required this.maskClosable,
    required this.okText,
    required this.okType,
    required this.title,
    required this.width,
    this.onCancel,
    this.onOk,
  }) : super(key: key);

  final void Function()? afterClose;
  final String cancelText;
  final bool centered;
  final bool closable;
  final Widget? closeIcon;
  final Widget content;
  final Widget? icon;
  final bool keyboard;
  final bool mask;
  final bool maskClosable;
  final String okText;
  final ButtonType okType;
  final Widget title;
  final double width;
  final void Function()? onCancel;
  final void Function()? onOk;

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.gray_4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultTextStyle.merge(
            child: title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              child: closeIcon ??
                  const Icon(Icons.close, color: Colors.gray_5, size: 16),
              onTap: () => _handleCancel(context),
            ),
          ),
        ],
      ),
    );

    Widget footer = Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.gray_4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
            child: Text(cancelText),
            onClick: () => _handleCancel(context),
          ),
          const SizedBox(width: 8),
          Button(
            type: okType,
            onClick: () => _handleOk(context),
            child: Text(okText),
          ),
        ],
      ),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Material(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                Padding(padding: const EdgeInsets.all(24), child: content),
                footer,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    onCancel?.call();
    Navigator.of(context).pop();
    afterClose?.call();
  }

  void _handleOk(BuildContext context) {
    onOk?.call();
    Navigator.of(context).pop();
    afterClose?.call();
  }
}
