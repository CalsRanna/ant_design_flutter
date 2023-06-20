import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:ant_design_flutter/src/style/icon.dart';
import 'package:flutter/widgets.dart';

class Pagination extends StatefulWidget {
  const Pagination({
    Key? key,
    this.controller,
    this.current,
    this.defaultCurrent = 1,
    this.defaultPageSize = 10,
    this.disabled,
    this.hideOnSinglePage = false,
    this.itemBuilder,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 20, 50, 100],
    this.responsive,
    this.showLessItems = false,
    this.showQuickJumper,
    this.showSizeChanger,
    this.showTitle = true,
    this.simple,
    this.size = Size.middle,
    this.total = 0,
    this.onChange,
    this.onShowSizeChange,
  }) : super(key: key);

  final PaginationController? controller;
  final int? current;
  final int defaultCurrent;
  final int defaultPageSize;
  final bool? disabled;
  final bool hideOnSinglePage;
  final Widget Function(int page)? itemBuilder;
  final int pageSize;
  final List<int> pageSizeOptions;
  final bool? responsive;
  final bool showLessItems;
  final bool? showQuickJumper;
  final bool? showSizeChanger;
  final bool showTitle;
  final bool? simple;
  final Size size;
  final int total;
  final void Function(int page, int pageSize)? onChange;
  final void Function(int current, int size)? onShowSizeChange;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int current = 0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      setState(() {
        current = widget.controller!.current;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalPage = _calculateTotalPage();

    return _PaginationInhertedWidget(
      current: current,
      handleChange: _handleChange,
      onChange: widget.onChange,
      pageSize: widget.pageSize,
      totalPage: totalPage,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        children: [
          const _PaginationArrowItem(arrow: 'left'),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            children: List.generate(
              totalPage,
              (index) => _PaginationItem(page: index),
            ),
          ),
          const _PaginationArrowItem(arrow: 'right'),
        ],
      ),
    );
  }

  int _calculateTotalPage() {
    return (widget.total / widget.pageSize).ceil();
  }

  void _handleChange(int page) {
    if (widget.controller != null) {
      widget.controller!.current = page;
    }
    setState(() {
      current = page;
    });
  }
}

class PaginationController extends ChangeNotifier {
  int current = 0;
}

class _PaginationArrowItem extends StatefulWidget {
  const _PaginationArrowItem({Key? key, required this.arrow}) : super(key: key);

  final String arrow;

  @override
  State<_PaginationArrowItem> createState() => __PaginationArowItemState();
}

class __PaginationArowItemState extends State<_PaginationArrowItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _available()
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
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
            border: Border.all(
              color: _available()
                  ? hovered
                      ? Colors.blue_6
                      : Colors.gray_5
                  : Colors.gray_5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          height: 32,
          width: 32,
          child: Center(
            child: IconTheme.merge(
              child: Icon(widget.arrow == 'left'
                  ? Icons.chevron_left
                  : Icons.chevron_right),
              data: IconThemeData(
                color: _available()
                    ? hovered
                        ? Colors.blue_6
                        : Colors.black
                    : Colors.gray_5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _available() {
    bool available = true;
    var current = _PaginationInhertedWidget.of(context)?.current ?? 0;
    var totalPage = _PaginationInhertedWidget.of(context)!.totalPage ?? 0;
    if (widget.arrow == 'left' && current == 0) {
      available = false;
    } else if (widget.arrow == 'right' && current == totalPage - 1) {
      available = false;
    }
    return available;
  }

  void _handleTap() {
    var current = _PaginationInhertedWidget.of(context)?.current ?? 0;
    var handleChange = _PaginationInhertedWidget.of(context)!.handleChange;
    var totalPage = _PaginationInhertedWidget.of(context)!.totalPage ?? 0;

    var page = current - 1 >= 0 ? current - 1 : current;
    if (widget.arrow != 'left') {
      page = current + 1 <= totalPage - 1 ? current + 1 : current;
    }
    handleChange(page);
    var onChange = _PaginationInhertedWidget.of(context)?.onChange;
    var pageSize = _PaginationInhertedWidget.of(context)!.pageSize ?? 10;
    if (onChange != null) {
      onChange(page, pageSize);
    }
  }
}

class _PaginationItem extends StatefulWidget {
  const _PaginationItem({Key? key, required this.page}) : super(key: key);

  final int page;

  @override
  State<_PaginationItem> createState() => __PaginationItemState();
}

class __PaginationItemState extends State<_PaginationItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    var current = _PaginationInhertedWidget.of(context)?.current ?? 0;

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
            border: Border.all(
              color: current == widget.page || hovered
                  ? Colors.blue_6
                  : Colors.gray_5,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          height: 32,
          width: 32,
          child: Center(
              child: DefaultTextStyle.merge(
            child: Text('${widget.page + 1}'),
            style: TextStyle(
                color:
                    current == widget.page || hovered ? Colors.blue_6 : null),
          )),
        ),
      ),
    );
  }

  void _handleTap() {
    var handleChange = _PaginationInhertedWidget.of(context)!.handleChange;
    handleChange(widget.page);
    var onChange = _PaginationInhertedWidget.of(context)?.onChange;
    if (onChange != null) {
      onChange(
        widget.page,
        _PaginationInhertedWidget.of(context)?.pageSize ?? 10,
      );
    }
  }
}

class _PaginationInhertedWidget extends InheritedWidget {
  const _PaginationInhertedWidget({
    required Widget child,
    Key? key,
    this.current,
    required this.handleChange,
    this.onChange,
    this.pageSize,
    this.totalPage,
  }) : super(child: child, key: key);

  final int? current;
  final void Function(int current) handleChange;
  final void Function(int page, int pageSize)? onChange;
  final int? pageSize;
  final int? totalPage;

  static _PaginationInhertedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PaginationInhertedWidget>();
  }

  @override
  bool updateShouldNotify(_PaginationInhertedWidget oldWidget) {
    return oldWidget.current != current;
  }
}
