import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 空状态。对齐 AntD v5 `Empty`。
class AntEmpty extends StatelessWidget {
  const AntEmpty({
    super.key,
    this.description,
    this.image,
    this.children,
  });

  final String? description;
  final Widget? image;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image ??
                Text(
                  '📭',
                  style: TextStyle(fontSize: 48, color: alias.colorTextDisabled),
                ),
            const SizedBox(height: 16),
            Text(
              description ?? 'No data',
              style: TextStyle(
                color: alias.colorTextTertiary,
                fontSize: alias.fontSize,
              ),
            ),
            if (children != null) ...[const SizedBox(height: 16), ...children!],
          ],
        ),
      ),
    );
  }
}
