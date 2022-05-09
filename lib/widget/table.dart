import 'package:ant_design_flutter/antdf.dart';

class AntTable<T> extends StatefulWidget {
  const AntTable({
    Key? key,
    this.bordered = false,
    required this.columns,
    required this.dataSource,
  }) : super(key: key);

  final bool bordered;
  final List<AntTableColumn> columns;
  final List<T> dataSource;

  @override
  State<AntTable> createState() => _AntTableState();
}

class _AntTableState extends State<AntTable> {
  int? hoveredRow;

  @override
  Widget build(BuildContext context) {
    TableRow header = TableRow(
      children: widget.columns.map((column) {
        return Container(
          child: Text(
            column.title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          padding: const EdgeInsets.all(16),
        );
      }).toList(),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.gray_4)),
        color: Colors.gray_3,
      ),
    );

    List<TableRow> rows = [];
    for (var i = 0; i < widget.dataSource.length; i++) {
      rows.add(
        TableRow(
          children: widget.columns.map((column) {
            return MouseRegion(
              child: GestureDetector(
                child: Container(
                  child: _buildCell(widget.dataSource[i], column),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              onEnter: (_) => setState(() => hoveredRow = i),
              onExit: (_) => setState(() => hoveredRow = null),
            );
          }).toList(),
          decoration: BoxDecoration(
            border: const Border(bottom: BorderSide(color: Colors.gray_4)),
            color: i == hoveredRow ? Colors.gray_3 : null,
          ),
        ),
      );
    }

    Map<int, TableColumnWidth> widths = {};
    for (var i = 0; i < widget.columns.length; i++) {
      if (widget.columns[i].width != null) {
        widths[i] = FixedColumnWidth(widget.columns[i].width!);
      }
    }

    return Table(
      columnWidths: widths,
      children: [header, ...rows],
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    );
  }

  Widget _buildCell(dynamic data, AntTableColumn column) {
    return column.render?.call(data) ??
        Text(
          column.dataIndex != null
              ? data.toJson()[column.dataIndex].toString()
              : '',
        );
  }
}

class AntTableColumn {
  const AntTableColumn({
    this.alignment = Alignment.centerLeft,
    this.colSpan,
    this.dataIndex,
    this.render,
    required this.title,
    this.width,
  });

  final Alignment alignment;
  final double? colSpan;
  final String? dataIndex;
  final Widget Function(dynamic record)? render;
  final String title;
  final double? width;
}
