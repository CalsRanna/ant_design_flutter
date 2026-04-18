import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// 270° 旋转弧（库内私有）。
///
/// 用于 `AntButton.loading` 与 `AntSwitch.loading`。不对外导出。
///
/// 实现：`AnimationController(duration: 1s, repeat)` 驱动 `CustomPainter`
/// 画一段起始角随时间增加、固定扫过 270° 的弧。stroke 宽度固定为 `size / 8`。
class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({
    required this.color,
    required this.size,
    super.key,
  });

  final Color color;
  final double size;

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _SpinnerPainter(
            color: widget.color,
            progress: _controller.value,
            strokeWidth: widget.size / 8,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  final Color color;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);
    final startAngle = progress * 2 * math.pi;
    const sweepAngle = 1.5 * math.pi; // 270°
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) {
    return old.progress != progress ||
        old.color != color ||
        old.strokeWidth != strokeWidth;
  }
}
