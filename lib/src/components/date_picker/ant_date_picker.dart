import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 日期选择组件。
///
/// 对齐 AntD v5 `DatePicker`。MVP 实现：
/// - `value` / `onChanged`：受控选择
/// - `placeholder`：占位符
/// - 日历面板导航（上/下月）
///
/// 推迟到 2.1：`format`、`disabledDate`、`allowClear`、`showTime`、
/// `picker`（week/month/quarter/year）、`disabled`、`range`。
class AntDatePicker extends StatefulWidget {
  const AntDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder = '选择日期',
    this.disabled = false,
  });

  /// 选中日期。
  final DateTime? value;

  /// 选中回调。
  final ValueChanged<DateTime>? onChanged;

  /// 占位符。
  final String placeholder;

  /// 是否禁用。
  final bool disabled;

  @override
  State<AntDatePicker> createState() => _AntDatePickerState();
}

class _AntDatePickerState extends State<AntDatePicker> {
  bool _open = false;

  /// 日历面板当前浏览的年月。
  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();
    _viewMonth = _monthStart(widget.value ?? DateTime.now());
  }

  DateTime _monthStart(DateTime d) =>
      DateTime(d.year, d.month, 1);

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _prevMonth() => setState(() {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1, 1);
      });

  void _nextMonth() => setState(() {
        _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
      });

  void _selectDate(DateTime d) {
    widget.onChanged?.call(d);
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);

    return AntPortal(
      placement: AntPlacement.bottomLeft,
      visible: _open,
      offset: const Offset(0, 4),
      child: AntInteractionDetector(
        enabled: !widget.disabled,
        cursor: SystemMouseCursors.click,
        onTap: () => setState(() => _open = !_open),
        builder: (context, states) {
          final borderColor = states.contains(WidgetState.focused)
              ? alias.colorPrimary
              : alias.colorBorder;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: alias.colorBackgroundContainer,
              borderRadius: BorderRadius.circular(alias.borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.value != null
                      ? _formatDate(widget.value!)
                      : widget.placeholder,
                  style: TextStyle(
                    color: widget.value != null
                        ? alias.colorText
                        : alias.colorTextTertiary,
                    fontSize: alias.fontSize,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '📅',
                  style: TextStyle(
                    color: alias.colorTextTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      overlayBuilder: (context) => _CalendarPanel(
        viewMonth: _viewMonth,
        selected: widget.value,
        alias: alias,
        onPrev: _prevMonth,
        onNext: _nextMonth,
        onSelect: _selectDate,
      ),
    );
  }
}

class _CalendarPanel extends StatelessWidget {
  const _CalendarPanel({
    required this.viewMonth,
    required this.selected,
    required this.alias,
    required this.onPrev,
    required this.onNext,
    required this.onSelect,
  });

  final DateTime viewMonth;
  final DateTime? selected;
  final AntAliasToken alias;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onSelect;

  static const _weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final year = viewMonth.year;
    final month = viewMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon ... 7=Sun

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alias.colorBackgroundElevated,
        borderRadius: BorderRadius.circular(alias.borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: month/year + navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPrev,
                child: Text('‹',
                    style: TextStyle(
                        color: alias.colorText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              Text(
                '$year 年 $month 月',
                style: TextStyle(
                  color: alias.colorText,
                  fontSize: alias.fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onNext,
                child: Text('›',
                    style: TextStyle(
                        color: alias.colorText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final label in _weekdayLabels)
                SizedBox(
                  width: 32,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: alias.colorTextTertiary,
                      fontSize: alias.fontSize - 2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Day grid
          ..._buildWeeks(daysInMonth, firstWeekday),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(int daysInMonth, int firstWeekday) {
    final weeks = <Widget>[];
    var day = 1;
    // Convert Mon=1...Sun=7 to grid offset (0=Mon)
    var col = firstWeekday - 1;

    while (day <= daysInMonth) {
      final row = <Widget>[];
      for (var c = 0; c < 7; c++) {
        if (c < col || day > daysInMonth) {
          row.add(const SizedBox(width: 32, height: 32));
        } else {
          final currentDay = day;
          final date = DateTime(viewMonth.year, viewMonth.month, currentDay);
          final isSelected = selected != null &&
              selected!.year == date.year &&
              selected!.month == date.month &&
              selected!.day == date.day;

          row.add(
            GestureDetector(
              onTap: () => onSelect(date),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? alias.colorPrimary : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '$currentDay',
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFFFFFFF)
                          : alias.colorText,
                      fontSize: alias.fontSize - 2,
                    ),
                  ),
                ),
              ),
            ),
          );
          day++;
        }
      }
      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: row,
          ),
        ),
      );
      col = 0;
    }
    return weeks;
  }
}
