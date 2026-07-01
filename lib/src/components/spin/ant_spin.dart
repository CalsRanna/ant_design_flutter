import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:flutter/widgets.dart';

/// 加载中。对齐 AntD v5 `Spin`。
class AntSpin extends StatelessWidget {
  const AntSpin({
    super.key,
    this.size = 24,
    this.child,
    this.spinning = true,
    this.color,
  });

  final double size;
  final Widget? child;
  final bool spinning;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final spinnerColor = color ?? alias.colorPrimary;

    if (child == null) {
      return Center(
        child: LoadingSpinner(color: spinnerColor, size: size),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (!spinning) child!,
        if (spinning)
          Opacity(
            opacity: 0.6,
            child: child!,
          ),
        if (spinning)
          const Positioned.fill(
            child: Center(
              child: LoadingSpinner(color: Color(0xFF1677FF), size: 24),
            ),
          ),
      ],
    );
  }
}
