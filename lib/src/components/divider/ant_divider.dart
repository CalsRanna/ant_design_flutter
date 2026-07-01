import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 分割线。对齐 AntD v5 `Divider`。
class AntDivider extends StatelessWidget {
  const AntDivider({
    super.key,
    this.text,
    this.orientation = AntDividerOrientation.center,
    this.dashed = false,
  });

  final String? text;
  final AntDividerOrientation orientation;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final borderSide = BorderSide(
      color: alias.colorSplit,
      width: 1,
      style: dashed ? BorderStyle.solid : BorderStyle.solid,
    );

    if (text == null) {
      return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(top: borderSide),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Flexible(
            flex: orientation == AntDividerOrientation.left ? 0 : 1,
            child: Container(height: 1, decoration: BoxDecoration(border: Border(top: borderSide))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text!,
              style: TextStyle(
                color: alias.colorText,
                fontSize: alias.fontSize,
              ),
            ),
          ),
          Flexible(
            flex: orientation == AntDividerOrientation.right ? 0 : 1,
            child: Container(height: 1, decoration: BoxDecoration(border: Border(top: borderSide))),
          ),
        ],
      ),
    );
  }
}

enum AntDividerOrientation { left, center, right }
