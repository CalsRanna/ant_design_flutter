import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/typography/ant_text.dart';
import 'package:flutter/widgets.dart';

/// 段落文字：视觉等同 `AntText`，但底部带 1em `Padding` 用于段间距。
///
/// MVP 不支持 ellipsis / copyable / editable（推迟 2.1）。
class AntParagraph extends StatelessWidget {
  const AntParagraph(this.text, {super.key, this.type = AntTextType.normal});

  final String text;
  final AntTextType type;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: alias.fontSize),
      child: AntText(text, type: type),
    );
  }
}
