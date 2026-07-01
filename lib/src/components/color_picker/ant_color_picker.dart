import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 颜色选择器（简版）。对齐 AntD v5 `ColorPicker`。
class AntColorPicker extends StatefulWidget {
  const AntColorPicker({super.key, this.value, this.onChanged, this.colors = _defaultColors});
  final String? value; final ValueChanged<String>? onChanged; final List<String> colors;
  static const _defaultColors = ['#FF0000', '#FF7F00', '#FFFF00', '#00FF00', '#0000FF', '#4B0082', '#8B00FF', '#000000', '#FFFFFF', '#808080'];

  @override
  State<AntColorPicker> createState() => _AntColorPickerState();
}

class _AntColorPickerState extends State<AntColorPicker> {
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Wrap(spacing: 6, runSpacing: 6, children: [
      for (final c in widget.colors)
        GestureDetector(
          onTap: () => widget.onChanged?.call(c),
          child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: _parseColor(c),
              shape: BoxShape.circle,
              border: Border.all(color: c == widget.value ? alias.colorPrimary : alias.colorBorderSecondary, width: 2),
            ),
          ),
        ),
    ]);
  }

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
