import 'package:ant_design_flutter/antdf.dart';

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
      child: widget.message,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue_3),
          borderRadius: BorderRadius.circular(2),
          color: Colors.blue_1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
    );
  }
}
