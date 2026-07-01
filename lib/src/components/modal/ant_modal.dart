import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 风格的模态对话框。
///
/// 对齐 AntD v5 `Modal` 组件。MVP 实现：
/// - `title`：标题
/// - `content`：内容文字
/// - `onOk` / `onCancel`：确认 / 取消回调
/// - `okText` / `cancelText`：按钮文字
/// - `confirmLoading`：确认按钮 loading 状态
/// - `width`：自定义宽度
///
/// 使用方式：
/// ```dart
/// AntModal.confirm(context,
///   title: '确认删除？',
///   content: '删除后不可恢复。',
///   onOk: () => deleteItem(),
/// );
/// ```
///
/// 推迟到 2.1：`footer`、`maskClosable`、`centered`、
/// `destroyOnClose`、`getContainer`、`zIndex`、动画定制。
abstract final class AntModal {
  /// 显示确认对话框。
  static OverlayEntryHandle confirm(
    BuildContext context, {
    required String title,
    String? content,
    String okText = '确定',
    String cancelText = '取消',
    VoidCallback? onOk,
    VoidCallback? onCancel,
    bool confirmLoading = false,
    double? width,
  }) {
    final alias = AntTheme.aliasOf(context);
    final holder = _HandleHolder();
    final handle = AntOverlayManager.show(
      context: context,
      slot: AntOverlaySlot.modal,
      builder: (_) => _ModalWidget(
        title: title,
        content: content,
        okText: okText,
        cancelText: cancelText,
        onOk: () {
          holder.dismiss();
          onOk?.call();
        },
        onCancel: () {
          holder.dismiss();
          onCancel?.call();
        },
        confirmLoading: confirmLoading,
        width: width ?? 416,
        borderRadius: alias.borderRadius,
        alias: alias,
      ),
    );
    holder.handle = handle;
    return handle;
  }

  /// 显示信息对话框。
  static OverlayEntryHandle info(
    BuildContext context, {
    required String title,
    String? content,
    String okText = '知道了',
    VoidCallback? onOk,
  }) {
    return confirm(
      context,
      title: title,
      content: content,
      okText: okText,
      onOk: onOk,
    );
  }

  /// 手动关闭。
  static void dismiss(OverlayEntryHandle handle) {
    AntOverlayManager.dismiss(handle);
  }
}

/// 用于在静态方法中安全地延迟捕获 Handle。
class _HandleHolder {
  OverlayEntryHandle? _handle;

  set handle(OverlayEntryHandle h) => _handle = h;
  OverlayEntryHandle? get handle => _handle;

  void dismiss() {
    final h = _handle;
    if (h != null && !h.isDismissed) {
      AntOverlayManager.dismiss(h);
    }
  }
}

class _ModalWidget extends StatelessWidget {
  const _ModalWidget({
    required this.title,
    required this.content,
    required this.okText,
    required this.cancelText,
    required this.onOk,
    required this.onCancel,
    required this.confirmLoading,
    required this.width,
    required this.borderRadius,
    required this.alias,
  });

  final String title;
  final String? content;
  final String okText;
  final String cancelText;
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final bool confirmLoading;
  final double width;
  final double borderRadius;
  final AntAliasToken alias;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        constraints: const BoxConstraints(maxHeight: 480),
        decoration: BoxDecoration(
          color: alias.colorBackgroundElevated,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: alias.colorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onCancel,
                    child: Text(
                      '✕',
                      style: TextStyle(
                        color: alias.colorTextTertiary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            if (content != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Text(
                  content!,
                  style: TextStyle(
                    color: alias.colorTextSecondary,
                    fontSize: alias.fontSize,
                  ),
                ),
              ),
            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ModalButton(
                    text: cancelText,
                    onPressed: onCancel,
                    backgroundColor: alias.colorBackgroundContainer,
                    foregroundColor: alias.colorText,
                    borderColor: alias.colorBorder,
                    borderRadius: borderRadius,
                  ),
                  const SizedBox(width: 8),
                  _ModalButton(
                    text: okText,
                    onPressed: confirmLoading ? null : onOk,
                    backgroundColor: alias.colorPrimary,
                    foregroundColor: const Color(0xFFFFFFFF),
                    borderColor: null,
                    borderRadius: borderRadius,
                    loading: confirmLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalButton extends StatelessWidget {
  const _ModalButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.borderRadius,
    this.loading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!)
              : null,
        ),
        child: loading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: LoadingSpinner(
                  color: Color(0xFFFFFFFF),
                  size: 14,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
