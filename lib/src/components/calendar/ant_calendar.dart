import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 日历。对齐 AntD v5 `Calendar`。MVP 显示月视图。
class AntCalendar extends StatefulWidget {
  const AntCalendar({super.key, this.value, this.onSelect});
  final DateTime? value; final ValueChanged<DateTime>? onSelect;
  @override
  State<AntCalendar> createState() => _AntCalendarState();
}

class _AntCalendarState extends State<AntCalendar> {
  late DateTime _viewMonth;
  @override
  void initState() { super.initState(); _viewMonth = DateTime(widget.value?.year ?? DateTime.now().year, widget.value?.month ?? DateTime.now().month, 1); }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_viewMonth.year, _viewMonth.month, 1).weekday;
    final borderSide = BorderSide(color: alias.colorSplit);

    return Column(children: [
      // Nav
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(onTap: () => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1)), child: const Text('‹', style: TextStyle(fontSize: 20))),
        Text('${_viewMonth.year}年${_viewMonth.month}月', style: TextStyle(fontWeight: FontWeight.w600, color: alias.colorText)),
        GestureDetector(onTap: () => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1)), child: const Text('›', style: TextStyle(fontSize: 20))),
      ]),
      // Weekday headers
      Row(children: ['一','二','三','四','五','六','日'].map((l) => Expanded(child: Container(padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border(bottom: borderSide)),
        child: Text(l, textAlign: TextAlign.center, style: TextStyle(color: alias.colorTextTertiary, fontSize: 12))),
      )).toList()),
      // Day grid
      ..._buildWeeks(daysInMonth, firstWeekday, alias, borderSide),
    ]);
  }

  List<Widget> _buildWeeks(int days, int start, AntAliasToken alias, BorderSide borderSide) {
    final weeks = <Widget>[]; int day = 1; int col = start - 1;
    while (day <= days) {
      final cells = <Widget>[];
      for (var c = 0; c < 7; c++) {
        if (c < col || day > days) {
          cells.add(const Expanded(child: SizedBox(height: 32)));
        } else {
          final d = day;
          cells.add(Expanded(child: GestureDetector(
            onTap: () => widget.onSelect?.call(DateTime(_viewMonth.year, _viewMonth.month, d)),
            child: Container(height: 32, decoration: BoxDecoration(border: Border(bottom: borderSide)),
              child: Center(child: Text('$d', style: TextStyle(color: alias.colorText, fontSize: 12)))),
          )));
          day++;
        }
      }
      weeks.add(Row(children: cells)); col = 0;
    }
    return weeks;
  }
}
