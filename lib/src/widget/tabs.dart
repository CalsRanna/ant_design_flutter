import 'package:ant_design_flutter/src/enum/placement.dart';
import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Tabs extends StatefulWidget {
  const Tabs({
    Key? key,
    this.addIcon,
    this.animated = true,
    this.centered = false,
    required this.children,
    this.controller,
    this.hideAdd = false,
    this.moreIcon,
    this.renderTabBar,
    this.size = Size.medium,
    this.tabBarExtraContent,
    this.tabBarGutter,
    this.tabPosition = Placement.top,
    this.destroyInactiveTab = false,
    this.type = TabsType.line,
    this.onChange,
    this.onEdit,
    this.onTabClick,
    this.onTabScroll,
  }) : super(key: key);

  final Widget? addIcon;
  final bool animated;
  final bool centered;
  final List<TabPane> children;
  final TabsController? controller;
  final bool hideAdd;
  final Widget? moreIcon;
  final Widget Function()? renderTabBar;
  final Size size;
  final Widget? tabBarExtraContent;
  final double? tabBarGutter;
  final Placement tabPosition;
  final bool destroyInactiveTab;
  final TabsType type;
  final void Function(String activeKey)? onChange;
  final void Function()? onEdit;
  final void Function(String key)? onTabClick;
  final void Function()? onTabScroll;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  String? activeKey;

  @override
  void initState() {
    super.initState();
    setState(() {
      activeKey = widget.controller?.activeKey ?? widget.children.first.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget header = Container(
      child: Row(
        children: widget.children
            .map((child) => _TabHeader(
                disabled: child.disabled, name: child.name, tab: child.tab))
            .toList(),
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.gray_3)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
    );

    return _TabsInhertedWidget(
      activeKey: activeKey,
      child: Column(
        children: <Widget>[
          header,
          Stack(
            children: widget.children
                .map((child) =>
                    Visibility(child: child, visible: child.name == activeKey))
                .toList(),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onClick: (name) => setState(() => activeKey = name),
    );
  }
}

class _TabHeader extends StatefulWidget {
  const _TabHeader(
      {Key? key, required this.disabled, required this.name, required this.tab})
      : super(key: key);

  final bool disabled;
  final String name;
  final Widget tab;

  @override
  State<_TabHeader> createState() => __TabHeaderState();
}

class __TabHeaderState extends State<_TabHeader> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    var activeKey = _TabsInhertedWidget.of(context)!.activeKey;

    return MouseRegion(
      child: GestureDetector(
        child: Container(
          child: Padding(
            child: DefaultTextStyle.merge(
              child: widget.tab,
              style: TextStyle(
                color: widget.disabled
                    ? Colors.gray_3
                    : widget.name == activeKey
                        ? Colors.blue_6
                        : null,
              ),
            ),
            padding: const EdgeInsets.all(12),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.name == activeKey ? Colors.blue_6 : Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
        onTap: _handleTap,
      ),
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
    );
  }

  void _handleTap() {
    var onClick = _TabsInhertedWidget.of(context)!.onClick;
    if (!widget.disabled) {
      onClick(widget.name);
    }
  }
}

class _TabsInhertedWidget extends InheritedWidget {
  final String? activeKey;
  final void Function(String name) onClick;

  const _TabsInhertedWidget(
      {required this.activeKey, required Widget child, required this.onClick})
      : super(child: child);

  static _TabsInhertedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TabsInhertedWidget>();
  }

  @override
  bool updateShouldNotify(_TabsInhertedWidget oldWidget) {
    return oldWidget.activeKey != activeKey;
  }
}

class TabPane extends StatelessWidget {
  const TabPane({
    Key? key,
    this.child,
    this.closeIcon,
    this.disabled = false,
    this.forceRender = false,
    required this.name,
    required this.tab,
  }) : super(key: key);

  final Widget? child;
  final Widget? closeIcon;
  final bool disabled;
  final bool forceRender;
  final String name;
  final Widget tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}

class TabsController extends ChangeNotifier {
  String? activeKey;
}

enum TabsType { line, card, editableCard }
