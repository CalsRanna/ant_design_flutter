import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    Key? key,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.params,
    this.separator,
  }) : super(key: key);

  final List<Widget>? children;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int? itemCount;
  final Map? params;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return _BreadcrumbInhertedWidget(
      current: _getCurrent(context),
      child: Row(
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var realSeparator = separator ??
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: TextStyle(color: Colors.gray_7, height: 1),
          ),
        );
    final List<Widget> children = <Widget>[];
    if (itemBuilder != null && itemCount != null) {
      for (int i = 0; i < itemCount!; i++) {
        children.add(itemBuilder!(context, i));
        if (i != itemCount! - 1) {
          children.add(realSeparator);
        }
      }
    } else {
      for (int i = 0; i < children.length; i++) {
        children.add(children[i]);
        if (i != children.length - 1) {
          children.add(realSeparator);
        }
      }
    }
    return children;
  }

  String _getCurrent(BuildContext context) {
    BreadcrumbItem? currentWidget;
    if (itemBuilder != null && itemCount != null) {
      currentWidget = itemBuilder!(context, itemCount! - 1) as BreadcrumbItem;
    } else if (children != null) {
      currentWidget = children![children!.length - 1] as BreadcrumbItem;
    }
    return currentWidget?.href ?? '';
  }
}

class BreadcrumbItem extends StatefulWidget {
  const BreadcrumbItem({
    Key? key,
    required this.child,
    required this.href,
    this.onClick,
  }) : super(key: key);

  final Widget child;
  final String href;
  final void Function()? onClick;

  @override
  State<BreadcrumbItem> createState() => _BreadcrumbItemState();
}

class _BreadcrumbItemState extends State<BreadcrumbItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    var current = _BreadcrumbInhertedWidget.of(context)!.current;
    return widget.href != current
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                hovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                hovered = false;
              });
            },
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: hovered ? Colors.blue_6 : Colors.gray_7,
              ),
              child: widget.child,
            ),
          )
        : DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.black),
            child: widget.child,
          );
  }
}

class BreadcrumbSeparator extends StatelessWidget {
  const BreadcrumbSeparator({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '/',
        style: TextStyle(color: Colors.gray_7, height: 1),
      ),
    );
  }
}

class _BreadcrumbInhertedWidget extends InheritedWidget {
  const _BreadcrumbInhertedWidget({
    Key? key,
    required this.current,
    required Widget child,
  }) : super(key: key, child: child);

  final String current;

  static _BreadcrumbInhertedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_BreadcrumbInhertedWidget>();
  }

  @override
  bool updateShouldNotify(_BreadcrumbInhertedWidget oldWidget) {
    return oldWidget.current != current;
  }
}
