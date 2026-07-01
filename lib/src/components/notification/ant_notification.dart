import 'dart:async';

import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// 通知提醒。对齐 AntD v5 `notification` API。
///
/// 使用方式：
/// ```dart
/// AntNotification.success(context,
///   message: 'Success',
///   description: 'Operation completed successfully.',
/// );
/// AntNotification.error(context,
///   message: 'Error',
///   description: 'Something went wrong.',
///   duration: const Duration(seconds: 5),
/// );
/// ```
///
/// 所有通知默认 4.5 秒后自动关闭。通过 `duration` 参数可自定义。
/// 传 `Duration.zero` 则不会自动关闭。
///
/// MVP 不实现 `btn`、`icon` 自定义、`key`、`onClick`、`placement`、`top`、`bottom`。
abstract final class AntNotification {
  /// 普通通知。
  static OverlayEntryHandle info(
    BuildContext context, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    return _show(
      context,
      _NotifyType.info,
      message: message,
      description: description,
      duration: duration,
    );
  }

  /// 成功通知。
  static OverlayEntryHandle success(
    BuildContext context, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    return _show(
      context,
      _NotifyType.success,
      message: message,
      description: description,
      duration: duration,
    );
  }

  /// 错误通知。
  static OverlayEntryHandle error(
    BuildContext context, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    return _show(
      context,
      _NotifyType.error,
      message: message,
      description: description,
      duration: duration,
    );
  }

  /// 警告通知。
  static OverlayEntryHandle warning(
    BuildContext context, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    return _show(
      context,
      _NotifyType.warning,
      message: message,
      description: description,
      duration: duration,
    );
  }

  /// 手动关闭指定通知。
  static void dismiss(OverlayEntryHandle handle) {
    AntOverlayManager.dismiss(handle);
  }

  static OverlayEntryHandle _show(
    BuildContext context,
    _NotifyType type, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    final alias = AntTheme.aliasOf(context);
    return _showWithHandle(
      context, alias, type,
      message: message,
      description: description,
      duration: duration,
    );
  }

  static OverlayEntryHandle _showWithHandle(
    BuildContext context,
    AntAliasToken alias,
    _NotifyType type, {
    required String message,
    String? description,
    Duration? duration,
  }) {
    final holder = _HandleHolder();
    final handle = AntOverlayManager.show(
      context: context,
      slot: AntOverlaySlot.notification,
      builder: (_) => _NotifyWidget(
        message: message,
        description: description,
        type: type,
        borderRadius: alias.borderRadius,
        alias: alias,
        onClose: holder.dismiss,
      ),
    );
    holder.handle = handle;

    final autoClose = duration ??
        const Duration(seconds: 4, milliseconds: 500);
    if (autoClose != Duration.zero) {
      Future.delayed(autoClose, () {
        if (!handle.isDismissed) {
          AntOverlayManager.dismiss(handle);
        }
      });
    }

    return handle;
  }
}

/// 用于在静态方法中安全地延迟捕获 Handle。解决 Dart 静态分析中
/// "variable referenced before declaration" 的问题。
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

enum _NotifyType { info, success, error, warning }

class _NotifyWidget extends StatefulWidget {
  const _NotifyWidget({
    required this.message,
    required this.description,
    required this.type,
    required this.borderRadius,
    required this.alias,
    required this.onClose,
  });

  final String message;
  final String? description;
  final _NotifyType type;
  final double borderRadius;
  final AntAliasToken alias;
  final VoidCallback onClose;

  @override
  State<_NotifyWidget> createState() => _NotifyWidgetState();
}

class _NotifyWidgetState extends State<_NotifyWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (Color accent, String symbol) = switch (widget.type) {
      _NotifyType.info => (widget.alias.colorPrimary, 'ℹ'),
      _NotifyType.success => (widget.alias.colorSuccess, '✓'),
      _NotifyType.error => (widget.alias.colorError, '✕'),
      _NotifyType.warning => (widget.alias.colorWarning, '⚠'),
    };

    return FadeTransition(
      opacity: _fade,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 384),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.alias.colorBackgroundElevated,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.alias.colorBorderSecondary),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.alias.colorText,
                      fontSize: widget.alias.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '✕',
                      style: TextStyle(
                        color: widget.alias.colorTextTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.description != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.description!,
                style: TextStyle(
                  color: widget.alias.colorTextSecondary,
                  fontSize: widget.alias.fontSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
