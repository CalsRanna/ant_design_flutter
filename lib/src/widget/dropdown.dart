import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/widget/button.dart';
import 'package:flutter/widgets.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({
    Key? key,
    required this.child,
    this.arrow,
    this.disabled,
    this.getPopupContainer,
    required this.overlay,
    this.placement = Alignment.bottomLeft,
    this.trigger = const [DropdownTrigger.hover],
    required this.visible,
    this.onVisibleChange,
  }) : super(key: key);

  final Widget child;
  final DropdownArrow? arrow;
  final bool? disabled;
  final Widget Function(Widget triggerNode)? getPopupContainer;
  final Widget overlay;
  final Alignment placement;
  final List<DropdownTrigger> trigger;
  final bool visible;
  final void Function(bool visible)? onVisibleChange;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DropdownArrow {
  DropdownArrow({required this.pointAtCenter});
  bool pointAtCenter;
}

enum DropdownTrigger { click, hover, contextMenu }

class DropdownButton extends StatefulWidget {
  const DropdownButton(
      {Key? key,
      required this.child,
      this.buttonsBuilder,
      this.loading = false,
      this.icon,
      required this.overlay,
      this.placement = Alignment.bottomLeft,
      this.size = Size.middle,
      this.trigger = const [DropdownTrigger.hover],
      this.type = ButtonType.normal,
      required this.visible,
      this.onClick,
      this.onVisibleChange})
      : super(key: key);

  final Widget child;
  final List<Widget> Function()? buttonsBuilder;
  final bool loading;
  final Widget? icon;
  final Widget overlay;
  final Alignment placement;
  final Size size;
  final List<DropdownTrigger> trigger;
  final ButtonType type;
  final bool visible;
  final void Function()? onClick;
  final void Function(bool visible)? onVisibleChange;

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
