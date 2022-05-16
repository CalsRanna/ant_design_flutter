import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/enum/theme.dart';
import 'package:flutter/widgets.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
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
    this.onSelect,
  }) : super(key: key);

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
  late String current;

  @override
  void initState() {
    super.initState();
    setState(() {
      current = widget.selectedKeys?.first ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MenuInhertedWidget(
      current: current,
      indent: widget.inlineIndent,
      inlineCollapsed: widget.inlineCollapsed ?? false,
      mode: widget.mode,
      theme: widget.theme,
      updateCurrent: _updateCurrent,
      onClick: widget.onClick,
      onSelect: widget.onSelect,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: widget.mode == MenuMode.horizontal
                ? const BorderSide(color: Colors.gray_4)
                : BorderSide.none,
            right: widget.mode != MenuMode.horizontal
                ? const BorderSide(color: Colors.gray_4)
                : BorderSide.none,
          ),
          color: widget.theme == Theme.dark ? Colors.black : Colors.white,
        ),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: widget.mode == MenuMode.horizontal
              ? Axis.horizontal
              : Axis.vertical,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    var children = <Widget>[];
    for (var child in widget.children) {
      if (child is MenuItem) {
        children.add(child);
      } else if (child is MenuDivider) {
        children.add(child);
      } else if (child is MenuItemGroup) {
        children.add(child);
      }
    }
    return children;
  }

  void _updateCurrent(String name) {
    setState(() {
      current = name;
    });
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
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    var current = _MenuInhertedWidget.of(context)!.current;
    var indent = _MenuInhertedWidget.of(context)!.indent;
    var inlineCollapsed = _MenuInhertedWidget.of(context)!.inlineCollapsed;
    var mode = _MenuInhertedWidget.of(context)!.mode;
    var theme = _MenuInhertedWidget.of(context)!.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        hovered = true;
      }),
      onExit: (_) => setState(() {
        hovered = false;
      }),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          decoration: BoxDecoration(
            border: current == widget.name
                ? Border(
                    bottom: MenuMode.horizontal == mode
                        ? const BorderSide(color: Colors.blue_6, width: 2)
                        : BorderSide.none,
                    right: MenuMode.horizontal != mode
                        ? const BorderSide(color: Colors.blue_6, width: 3)
                        : BorderSide.none,
                  )
                : null,
            color: Theme.light == theme
                ? widget.name == current
                    ? Colors.blue_1
                    : Colors.white
                : widget.name == current
                    ? Colors.blue_6
                    : Colors.black,
          ),
          padding: EdgeInsets.symmetric(horizontal: indent, vertical: 13),
          width: mode == MenuMode.horizontal
              ? null
              : inlineCollapsed
                  ? 80
                  : double.infinity,
          child: DefaultTextStyle.merge(
            child: widget.child,
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(
              color: Theme.light == theme
                  ? hovered || widget.name == current
                      ? Colors.blue_6
                      : Colors.black
                  : hovered || widget.name == current
                      ? Colors.white
                      : Colors.gray_4,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    var current = _MenuInhertedWidget.of(context)!.current;
    var onClick = _MenuInhertedWidget.of(context)!.onClick;
    var onSelect = _MenuInhertedWidget.of(context)!.onSelect;
    if (current != widget.name) {
      onClick?.call(widget, widget.name);
      onSelect?.call(widget, widget.name, [current]);
    }
    _MenuInhertedWidget.of(context)!.updateCurrent(widget.name);
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
  const MenuItemGroup({Key? key, required this.children, this.label})
      : super(key: key);

  final List<Widget> children;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    var indent = _MenuInhertedWidget.of(context)!.indent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.gray_4),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: indent),
                padding: const EdgeInsets.symmetric(vertical: 13),
                width: double.infinity,
                child: DefaultTextStyle.merge(
                  child: label!,
                  style: const TextStyle(color: Colors.gray_7),
                ),
              )
            : const SizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
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

class _MenuInhertedWidget extends InheritedWidget {
  final String current;
  final double indent;
  final bool inlineCollapsed;
  final MenuMode mode;
  final void Function(MenuItem item, String name)? onClick;
  final void Function(
    MenuItem item,
    String name,
    List<String> selectedKeys,
  )? onSelect;
  final Theme theme;
  final void Function(String name) updateCurrent;

  const _MenuInhertedWidget({
    required Widget child,
    required this.current,
    required this.indent,
    required this.inlineCollapsed,
    required this.mode,
    required this.theme,
    required this.updateCurrent,
    this.onClick,
    this.onSelect,
    Key? key,
  }) : super(child: child, key: key);

  static _MenuInhertedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_MenuInhertedWidget>();
  }

  @override
  bool updateShouldNotify(_MenuInhertedWidget oldWidget) {
    return oldWidget.current != current;
  }
}
