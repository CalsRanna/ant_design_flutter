import 'package:flutter/widgets.dart';

class PageHeader extends StatefulWidget {
  const PageHeader({
    Key? key,
    this.avatar,
    this.backIcon,
    required this.breadcrumb,
    this.breadcrumbBuilder,
    this.extra,
    this.footer,
    this.ghost = false,
    this.subTitle,
    this.tags,
    this.title,
    this.onBack,
  }) : super(key: key);

  final Widget? avatar;
  final Widget? backIcon;
  final Widget breadcrumb;
  final Widget Function()? breadcrumbBuilder;
  final Widget? extra;
  final Widget? footer;
  final bool ghost;
  final Widget? subTitle;
  final List<Widget>? tags;
  final Widget? title;
  final void Function()? onBack;

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
