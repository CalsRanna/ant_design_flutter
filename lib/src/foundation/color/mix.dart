import 'dart:ui';

/// 按 [weight] ∈ [0, 100] 将 [base] 与 [mixed] 混合。
/// weight = 0 返回 base，weight = 100 返回 mixed。保留 base 的 alpha。
Color mixColor(Color base, Color mixed, double weight) {
  final w = (weight / 100).clamp(0.0, 1.0);
  return Color.fromARGB(
    (base.a * 255).round(),
    ((base.r * (1 - w) + mixed.r * w) * 255).round(),
    ((base.g * (1 - w) + mixed.g * w) * 255).round(),
    ((base.b * (1 - w) + mixed.b * w) * 255).round(),
  );
}
