import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/form/form_controller.dart';
import 'package:ant_design_flutter/src/form/form_inherited.dart';
import 'package:flutter/widgets.dart';

/// 表单项。对齐 AntD v5 `Form.Item`。
///
/// 包含标签（label）、表单项、校验反馈。
class AntFormItem extends StatefulWidget {
  const AntFormItem({
    required this.name,
    required this.child,
    super.key,
    this.label,
    this.rules = const [],
  });

  final String name;
  final Widget child;
  final String? label;
  final List<AntValidator> rules;

  @override
  State<AntFormItem> createState() => _AntFormItemState();
}

class _AntFormItemState extends State<AntFormItem> {
  AntFormController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inherited = FormInherited.of(context);
    final newController = inherited?.controller;
    if (newController != _controller) {
      _controller?.unregisterField(widget.name);
      _controller = newController;
      if (newController != null) {
        newController.registerField(widget.name, widget.rules);
      }
    }
  }

  @override
  void dispose() {
    _controller?.unregisterField(widget.name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final inherited = FormInherited.of(context);
    final error = _controller?.getFieldError(widget.name);
    final labelWidth = inherited?.labelWidth ?? 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: labelWidth,
                child: Text(
                  widget.label!,
                  style: TextStyle(
                    color: alias.colorText,
                    fontSize: alias.fontSize,
                  ),
                ),
              ),
            ),
          widget.child,
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error,
                style: TextStyle(
                  color: alias.colorError,
                  fontSize: alias.fontSize - 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
