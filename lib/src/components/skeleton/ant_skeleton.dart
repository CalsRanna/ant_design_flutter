import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 骨架屏。对齐 AntD v5 `Skeleton`。
class AntSkeleton extends StatelessWidget {
  const AntSkeleton({
    super.key,
    this.rows = 3,
    this.active = false,
    this.avatar = false,
  });

  final int rows;
  final bool active;
  final bool avatar;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final baseColor = alias.colorFillSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatar)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SkeletonBlock(width: 40, height: 40, radius: 20, color: baseColor),
          ),
        for (var i = 0; i < rows; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i < rows - 1 ? 8 : 0),
            child: _SkeletonBlock(
              width: i == rows - 1 ? 0.6 : 1.0,
              height: 14,
              color: baseColor,
            ),
          ),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.width, required this.height, this.radius = 4, required this.color});
  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width <= 1 ? width : null,
      child: Container(
        width: width > 1 ? width : null,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
