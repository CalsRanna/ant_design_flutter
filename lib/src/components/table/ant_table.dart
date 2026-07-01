import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 表格组件。
///
/// 对齐 AntD v5 `Table` 组件。MVP 实现：
/// - `columns`：列定义
/// - `data`：数据源（`List<Map<String, dynamic>>`）
/// - 排序（通过列 `sorter`）
/// - 斑马纹（通过 `striped`）
///
/// 推迟到 2.1：分页、虚拟滚动、`expandable`、`rowSelection`、`footer`、
/// `summary`、`sticky`、`scroll`、`filter`、泛型 `record` 类型。
class AntTable extends StatefulWidget {
  const AntTable({
    required this.columns,
    required this.data,
    super.key,
    this.striped = false,
  });

  final List<AntColumn> columns;
  final List<Map<String, dynamic>> data;
  final bool striped;

  @override
  State<AntTable> createState() => _AntTableState();
}

class _AntTableState extends State<AntTable> {
  (int, bool)? _sort;

  List<Map<String, dynamic>> get _sortedData {
    if (_sort == null) return widget.data;
    final (colIdx, asc) = _sort!;
    if (colIdx >= widget.columns.length) return widget.data;
    final col = widget.columns[colIdx];
    if (col.sorter == null) return widget.data;
    final sorted = List<Map<String, dynamic>>.of(widget.data)
      ..sort(col.sorter!);
    return asc ? sorted : sorted.reversed.toList();
  }

  void _toggleSort(int colIdx) {
    setState(() {
      if (_sort != null && _sort!.$1 == colIdx) {
        if (_sort!.$2) {
          _sort = (colIdx, false);
        } else {
          _sort = null;
        }
      } else {
        _sort = (colIdx, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final borderColor = alias.colorSplit;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor),
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              children: [
                for (var i = 0; i < widget.columns.length; i++)
                  _HeaderCell(
                    column: widget.columns[i],
                    index: i,
                    sort: _sort,
                    alias: alias,
                    borderColor: borderColor,
                    onTap: widget.columns[i].sorter != null
                        ? () => _toggleSort(i)
                        : null,
                  ),
              ],
            ),
          ),
          // Data rows
          for (var ri = 0; ri < _sortedData.length; ri++)
            _DataRow(
              record: _sortedData[ri],
              columns: widget.columns,
              index: ri,
              striped: widget.striped,
              alias: alias,
              borderColor: borderColor,
            ),
        ],
      ),
    );
  }
}

/// 表格列定义。
class AntColumn {
  const AntColumn({
    required this.title,
    required this.dataIndex,
    this.width,
    this.align = TextAlign.left,
    this.render,
    this.sorter,
  });

  final String title;
  final String dataIndex;
  final double? width;
  final TextAlign align;
  final Widget Function(dynamic value, Map<String, dynamic> record)? render;
  final int Function(Map<String, dynamic> a, Map<String, dynamic> b)? sorter;
}

// ---------- Internal widgets ----------

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.index,
    required this.sort,
    required this.alias,
    required this.borderColor,
    required this.onTap,
  });

  final AntColumn column;
  final int index;
  final (int, bool)? sort;
  final AntAliasToken alias;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSorted = sort != null && sort!.$1 == index;
    final asc = isSorted && sort!.$2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: column.width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: borderColor),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              column.title,
              style: TextStyle(
                color: alias.colorText,
                fontSize: alias.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (column.sorter != null) ...[
              const SizedBox(width: 4),
              Text(
                isSorted ? (asc ? '▲' : '▼') : '⇅',
                style: TextStyle(
                  color: isSorted
                      ? alias.colorPrimary
                      : alias.colorTextTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.record,
    required this.columns,
    required this.index,
    required this.striped,
    required this.alias,
    required this.borderColor,
  });

  final Map<String, dynamic> record;
  final List<AntColumn> columns;
  final int index;
  final bool striped;
  final AntAliasToken alias;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = striped && index.isEven
        ? alias.colorFillSecondary
        : alias.colorBackgroundContainer;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        children: [
          for (final col in columns)
            _DataCell(
              column: col,
              record: record,
              alias: alias,
              borderColor: borderColor,
            ),
        ],
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.column,
    required this.record,
    required this.alias,
    required this.borderColor,
  });

  final AntColumn column;
  final Map<String, dynamic> record;
  final AntAliasToken alias;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final value = record[column.dataIndex];

    Widget content;
    if (column.render != null) {
      content = column.render!(value, record);
    } else {
      content = Text(
        value?.toString() ?? '',
        style: TextStyle(
          color: alias.colorText,
          fontSize: alias.fontSize,
        ),
      );
    }

    return Container(
      width: column.width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: DefaultTextStyle(
        textAlign: column.align,
        style: TextStyle(
          color: alias.colorText,
          fontSize: alias.fontSize,
        ),
        child: content,
      ),
    );
  }
}
