import 'package:ant_design_flutter/style/theme.dart';
import 'package:flutter/widgets.dart';

class Menu extends StatefulWidget {
  const Menu(
      {Key? key,
      required this.children,
      this.defaultOpenKeys,
      this.defaultSelectedKeys,
      this.expandIcon,
      this.forceSubMenuRender = false,
      this.inlineCollapsed,
      this.inlineIndent = 24,
      this.mode = MenuMode.vertical,
      this.multiple = false,
      this.openKeys,
      this.overflowIndicator,
      this.selectable = true,
      this.selectedKeys,
      this.subMenuCloseDelay = 100,
      this.subMenuOpenDelay = 0,
      this.theme = Theme.light,
      this.triggerSubMenuAction = SubMenuAction.hover,
      this.onClick,
      this.onDeselect,
      this.onOpenChange,
      this.onSelect})
      : super(key: key);

  final List<Widget> children;
  final List<String>? defaultOpenKeys;
  final List<String>? defaultSelectedKeys;
  final Widget? expandIcon;
  final bool forceSubMenuRender;
  final bool? inlineCollapsed;
  final double inlineIndent;
  final MenuMode mode;
  final bool multiple;
  final List<String>? openKeys;
  final Widget? overflowIndicator;
  final bool selectable;
  final List<String>? selectedKeys;
  final double subMenuCloseDelay;
  final double subMenuOpenDelay;
  final Theme theme;
  final SubMenuAction triggerSubMenuAction;
  final void Function(MenuItem item, String key)? onClick;
  final void Function(
    MenuItem item,
    String key,
    List<String> selectedKeys,
  )? onDeselect;
  final void Function(List<String> openKeys)? onOpenChange;
  final void Function(
    MenuItem item,
    String key,
    List<String> selectedKeys,
  )? onSelect;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum MenuMode { vertical, horizontal, inline }
enum SubMenuAction { hover, click }

class MenuItem extends StatefulWidget {
  const MenuItem({
    Key? key,
    required this.child,
    this.danger = false,
    this.disabled = false,
    this.icon,
    required this.name,
    this.title,
  }) : super(key: key);

  final Widget child;
  final bool danger;
  final bool disabled;
  final Widget? icon;
  final String name;
  final String? title;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SubMenu extends StatelessWidget {
  const SubMenu({
    Key? key,
    required this.children,
    this.disabled = false,
    this.icon,
    required this.name,
    required this.popupOffset,
    this.title,
    this.onTitleClick,
    this.theme = Theme.light,
  }) : super(key: key);

  final List<Widget> children;
  final bool disabled;
  final Widget? icon;
  final String name;
  final Offset popupOffset;
  final Widget? title;
  final void Function(String name)? onTitleClick;
  final Theme theme;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MenuItemGroup extends StatelessWidget {
  const MenuItemGroup({Key? key, required this.children, this.title})
      : super(key: key);

  final List<Widget> children;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MenuDivider extends StatelessWidget {
  const MenuDivider({Key? key, this.dashed = false}) : super(key: key);

  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
