import 'package:ant_design_flutter/src/enum/status.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/widgets.dart';

class Alert extends StatefulWidget {
  const Alert({
    Key? key,
    this.action,
    this.afterClose,
    this.banner = false,
    this.closable,
    this.closeText,
    this.closeIcon = const Icon(Icons.close),
    this.description,
    this.icon,
    required this.message,
    this.showIcon = false,
    this.type = Status.info,
    this.onClose,
  }) : super(key: key);

  final Widget? action;
  final void Function()? afterClose;
  final bool banner;
  final bool? closable;
  final Widget? closeText;
  final Widget closeIcon;
  final Widget? description;
  final Widget? icon;
  final Widget message;
  final bool showIcon;
  final Status type;
  final void Function()? onClose;

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue_3),
        borderRadius: BorderRadius.circular(2),
        color: Colors.blue_1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: widget.message,
    );
  }
}
