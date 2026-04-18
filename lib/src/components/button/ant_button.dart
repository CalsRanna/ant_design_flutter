import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:ant_design_flutter/src/components/button/button_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

export 'package:ant_design_flutter/src/components/button/button_style.dart'
    show AntButtonShape, AntButtonType;

/// Ant Design Flutter 的按钮组件。
///
/// 5 种 type × 3 种 size × 3 种 shape × `danger` / `ghost` / `block` /
/// `disabled` / `loading` 组合的视觉由 [ButtonStyle.resolve] / [ButtonStyle.sizeSpec]
/// 两个纯函数派生；本 widget 只负责把派生值拼装成渲染树。
class AntButton extends StatelessWidget {
  const AntButton({
    required this.child,
    super.key,
    this.onPressed,
    this.type = AntButtonType.defaultStyle,
    this.size = AntComponentSize.middle,
    this.shape = AntButtonShape.rectangle,
    this.danger = false,
    this.ghost = false,
    this.block = false,
    this.disabled = false,
    this.loading = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final AntButtonType type;
  final AntComponentSize size;
  final AntButtonShape shape;
  final bool danger;
  final bool ghost;
  final bool block;
  final bool disabled;
  final bool loading;

  bool get _effectiveDisabled => disabled || loading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final sizeSpec = ButtonStyle.sizeSpec(alias: alias, size: size);

    return AntInteractionDetector(
      enabled: !_effectiveDisabled,
      onTap: onPressed,
      builder: (context, states) {
        final style = ButtonStyle.resolve(
          alias: alias,
          type: type,
          states: states,
          danger: danger,
          ghost: ghost,
        );

        final radius = switch (shape) {
          AntButtonShape.rectangle => alias.borderRadius,
          AntButtonShape.round => sizeSpec.height / 2,
          AntButtonShape.circle => sizeSpec.height / 2,
        };

        final content = _buildContent(style: style, sizeSpec: sizeSpec);

        Widget decorated;
        if (style.dashedBorder) {
          decorated = CustomPaint(
            painter: _DashedBorderPainter(
              color: style.borderColor ?? alias.colorBorder,
              radius: radius,
            ),
            child: ColoredBox(
              color: style.background,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizeSpec.horizontalPadding,
                ),
                child: content,
              ),
            ),
          );
        } else {
          decorated = DecoratedBox(
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(radius),
              border: style.borderColor == null
                  ? null
                  : Border.all(color: style.borderColor!),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizeSpec.horizontalPadding,
              ),
              child: content,
            ),
          );
        }

        final width = switch (shape) {
          AntButtonShape.circle => sizeSpec.height,
          _ => block ? double.infinity : null,
        };

        return SizedBox(
          height: sizeSpec.height,
          width: width,
          child: decorated,
        );
      },
    );
  }

  Widget _buildContent({
    required ButtonStyle style,
    required ButtonSizeSpec sizeSpec,
  }) {
    final textStyle = TextStyle(
      color: style.foreground,
      fontSize: sizeSpec.fontSize,
    );
    final text = DefaultTextStyle.merge(style: textStyle, child: child);
    if (!loading) {
      return Center(child: text);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingSpinner(color: style.foreground, size: sizeSpec.fontSize),
        SizedBox(width: sizeSpec.fontSize / 2),
        text,
      ],
    );
  }
}

/// 虚线边框自绘 painter（dashed type 专用）。
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 用 PathMetric 按固定 dash 长度 / gap 画。
    const dash = 4.0;
    const gap = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) {
    return old.color != color || old.radius != radius;
  }
}
