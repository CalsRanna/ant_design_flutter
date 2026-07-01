import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/form/form_controller.dart';
import 'package:ant_design_flutter/src/form/form_inherited.dart';
import 'package:flutter/widgets.dart';

/// 表单容器。对齐 AntD v5 `Form` 组件。
///
/// 使用方式：
/// ```dart
/// AntForm(
///   controller: formController,
///   onFinish: (values) => print(values),
///   child: Column(children: [
///     AntFormItem(
///       name: 'username',
///       label: '用户名',
///       rules: [AntValidators.required('请输入用户名')],
///       child: AntInput(),
///     ),
///   ]),
/// )
/// ```
///
/// 推迟到 2.1：`layout`（horizontal/vertical/inline）、`labelCol` / `wrapperCol`、
/// `colon`、`scrollToFirstError`。
class AntForm extends StatefulWidget {
  const AntForm({
    required this.controller,
    required this.child,
    super.key,
    this.onFinish,
    this.onFinishFailed,
    this.labelWidth,
  });

  final AntFormController controller;
  final Widget child;
  final VoidCallback? onFinish;
  final void Function(Map<String, String?> errors)? onFinishFailed;
  final double? labelWidth;

  @override
  State<AntForm> createState() => _AntFormState();
}

class _AntFormState extends State<AntForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  void _submit() {
    widget.controller.submit(
      onFinish: () => widget.onFinish?.call(),
      onFinishFailed: (errors) => widget.onFinishFailed?.call(errors),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormInherited(
      controller: widget.controller,
      labelWidth: widget.labelWidth ?? 100,
      submitForm: _submit,
      child: widget.child,
    );
  }
}
