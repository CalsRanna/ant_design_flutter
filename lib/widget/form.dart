import 'package:ant_design_flutter/enum/placement.dart';
import 'package:ant_design_flutter/enum/size.dart';
import 'package:ant_design_flutter/widget/grid.dart';
import 'package:flutter/widgets.dart';

class AntForm<T> extends StatefulWidget {
  const AntForm({
    Key? key,
    required this.children,
    this.colon = true,
    required this.initialValues,
    this.labelAlign = Placement.right,
    this.labelWrap = false,
    this.labelCol,
    this.layout = AntFormLayout.horizontal,
    this.name,
    this.preserve = true,
    this.requiredMark = true,
    this.scrollToFirstError = false,
    this.size = AntSize.medium,
    this.validateMessages,
    this.validateTrigger = 'onChange',
    this.wrapperCol,
    this.onFieldsChange,
    this.onFinish,
    this.onFinishFailed,
    this.onValuesChange,
  }) : super(key: key);

  const AntForm.list({
    Key? key,
    required this.children,
    this.colon = true,
    required this.initialValues,
    this.labelAlign = Placement.right,
    this.labelWrap = false,
    this.labelCol,
    this.layout = AntFormLayout.horizontal,
    this.name,
    this.preserve = true,
    this.requiredMark = true,
    this.scrollToFirstError = false,
    this.size = AntSize.medium,
    this.validateMessages,
    this.validateTrigger = 'onChange',
    this.wrapperCol,
    this.onFieldsChange,
    this.onFinish,
    this.onFinishFailed,
    this.onValuesChange,
  }) : super(key: key);

  const AntForm.errorList({
    Key? key,
    required this.children,
    this.colon = true,
    required this.initialValues,
    this.labelAlign = Placement.right,
    this.labelWrap = false,
    this.labelCol,
    this.layout = AntFormLayout.horizontal,
    this.name,
    this.preserve = true,
    this.requiredMark = true,
    this.scrollToFirstError = false,
    this.size = AntSize.medium,
    this.validateMessages,
    this.validateTrigger = 'onChange',
    this.wrapperCol,
    this.onFieldsChange,
    this.onFinish,
    this.onFinishFailed,
    this.onValuesChange,
  }) : super(key: key);

  const AntForm.provider({
    Key? key,
    required this.children,
    this.colon = true,
    required this.initialValues,
    this.labelAlign = Placement.right,
    this.labelWrap = false,
    this.labelCol,
    this.layout = AntFormLayout.horizontal,
    this.name,
    this.preserve = true,
    this.requiredMark = true,
    this.scrollToFirstError = false,
    this.size = AntSize.medium,
    this.validateMessages,
    this.validateTrigger = 'onChange',
    this.wrapperCol,
    this.onFieldsChange,
    this.onFinish,
    this.onFinishFailed,
    this.onValuesChange,
  }) : super(key: key);

  final List<Widget> children;
  final bool colon;
  final T initialValues;
  final Placement labelAlign;
  final bool labelWrap;
  final AntColumnResponsiveOption? labelCol;
  final AntFormLayout layout;
  final String? name;
  final bool preserve;
  final bool requiredMark;
  final bool scrollToFirstError;
  final AntSize size;
  final ValidateMessages? validateMessages;
  final String validateTrigger;
  final AntColumnResponsiveOption? wrapperCol;
  final void Function(
    List<String> changedFields,
    List<String> allFields,
  )? onFieldsChange;
  final void Function(T values)? onFinish;
  final void Function(
    T values,
    List<String> errorFields,
    bool outOfDate,
  )? onFinishFailed;
  final void Function(
    List<String> changedValues,
    List<String> allValues,
  )? onValuesChange;

  @override
  State<AntForm> createState() => _AntFormState();
}

class _AntFormState extends State<AntForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum AntFormLayout { horizontal, vertical, inline }

class ValidateMessages {}

class Operation {
  Operation({this.add, this.move, this.remove});

  void Function(String defaultValue, int insertIndex)? add;
  void Function(int from, int to)? move;
  void Function(List<int> numbers)? remove;
}

class AntFormItem extends StatefulWidget {
  const AntFormItem({
    Key? key,
    required this.child,
    this.colon = true,
    this.extra,
    this.hasFeedback = false,
    this.help,
    this.hidden = false,
    this.htmlFor,
    this.initialValue,
    this.label,
    this.labelAlign = Placement.right,
    this.labelCol,
    this.messageVariables,
    this.name,
    this.normalize,
    this.noStyle = false,
    this.preserve = true,
    this.required = false,
    this.rules,
    this.tooltip,
    this.trigger = 'onChange',
    this.validateFirst = false,
    this.validateStatus,
    this.validateTrigger = 'onChange',
    this.valuePropName = 'value',
    this.wrapperCol,
  }) : super(key: key);

  final Widget child;
  final bool colon;
  final Widget? extra;
  final bool hasFeedback;
  final Widget? help;
  final bool hidden;
  final String? htmlFor;
  final String? initialValue;
  final Widget? label;
  final Placement labelAlign;
  final AntColumnResponsiveOption? labelCol;
  final Map<String, String>? messageVariables;
  final String? name;
  final String Function(String value)? normalize;
  final bool noStyle;
  final bool preserve;
  final bool required;
  final List<Rule>? rules;
  final Widget? tooltip;
  final String trigger;
  final bool validateFirst;
  final ValidateStatus? validateStatus;
  final String validateTrigger;
  final String valuePropName;
  final AntColumnResponsiveOption? wrapperCol;

  @override
  State<AntFormItem> createState() => _AntFormItemState();
}

class _AntFormItemState extends State<AntFormItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Rule {}

enum ValidateStatus { success, warning, error, validating }
