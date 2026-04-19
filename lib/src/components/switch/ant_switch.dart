import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:ant_design_flutter/src/components/switch/switch_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 开关。
///
/// - middle / large 视觉等同（28×16，thumb 14）；small 为 22×14，thumb 12。
/// - 切换带 200ms 平滑动画；`loading=true` 时 thumb 中心替换为旋转 spinner、
///   整体降不透明度到 0.4，且不响应点击。
class AntSwitch extends StatelessWidget {
  const AntSwitch({
    required this.checked,
    required this.onChanged,
    super.key,
    this.size = AntComponentSize.middle,
    this.disabled = false,
    this.loading = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final AntComponentSize size;
  final bool disabled;
  final bool loading;

  bool get _effectiveDisabled => disabled || loading;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final spec = SwitchStyle.sizeSpec(size);
    return AntInteractionDetector(
      enabled: !_effectiveDisabled,
      onTap: () => onChanged?.call(!checked),
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        final style = SwitchStyle.resolve(
          alias: alias,
          checked: checked,
          hovered: hovered,
          disabled: _effectiveDisabled,
        );
        return Opacity(
          opacity: style.opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: spec.width,
            height: spec.height,
            decoration: BoxDecoration(
              color: style.trackColor,
              borderRadius: BorderRadius.circular(spec.height / 2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: checked
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(
                  (spec.height - spec.thumbDiameter) / 2,
                ),
                child: SizedBox.square(
                  dimension: spec.thumbDiameter,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: loading
                        ? Center(
                            child: LoadingSpinner(
                              color: style.trackColor,
                              size: spec.thumbDiameter * 0.7,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
