import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// AntText 的语义类型（决定颜色）。
enum AntTextType {
  normal,
  secondary,
  tertiary,
  disabled,
  success,
  warning,
  danger,
}

/// 通用文字。对齐 AntD v5 `Typography.Text`。
class AntText extends StatelessWidget {
  const AntText(
    this.text, {
    super.key,
    this.type = AntTextType.normal,
    this.size = AntComponentSize.middle,
    this.strong = false,
    this.italic = false,
    this.underline = false,
    this.delete = false,
    this.code = false,
  });

  final String text;
  final AntTextType type;
  final AntComponentSize size;
  final bool strong;
  final bool italic;
  final bool underline;
  final bool delete;

  /// 等宽字体 + 浅灰背景（code 片段样式）。
  final bool code;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final color = _resolveColor(alias, type);
    final fontSize = switch (size) {
      AntComponentSize.small => alias.fontSize - 2,
      AntComponentSize.middle => alias.fontSize,
      AntComponentSize.large => alias.fontSize + 2,
    };

    final decorations = <TextDecoration>[
      if (underline) TextDecoration.underline,
      if (delete) TextDecoration.lineThrough,
    ];

    final style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: strong ? FontWeight.w600 : null,
      fontStyle: italic ? FontStyle.italic : null,
      fontFamily: code ? 'monospace' : null,
      decoration: decorations.isEmpty
          ? null
          : TextDecoration.combine(decorations),
    );

    final textWidget = Text(text, style: style);
    if (!code) return textWidget;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: alias.colorFillSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: textWidget,
      ),
    );
  }

  Color _resolveColor(AntAliasToken alias, AntTextType type) {
    return switch (type) {
      AntTextType.normal => alias.colorText,
      AntTextType.secondary => alias.colorTextSecondary,
      AntTextType.tertiary => alias.colorTextTertiary,
      AntTextType.disabled => alias.colorTextDisabled,
      AntTextType.success => alias.colorSuccess,
      AntTextType.warning => alias.colorWarning,
      AntTextType.danger => alias.colorError,
    };
  }
}
