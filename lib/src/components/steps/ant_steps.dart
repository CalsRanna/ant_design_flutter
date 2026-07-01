import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 步骤条。对齐 AntD v5 `Steps`。
class AntSteps extends StatelessWidget {
  const AntSteps({
    required this.current,
    required this.items,
    super.key,
    this.direction = AntStepsDirection.horizontal,
  });

  final int current;
  final List<AntStepItem> items;
  final AntStepsDirection direction;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);

    if (direction == AntStepsDirection.horizontal) {
      return Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Container(
                  height: 1,
                  color: i <= current ? alias.colorPrimary : alias.colorSplit,
                ),
              ),
            _StepIndicator(
              item: items[i],
              index: i,
              current: current,
              alias: alias,
            ),
          ],
        ],
      );
    }

    // Vertical
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Container(
              margin: const EdgeInsets.only(left: 12),
              width: 1,
              height: 24,
              color: i <= current ? alias.colorPrimary : alias.colorSplit,
            ),
          _StepIndicator(
            item: items[i],
            index: i,
            current: current,
            alias: alias,
          ),
        ],
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.item,
    required this.index,
    required this.current,
    required this.alias,
  });

  final AntStepItem item;
  final int index;
  final int current;
  final AntAliasToken alias;

  @override
  Widget build(BuildContext context) {
    final isComplete = index < current;
    final isActive = index == current;
    final isWaiting = index > current;

    final Color circleColor;
    final String label;
    if (isComplete) {
      circleColor = alias.colorPrimary;
      label = '✓';
    } else if (isActive) {
      circleColor = alias.colorPrimary;
      label = '${index + 1}';
    } else {
      circleColor = alias.colorFillSecondary;
      label = '${index + 1}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isWaiting ? alias.colorTextDisabled : const Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.title,
            style: TextStyle(
              color: isWaiting ? alias.colorTextTertiary : alias.colorText,
              fontSize: alias.fontSize,
              fontWeight: isActive ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class AntStepItem {
  const AntStepItem({required this.title, this.subtitle});
  final String title;
  final String? subtitle;
}

enum AntStepsDirection { horizontal, vertical }
