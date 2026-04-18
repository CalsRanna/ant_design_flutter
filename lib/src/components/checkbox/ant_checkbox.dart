import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/checkbox/checkbox_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 的复选框。
class AntCheckbox extends StatelessWidget {
  const AntCheckbox({
    required this.checked,
    required this.onChanged,
    super.key,
    this.label,
    this.disabled = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: () => onChanged?.call(!checked),
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = CheckboxStyle.resolve(
          alias: alias,
          checked: checked,
          hovered: hovered,
          disabled: disabled,
        );
        final box = SizedBox.square(
          dimension: 14,
          child: CustomPaint(
            painter: _CheckboxPainter(style: style, radius: 4),
          ),
        );
        if (label == null) return box;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            box,
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: disabled ? alias.colorTextDisabled : alias.colorText,
              ),
              child: label!,
            ),
          ],
        );
      },
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  _CheckboxPainter({required this.style, required this.radius});

  final CheckboxStyle style;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    canvas
      ..drawRRect(rrect, Paint()..color = style.fillColor)
      ..drawRRect(
        rrect,
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

    if (style.tickColor == null) return;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.43, size.height * 0.72)
      ..lineTo(size.width * 0.8, size.height * 0.3);
    canvas.drawPath(
      path,
      Paint()
        ..color = style.tickColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter old) => true;
}
