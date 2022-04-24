import 'package:ant_design_flutter/style/color.dart';
import 'package:flutter/widgets.dart';

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    Key? key,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.params,
    this.routes,
    this.separator,
  }) : super(key: key);

  final List<Widget>? children;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int? itemCount;
  final Map? params;
  final List<AntRoute>? routes;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return BreadcrumbInhertedWidget(
      current: _getCurrent(context),
      child: Row(
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    var _separator = separator ??
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: TextStyle(color: Colors.gray_7, height: 1),
          ),
        );
    final List<Widget> _children = <Widget>[];
    if (itemBuilder != null && itemCount != null) {
      for (int i = 0; i < itemCount!; i++) {
        _children.add(itemBuilder!(context, i));
      }
    } else {
      if (children != null) {
        for (int i = 0; i < children!.length; i++) {
          _children.add(children![i]);
          if (i != children!.length - 1) {
            _children.add(_separator);
          }
        }
      }
    }
    return _children;
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
    var current = BreadcrumbInhertedWidget.of(context)!.current;
    return widget.href != current
        ? MouseRegion(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: hovered ? Colors.blue_6 : Colors.gray_7,
              ),
              child: widget.child,
            ),
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
          )
        : DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.black),
            child: widget.child,
          );
  }
}

class AntRoute {
  AntRoute({
    required this.path,
    required this.breadcrumbName,
    this.children,
  });

  String path;
  String breadcrumbName;
  List<AntRoute>? children;
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

class BreadcrumbInhertedWidget extends InheritedWidget {
  const BreadcrumbInhertedWidget({
    Key? key,
    required this.current,
    required Widget child,
  }) : super(key: key, child: child);

  final String current;

  static BreadcrumbInhertedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BreadcrumbInhertedWidget>();
  }

  @override
  bool updateShouldNotify(BreadcrumbInhertedWidget oldWidget) {
    return oldWidget.current != current;
  }
}
