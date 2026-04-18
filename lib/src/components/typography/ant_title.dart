import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// AntTitle 的级别。对齐 AntD v5，只到 h5。
enum AntTitleLevel { h1, h2, h3, h4, h5 }

/// 标题组件。
///
/// 字号 / 行高 / 粗细对齐 AntD v5：
/// h1=38, h2=30, h3=24, h4=20, h5=16；lineHeight 分别 1.23/1.33/1.33/1.4/1.5；
/// 全部 w600。颜色取 `alias.colorText`。
class AntTitle extends StatelessWidget {
  const AntTitle(
    this.text, {
    super.key,
    this.level = AntTitleLevel.h1,
    this.textAlign,
  });

  final String text;
  final AntTitleLevel level;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final (fontSize, lineHeight) = switch (level) {
      AntTitleLevel.h1 => (38.0, 1.23),
      AntTitleLevel.h2 => (30.0, 1.33),
      AntTitleLevel.h3 => (24.0, 1.33),
      AntTitleLevel.h4 => (20.0, 1.4),
      AntTitleLevel.h5 => (16.0, 1.5),
    };
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: alias.colorText,
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
