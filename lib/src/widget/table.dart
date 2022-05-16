import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart' as widgets;

class Table<T> extends widgets.StatefulWidget {
  const Table({
    widgets.Key? key,
    this.bordered = false,
    required this.columns,
    required this.dataSource,
  }) : super(key: key);

  final bool bordered;
  final List<TableColumn> columns;
  final List<T> dataSource;

  @override
  widgets.State<Table> createState() => _TableState();
}

class _TableState extends widgets.State<Table> {
  int? hoveredRow;

  @override
  widgets.Widget build(widgets.BuildContext context) {
    widgets.TableRow header = widgets.TableRow(
      children: widget.columns.map((column) {
        return widgets.Container(
          padding: const widgets.EdgeInsets.all(16),
          child: widgets.Text(
            column.title,
            style: const widgets.TextStyle(fontWeight: widgets.FontWeight.w500),
          ),
        );
      }).toList(),
      decoration: const widgets.BoxDecoration(
        border:
            widgets.Border(bottom: widgets.BorderSide(color: Colors.gray_4)),
        color: Colors.gray_3,
      ),
    );

    List<widgets.TableRow> rows = [];
    for (var i = 0; i < widget.dataSource.length; i++) {
      rows.add(
        widgets.TableRow(
          children: widget.columns.map((column) {
            return widgets.MouseRegion(
              child: widgets.GestureDetector(
                child: widgets.Container(
                  padding: const widgets.EdgeInsets.all(16),
                  child: _buildCell(widget.dataSource[i], column),
                ),
              ),
              onEnter: (_) => setState(() => hoveredRow = i),
              onExit: (_) => setState(() => hoveredRow = null),
            );
          }).toList(),
          decoration: widgets.BoxDecoration(
            border: const widgets.Border(
                bottom: widgets.BorderSide(color: Colors.gray_4)),
            color: i == hoveredRow ? Colors.gray_3 : null,
          ),
        ),
      );
    }

    Map<int, widgets.TableColumnWidth> widths = {};
    for (var i = 0; i < widget.columns.length; i++) {
      if (widget.columns[i].width != null) {
        widths[i] = widgets.FixedColumnWidth(widget.columns[i].width!);
      }
    }

    return widgets.Column(
      children: [
        widgets.Table(
          columnWidths: widths,
          children: [header],
          defaultVerticalAlignment: widgets.TableCellVerticalAlignment.middle,
        ),
        widgets.Table(
          columnWidths: widths,
          children: rows,
          defaultVerticalAlignment: widgets.TableCellVerticalAlignment.middle,
        ),
      ],
    );
  }

  widgets.Widget _buildCell(dynamic data, TableColumn column) {
    return column.render?.call(data) ??
        widgets.Text(
          column.dataIndex != null
              ? data.toJson()[column.dataIndex].toString()
              : '',
        );
  }
}

class TableColumn {
  const TableColumn({
    this.alignment = widgets.Alignment.centerLeft,
    this.colSpan,
    this.dataIndex,
    this.render,
    required this.title,
    this.width,
  });

  final widgets.Alignment alignment;
  final double? colSpan;
  final String? dataIndex;
  final widgets.Widget Function(dynamic record)? render;
  final String title;
  final double? width;
}
