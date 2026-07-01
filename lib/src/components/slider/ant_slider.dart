import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 滑动输入。对齐 AntD v5 `Slider`。
class AntSlider extends StatefulWidget {
  const AntSlider({super.key, this.value = 0, this.onChanged, this.min = 0, this.max = 100, this.disabled = false});
  final double value; final ValueChanged<double>? onChanged; final double min; final double max; final bool disabled;
  @override
  State<AntSlider> createState() => _AntSliderState();
}

class _AntSliderState extends State<AntSlider> {
  late double _value;
  @override
  void initState() { super.initState(); _value = widget.value; }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final fraction = widget.max == widget.min ? 0.0 : (_value - widget.min) / (widget.max - widget.min);
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        height: 4,
        child: Row(
          children: [
            Flexible(flex: (fraction * 100).round().clamp(0, 100), child: Container(color: alias.colorPrimary)),
            Flexible(flex: (100 - (fraction * 100).round()).clamp(0, 100), child: Container(color: alias.colorFillSecondary)),
          ],
        ),
      ),
    );
  }
}
