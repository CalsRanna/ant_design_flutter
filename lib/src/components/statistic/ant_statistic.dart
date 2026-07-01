import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 统计数值。对齐 AntD v5 `Statistic`。
class AntStatistic extends StatelessWidget {
  const AntStatistic({
    required this.title,
    required this.value,
    super.key,
    this.precision,
    this.prefix,
    this.suffix,
  });

  final String title;
  final num value;
  final int? precision;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final formatted = precision != null ? value.toStringAsFixed(precision!) : '$value';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize - 2),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (prefix != null) prefix!,
            Text(
              formatted,
              style: TextStyle(
                color: alias.colorText,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (suffix != null) suffix!,
          ],
        ),
      ],
    );
  }
}
