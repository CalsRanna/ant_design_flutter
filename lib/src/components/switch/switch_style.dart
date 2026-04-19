import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Switch 视觉派生结果。
@immutable
class SwitchStyle {
  const SwitchStyle({required this.trackColor, required this.opacity});

  /// 根据 [checked] / [hovered] / [disabled] 派生 track 色与 opacity。
  factory SwitchStyle.resolve({
    required AntAliasToken alias,
    required bool checked,
    required bool hovered,
    required bool disabled,
  }) {
    final Color track;
    if (checked) {
      track = hovered ? alias.colorPrimaryHover : alias.colorPrimary;
    } else {
      track = hovered ? alias.colorTextSecondary : alias.colorTextTertiary;
    }
    return SwitchStyle(trackColor: track, opacity: disabled ? 0.4 : 1.0);
  }

  final Color trackColor;
  final double opacity;

  /// 根据 [size] 派生 Switch 的宽 / 高 / 滑块直径。
  static SwitchSizeSpec sizeSpec(AntComponentSize size) {
    return switch (size) {
      AntComponentSize.small => const SwitchSizeSpec(
        width: 22,
        height: 14,
        thumbDiameter: 12,
      ),
      AntComponentSize.middle || AntComponentSize.large => const SwitchSizeSpec(
        width: 28,
        height: 16,
        thumbDiameter: 14,
      ),
    };
  }
}

/// Switch 尺寸派生结果。
@immutable
class SwitchSizeSpec {
  const SwitchSizeSpec({
    required this.width,
    required this.height,
    required this.thumbDiameter,
  });

  final double width;
  final double height;
  final double thumbDiameter;

  @override
  bool operator ==(Object other) {
    return other is SwitchSizeSpec &&
        other.width == width &&
        other.height == height &&
        other.thumbDiameter == thumbDiameter;
  }

  @override
  int get hashCode => Object.hash(width, height, thumbDiameter);
}
