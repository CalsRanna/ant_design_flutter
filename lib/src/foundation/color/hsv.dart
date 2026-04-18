import 'dart:math' as math;
import 'dart:ui';

/// HSV 色彩空间表示。hue ∈ [0, 360)，saturation/value ∈ [0, 1]。
///
/// 仅 foundation/color 内部使用，不对外导出。
class Hsv {
  const Hsv(this.hue, this.saturation, this.value);

  /// 从 [Color] 提取 HSV。实现与 AntD TinyColor2 对齐。
  factory Hsv.fromColor(Color c) {
    final r = c.r;
    final g = c.g;
    final b = c.b;
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;

    double hue;
    if (delta == 0) {
      hue = 0;
    } else if (max == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (max == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }
    if (hue < 0) hue += 360;

    final saturation = max == 0 ? 0.0 : delta / max;
    return Hsv(hue, saturation, max);
  }

  final double hue;
  final double saturation;
  final double value;

  /// 转回 [Color]。[alpha] ∈ [0, 1]，默认 1。
  Color toColor({double alpha = 1}) {
    final c = value * saturation;
    final x = c * (1 - ((hue / 60) % 2 - 1).abs());
    final m = value - c;

    double r;
    double g;
    double b;
    if (hue < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (hue < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (hue < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (hue < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (hue < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    return Color.fromARGB(
      (alpha * 255).round().clamp(0, 255),
      ((r + m) * 255).round().clamp(0, 255),
      ((g + m) * 255).round().clamp(0, 255),
      ((b + m) * 255).round().clamp(0, 255),
    );
  }
}
