import 'package:ant_design_flutter/src/components/modal/ant_modal.dart';
import 'package:flutter/widgets.dart';

/// 气泡确认框。对齐 AntD v5 `Popconfirm`。
abstract final class AntPopconfirm {
  static void show(BuildContext context, {required String title, String? description, required String okText, required String cancelText,
    VoidCallback? onOk, VoidCallback? onCancel, bool confirmLoading = false}) {
    AntModal.confirm(context, title: title, content: description, okText: okText, cancelText: cancelText,
      onOk: onOk, onCancel: onCancel, confirmLoading: confirmLoading);
  }
}
