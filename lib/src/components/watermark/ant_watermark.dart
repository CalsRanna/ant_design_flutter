import 'package:flutter/widgets.dart';

/// 水印。对齐 AntD v5 `Watermark`。
class AntWatermark extends StatelessWidget {
  const AntWatermark({
    required this.child,
    required this.text,
    super.key,
    this.opacity = 0.15,
    this.fontSize = 14,
    this.color = const Color(0xFF000000),
  });

  final Widget child;
  final String text;
  final double opacity;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Center(
                child: Transform.rotate(
                  angle: -0.5, // ~ -28 degrees
                  child: Text(
                    text,
                    style: TextStyle(color: color, fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
