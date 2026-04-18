import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 的图标组件。
///
/// **字体不随包打包**：用户需自带图标字体（例如社区包 `ant_icons_plus`，
/// 或自行制作 TrueType 子集）。`AntIcon` 只负责尺寸 / 颜色 / 语义标签；
/// 字形渲染交给 Flutter 内置 `Icon` 完成。
///
/// 三档 size 映射：small=14、middle=16、large=20（像素）。
class AntIcon extends StatelessWidget {
  const AntIcon(
    this.icon, {
    super.key,
    this.size = AntComponentSize.middle,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final AntComponentSize size;

  /// null 时由 `IconTheme.of(context).color` 回落。
  final Color? color;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final pixelSize = switch (size) {
      AntComponentSize.small => 14.0,
      AntComponentSize.middle => 16.0,
      AntComponentSize.large => 20.0,
    };
    return Icon(
      icon,
      size: pixelSize,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
