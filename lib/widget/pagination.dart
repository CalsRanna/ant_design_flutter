import 'package:flutter/widgets.dart';

class Pagination extends StatefulWidget {
  const Pagination({
    Key? key,
    this.current,
    this.defaultCurrent = 1,
    this.defaultPageSize = 10,
    this.disabled,
    this.hideOnSinglePage = false,
    this.itemBuilder,
    this.pageSize,
    this.pageSizeOptions = const [10, 20, 50, 100],
    this.responsive,
    this.showLessItems = false,
    this.showQuickJumper,
    this.showSizeChanger,
    this.showTitle = true,
    this.simple,
    this.size = PaginationSize.medium,
    this.total = 0,
    this.onChange,
    this.onShowSizeChange,
  }) : super(key: key);

  final int? current;
  final int defaultCurrent;
  final int defaultPageSize;
  final bool? disabled;
  final bool hideOnSinglePage;
  final Widget Function(int page)? itemBuilder;
  final int? pageSize;
  final List<int> pageSizeOptions;
  final bool? responsive;
  final bool showLessItems;
  final QuickJumper? showQuickJumper;
  final bool? showSizeChanger;
  final bool showTitle;
  final bool? simple;
  final PaginationSize size;
  final int total;
  final void Function(int page, int pageSize)? onChange;
  final void Function(int current, int size)? onShowSizeChange;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class QuickJumper {
  QuickJumper({required this.goButton});

  Widget goButton;
}

enum PaginationSize { medium, small }
