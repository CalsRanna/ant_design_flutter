import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// 全局提示消息。对齐 AntD v5 `message` API。
///
/// 使用方式：
/// ```dart
/// AntMessage.success(context, '操作成功');
/// AntMessage.error(context, '操作失败');
/// final handle = AntMessage.loading(context, '处理中…');
/// Future.delayed(const Duration(seconds: 2),
///     () => AntMessage.dismiss(handle));
/// ```
///
/// 所有消息默认 3 秒后自动关闭。通过 `duration` 参数可自定义。
///
/// MVP 不实现 `getContainer`、`top`、`prefixCls`、`transitionName`。
abstract final class AntMessage {
  /// 普通提示。
  static OverlayEntryHandle info(
    BuildContext context,
    String content, {
    Duration? duration,
  }) {
    return _show(context, content, _MessageType.info, duration);
  }

  /// 成功提示。
  static OverlayEntryHandle success(
    BuildContext context,
    String content, {
    Duration? duration,
  }) {
    return _show(context, content, _MessageType.success, duration);
  }

  /// 错误提示。
  static OverlayEntryHandle error(
    BuildContext context,
    String content, {
    Duration? duration,
  }) {
    return _show(context, content, _MessageType.error, duration);
  }

  /// 警告提示。
  static OverlayEntryHandle warning(
    BuildContext context,
    String content, {
    Duration? duration,
  }) {
    return _show(context, content, _MessageType.warning, duration);
  }

  /// 加载中提示（不会自动关闭）。
  static OverlayEntryHandle loading(
    BuildContext context,
    String content,
  ) {
    return _show(context, content, _MessageType.loading);
  }

  /// 手动关闭指定消息。
  static void dismiss(OverlayEntryHandle handle) {
    AntOverlayManager.dismiss(handle);
  }

  static OverlayEntryHandle _show(
    BuildContext context,
    String content,
    _MessageType type, [
    Duration? duration,
  ]) {
    final alias = AntTheme.aliasOf(context);
    final handle = AntOverlayManager.show(
      context: context,
      slot: AntOverlaySlot.message,
      builder: (_) => _MessageWidget(
        content: content,
        type: type,
        borderRadius: alias.borderRadius,
        alias: alias,
      ),
    );

    if (type != _MessageType.loading) {
      final autoClose = duration ?? const Duration(seconds: 3);
      Future.delayed(autoClose, () {
        if (!handle.isDismissed) {
          AntOverlayManager.dismiss(handle);
        }
      });
    }

    return handle;
  }
}

enum _MessageType { info, success, error, warning, loading }

class _MessageWidget extends StatelessWidget {
  const _MessageWidget({
    required this.content,
    required this.type,
    required this.borderRadius,
    required this.alias,
  });

  final String content;
  final _MessageType type;
  final double borderRadius;
  final AntAliasToken alias;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color iconColor) = switch (type) {
      _MessageType.info => (alias.colorBackgroundElevated, alias.colorPrimary),
      _MessageType.success =>
        (alias.colorBackgroundElevated, alias.colorSuccess),
      _MessageType.error => (alias.colorBackgroundElevated, alias.colorError),
      _MessageType.warning =>
        (alias.colorBackgroundElevated, alias.colorWarning),
      _MessageType.loading =>
        (alias.colorBackgroundElevated, alias.colorPrimary),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: alias.colorBorderSecondary),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MessageIcon(type: type, color: iconColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              content,
              style: TextStyle(
                color: alias.colorText,
                fontSize: alias.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageIcon extends StatelessWidget {
  const _MessageIcon({required this.type, required this.color});

  final _MessageType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // AntD v5 使用不同的 Unicode 字符表示不同图标。
    // 使用简单文本符号，不依赖图标字体。
    final symbol = switch (type) {
      _MessageType.info => 'ℹ',
      _MessageType.success => '✓',
      _MessageType.error => '✕',
      _MessageType.warning => '⚠',
      _MessageType.loading => '◌',
    };

    return Text(
      symbol,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
