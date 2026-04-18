import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/hsv.dart';

// 算法常量与 npm `@ant-design/colors` v7 一致。
// 均为 0-1 的饱和度 / 明度增量，而非 0-100 百分比。
const double _hueStep = 2;
const double _saturationStep = 0.16;
const double _saturationStep2 = 0.05;
const double _brightnessStep1 = 0.05;
const double _brightnessStep2 = 0.15;
const int _lightColorCount = 5;
const int _darkColorCount = 4;

/// 返回长度 10 的色板：
///   [0] primary-1 最浅 → [5] primary-6 (seed 本身) → [9] primary-10 最深。
///
/// 算法对齐 npm `@ant-design/colors` 的 `generate(color)`。
List<Color> generatePalette(Color seed) {
  final hsv = Hsv.fromColor(seed);
  final result = <Color>[];
  for (var i = _lightColorCount; i > 0; i--) {
    result.add(_getShade(hsv, i, light: true));
  }
  result.add(seed);
  for (var i = 1; i <= _darkColorCount; i++) {
    result.add(_getShade(hsv, i, light: false));
  }
  return result;
}

Color _getShade(Hsv hsv, int index, {required bool light}) {
  final hue = _computeHue(hsv, index, light: light);
  final saturation = _computeSaturation(hsv, index, light: light);
  final value = _computeValue(hsv, index, light: light);
  return Hsv(hue, saturation, value).toColor();
}

double _computeHue(Hsv hsv, int i, {required bool light}) {
  final hRounded = hsv.hue.round();
  double hue;
  if (hRounded >= 60 && hRounded <= 240) {
    hue = light ? hRounded - _hueStep * i : hRounded + _hueStep * i;
  } else {
    hue = light ? hRounded + _hueStep * i : hRounded - _hueStep * i;
  }
  if (hue < 0) {
    hue += 360;
  } else if (hue >= 360) {
    hue -= 360;
  }
  return hue;
}

double _computeSaturation(Hsv hsv, int i, {required bool light}) {
  // 灰度 seed（saturation == 0）保持灰度
  if (hsv.hue == 0 && hsv.saturation == 0) {
    return hsv.saturation;
  }
  double saturation;
  if (light) {
    saturation = hsv.saturation - _saturationStep * i;
  } else if (i == _darkColorCount) {
    saturation = hsv.saturation + _saturationStep;
  } else {
    saturation = hsv.saturation + _saturationStep2 * i;
  }
  if (saturation > 1) saturation = 1;
  if (light && i == _lightColorCount && saturation > 0.1) saturation = 0.1;
  if (saturation < 0.06) saturation = 0.06;
  return _truncate2(saturation);
}

double _computeValue(Hsv hsv, int i, {required bool light}) {
  double value;
  if (light) {
    value = hsv.value + _brightnessStep1 * i;
  } else {
    value = hsv.value - _brightnessStep2 * i;
  }
  if (value > 1) value = 1;
  return _truncate2(value);
}

/// 对齐 JS `Number(x.toFixed(2))` 的语义：保留 2 位小数。
double _truncate2(double x) => (x * 100).round() / 100;
