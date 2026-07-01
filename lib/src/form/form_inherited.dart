import 'package:ant_design_flutter/src/form/form_controller.dart';
import 'package:flutter/widgets.dart';

/// 表单继承上下文，供 `AntFormItem` 读取。
class FormInherited extends InheritedWidget {
  const FormInherited({
    required this.controller,
    required this.labelWidth,
    required this.submitForm,
    required super.child,
  });

  final AntFormController controller;
  final double labelWidth;
  final VoidCallback submitForm;

  static FormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormInherited>();
  }

  @override
  bool updateShouldNotify(FormInherited old) =>
      controller != old.controller ||
      labelWidth != old.labelWidth;
}
