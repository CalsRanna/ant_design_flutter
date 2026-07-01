import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 警告提示。对齐 AntD v5 `Alert`。
class AntAlert extends StatelessWidget {
  const AntAlert({
    required this.message,
    super.key,
    this.description,
    this.type = AntAlertType.info,
    this.closable = false,
    this.onClose,
    this.showIcon = true,
  });

  final String message;
  final String? description;
  final AntAlertType type;
  final bool closable;
  final VoidCallback? onClose;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final (Color bg, Color border, Color iconColor, String icon) = switch (type) {
      AntAlertType.success => (alias.colorSuccess, alias.colorSuccess, alias.colorSuccess, '✓'),
      AntAlertType.info => (alias.colorPrimaryBackground, alias.colorPrimaryBorder, alias.colorPrimary, 'ℹ'),
      AntAlertType.warning => (alias.colorWarning, alias.colorWarning, alias.colorWarning, '⚠'),
      AntAlertType.error => (alias.colorError, alias.colorError, alias.colorError, '✕'),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg.withAlpha(30),
        borderRadius: BorderRadius.circular(alias.borderRadius),
        border: Border.all(color: border.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(icon, style: TextStyle(color: iconColor, fontSize: 16)),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize, fontWeight: FontWeight.w600)),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(description!, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize - 2)),
                ],
              ],
            ),
          ),
          if (closable)
            GestureDetector(
              onTap: onClose,
              child: Text('✕', style: TextStyle(color: alias.colorTextTertiary, fontSize: 14)),
            ),
        ],
      ),
    );
  }
}

enum AntAlertType { success, info, warning, error }
