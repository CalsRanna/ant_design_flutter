import 'package:flutter/widgets.dart' as widgets;

class Icon extends widgets.StatelessWidget {
  const Icon(this.icon, {widgets.Key? key, this.rotate, this.spin = false})
      : super(key: key);

  final widgets.IconData icon;
  final double? rotate;
  final bool spin;

  @override
  widgets.Widget build(widgets.BuildContext context) {
    return widgets.Transform.rotate(
      child: Icon(icon),
      angle: rotate ?? 0,
    );
  }
}
