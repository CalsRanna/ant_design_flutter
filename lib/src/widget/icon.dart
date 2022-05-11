import 'package:flutter/widgets.dart';

class AntIcon extends StatelessWidget {
  const AntIcon(this.icon, {Key? key, this.rotate, this.spin = false})
      : super(key: key);

  final IconData icon;
  final double? rotate;
  final bool spin;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      child: Icon(icon),
      angle: rotate ?? 0,
    );
  }
}
