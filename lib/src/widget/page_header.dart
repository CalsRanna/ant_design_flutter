import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/widgets.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    this.avatar,
    this.backIcon = const Icon(Icons.arrow_left),
    this.breadcrumb,
    this.breadcrumbBuilder,
    this.extra,
    this.footer,
    this.ghost = false,
    this.subtitle,
    this.tags,
    required this.title,
    this.onBack,
  }) : super(key: key);

  final Widget? avatar;
  final Widget? backIcon;
  final Widget? breadcrumb;
  final Widget Function()? breadcrumbBuilder;
  final Widget? extra;
  final Widget? footer;
  final bool ghost;
  final Widget? subtitle;
  final List<Widget>? tags;
  final Widget title;
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        backIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: backIcon,
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: DefaultTextStyle.merge(
            child: title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        subtitle != null
            ? DefaultTextStyle.merge(
                child: subtitle!,
                style: const TextStyle(color: Colors.gray_6),
              )
            : const SizedBox(),
      ],
    );
  }
}
