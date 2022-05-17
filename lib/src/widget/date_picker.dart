import 'package:flutter/widgets.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = false,
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.defaultPickerValue,
    this.defaultValue,
    this.disabledTime,
    this.format = 'YYYY-MM-DD',
    this.extraFooterBuilder,
    this.showNow,
    this.showTime,
    this.showToday = true,
    this.value,
    this.onChange,
    this.onOk,
  })  : monthCellBuilder = null,
        super(key: key);

  const DatePicker.year({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = false,
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.defaultPickerValue,
    this.defaultValue,
    this.format = 'YYYY',
    this.extraFooterBuilder,
    this.value,
    this.onChange,
  })  : disabledTime = null,
        showNow = null,
        showTime = null,
        showToday = false,
        onOk = null,
        monthCellBuilder = null,
        super(key: key);

  const DatePicker.quarter({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = false,
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.defaultPickerValue,
    this.defaultValue,
    this.format = 'YYYY-QQ',
    this.extraFooterBuilder,
    this.value,
    this.onChange,
  })  : disabledTime = null,
        showNow = null,
        showTime = null,
        showToday = false,
        onOk = null,
        monthCellBuilder = null,
        super(key: key);

  const DatePicker.month({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = false,
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.defaultPickerValue,
    this.defaultValue,
    this.format = 'YYYY-MM',
    this.monthCellBuilder,
    this.extraFooterBuilder,
    this.value,
    this.onChange,
  })  : disabledTime = null,
        showNow = null,
        showTime = null,
        showToday = false,
        onOk = null,
        super(key: key);

  const DatePicker.week({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = false,
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.defaultPickerValue,
    this.defaultValue,
    this.format = 'YYYY-WW',
    this.extraFooterBuilder,
    this.value,
    this.onChange,
  })  : disabledTime = null,
        showNow = null,
        showTime = null,
        showToday = false,
        onOk = null,
        monthCellBuilder = null,
        super(key: key);

  final bool allowClear;
  final bool autoFocus;
  final bool bordered;
  final Widget Function(DateTime currentDate, DateTime today)? dateBuilder;
  final bool disabled;
  final bool Function(DateTime currentDate)? disabledDate;
  final Widget Function()? getPopupContainer;
  final bool inputReadOnly;
  final DatePickerMode? mode;
  final Widget? nextIcon;
  final bool? open;
  final Widget Function()? panelBuilder;
  final Picker picker;
  final String? placeholder;
  final Alignment placement;
  final Widget? prevIcon;
  final DatePickerSize size;
  final DatePickerStatus? status;
  final Widget? suffixIcon;
  final Widget? superNextIcon;
  final Widget? superPrevIcon;
  final void Function(bool open)? onOpenChange;
  final void Function(DateTime value, DatePickerMode mode)? onPanelChange;
  final DateTime? defaultPickerValue;
  final DateTime? defaultValue;
  final bool Function(DateTime date)? disabledTime;
  final String format;
  final Widget Function(DatePickerMode mode)? extraFooterBuilder;
  final bool? showNow;
  final bool? showTime;
  final bool showToday;
  final DateTime? value;
  final void Function(DateTime date, String dateString)? onChange;
  final void Function()? onOk;
  final void Function(DateTime date)? monthCellBuilder;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum DatePickerMode { time, date, month, year, decade }

enum Picker { date, week, month, quarter, year }

enum DatePickerSize { large, middle, small }

enum DatePickerStatus { error, warning }

class RangePicker extends StatefulWidget {
  const RangePicker({
    Key? key,
    this.allowClear = true,
    this.autoFocus = false,
    this.bordered = true,
    this.dateBuilder,
    this.disabled = const [],
    this.disabledDate,
    this.getPopupContainer,
    this.inputReadOnly = false,
    this.mode,
    this.nextIcon,
    this.open,
    this.panelBuilder,
    this.picker = Picker.date,
    this.placeholder,
    this.placement = Alignment.bottomLeft,
    this.prevIcon,
    this.size = DatePickerSize.middle,
    this.status,
    this.suffixIcon,
    this.superNextIcon,
    this.superPrevIcon,
    this.onOpenChange,
    this.onPanelChange,
    this.allowEmpty = const [false, false],
    this.defaultPickerValue = const [],
    this.defaultValue = const [],
    this.disabledTime,
    this.format = 'YYYY-MM-DD HH:mm:ss',
    this.ranges,
    this.extraFooterBuilder,
    this.separator,
    this.showTime,
    this.value,
    this.onCalendarChange,
    this.onChange,
  }) : super(key: key);

  final bool allowClear;
  final bool autoFocus;
  final bool bordered;
  final Widget Function(
      DateTime currentDate, DateTime today, RangePickerInfo info)? dateBuilder;
  final List<bool> disabled;
  final bool Function(DateTime currentDate)? disabledDate;
  final Widget Function()? getPopupContainer;
  final bool inputReadOnly;
  final DatePickerMode? mode;
  final Widget? nextIcon;
  final bool? open;
  final Widget Function()? panelBuilder;
  final Picker picker;
  final String? placeholder;
  final Alignment placement;
  final Widget? prevIcon;
  final DatePickerSize size;
  final DatePickerStatus? status;
  final Widget? suffixIcon;
  final Widget? superNextIcon;
  final Widget? superPrevIcon;
  final void Function(bool open)? onOpenChange;
  final void Function(DateTime value, DatePickerMode mode)? onPanelChange;
  final List<bool> allowEmpty;
  final List<DateTime> defaultPickerValue;
  final List<DateTime> defaultValue;
  final bool Function(DateTime date, RangePickerPartical partical)?
      disabledTime;
  final String format;
  final List<DateTime>? ranges;
  final Widget Function(DatePickerMode mode)? extraFooterBuilder;
  final Widget? separator;
  final bool? showTime;
  final List<DateTime>? value;
  final void Function(
    List<DateTime> dates,
    List<String> dateStrings,
    RangePickerInfo info,
  )? onCalendarChange;
  final void Function(List<DateTime> dates, List<String> dateStrings)? onChange;

  @override
  State<RangePicker> createState() => _RangePickerState();
}

class _RangePickerState extends State<RangePicker> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RangePickerInfo {
  RangePickerInfo({required this.info});

  RangePickerPartical info;
}

enum RangePickerPartical { start, end }
