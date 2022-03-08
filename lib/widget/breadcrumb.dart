import 'package:flutter/widgets.dart';

class Breadcrumb extends StatefulWidget {
  const Breadcrumb({
    Key? key,
    required this.children,
    this.itemBuilder,
    this.params,
    this.routes,
    this.separator,
  }) : super(key: key);

  final List<BreadcrumbItem> children;
  final Widget Function()? itemBuilder;
  final Map? params;
  final List<AntRoute>? routes;
  final Widget? separator;

  @override
  State<Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<Breadcrumb> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BreadcrumbItem extends StatelessWidget {
  const BreadcrumbItem({
    Key? key,
    required this.child,
    this.dropdown,
    this.href = '#',
    this.overlay,
    this.onClick,
  }) : super(key: key);

  final Widget child;
  final Widget? dropdown;
  final String href;
  final Widget? overlay;
  final void Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Container();
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
    return Container();
  }
}
