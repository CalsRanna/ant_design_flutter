import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 进度条。对齐 AntD v5 `Progress`。
class AntProgress extends StatelessWidget {
  const AntProgress({
    required this.percent,
    super.key,
    this.strokeWidth = 8,
    this.color,
    this.trailColor,
  });

  final double percent;
  final double strokeWidth;
  final Color? color;
  final Color? trailColor;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final barColor = color ?? alias.colorPrimary;
    final bgColor = trailColor ?? alias.colorFillSecondary;
    final clamped = percent.clamp(0, 100);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(strokeWidth / 2),
            child: Container(
              height: strokeWidth,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(strokeWidth / 2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: clamped / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(strokeWidth / 2),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${clamped.round()}%',
          style: TextStyle(
            color: alias.colorTextSecondary,
            fontSize: alias.fontSize - 2,
          ),
        ),
      ],
    );
  }
}
