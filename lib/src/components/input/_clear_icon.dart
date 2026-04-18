import 'package:flutter/widgets.dart';

/// 内置的"清除"图标（12×12 的圆形 × 号）。
///
/// 库内私有：不引入 `package:flutter/material.dart` 的 `Icons.cancel`。
/// AntInput.allowClear=true 时在 suffix 之前渲染。
class ClearIcon extends StatelessWidget {
  const ClearIcon({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 12,
      child: CustomPaint(painter: _ClearIconPainter(color)),
    );
  }
}

class _ClearIconPainter extends CustomPainter {
  _ClearIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final fill = Paint()..color = color;
    canvas.drawCircle(center, radius, fill);

    final stroke = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final inset = radius * 0.45;
    canvas
      ..drawLine(
        Offset(center.dx - inset, center.dy - inset),
        Offset(center.dx + inset, center.dy + inset),
        stroke,
      )
      ..drawLine(
        Offset(center.dx - inset, center.dy + inset),
        Offset(center.dx + inset, center.dy - inset),
        stroke,
      );
  }

  @override
  bool shouldRepaint(covariant _ClearIconPainter old) => old.color != color;
}
