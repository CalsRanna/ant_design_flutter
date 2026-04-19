import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/radio/radio_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// Ant Design Flutter 的单选按钮。
class AntRadio<T> extends StatelessWidget {
  const AntRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.label,
    this.disabled = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Widget? label;
  final bool disabled;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      enabled: !disabled,
      onTap: () {
        if (!_selected) onChanged?.call(value);
      },
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = RadioStyle.resolve(
          alias: alias,
          selected: _selected,
          hovered: hovered,
          disabled: disabled,
        );
        final circle = SizedBox.square(
          dimension: 16,
          child: CustomPaint(painter: _RadioPainter(style: style)),
        );
        if (label == null) return circle;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            circle,
            const SizedBox(width: 8),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: disabled
                    ? alias.colorTextDisabled
                    : alias.colorText,
              ),
              child: label!,
            ),
          ],
        );
      },
    );
  }
}

class _RadioPainter extends CustomPainter {
  _RadioPainter({required this.style});

  final RadioStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    canvas
      ..drawCircle(
        center,
        radius - 0.5,
        Paint()..color = const Color(0xFFFFFFFF),
      )
      ..drawCircle(
        center,
        radius - 0.5,
        Paint()
          ..color = style.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

    if (style.innerDotColor == null) return;
    canvas.drawCircle(
      center,
      radius * 0.45,
      Paint()..color = style.innerDotColor!,
    );
  }

  @override
  bool shouldRepaint(covariant _RadioPainter old) => true;
}
