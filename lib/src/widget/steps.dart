import 'package:flutter/widgets.dart';

class Steps extends StatefulWidget {
  const Steps({
    Key? key,
    required this.children,
    this.current = 0,
    this.direction = Axis.horizontal,
    this.initial = 0,
    this.labelPlacement = Axis.horizontal,
    this.percent,
    this.progressDot,
    this.responsive = true,
    this.size = StepsSize.middle,
    this.status = StepsStatus.process,
    this.type = StepsType.normal,
    this.onChange,
  }) : super(key: key);

  final List<Widget> children;
  final int current;
  final Axis direction;
  final int initial;
  final Axis labelPlacement;
  final double? percent;
  final Widget? progressDot;
  final bool responsive;
  final StepsSize size;
  final StepsStatus status;
  final StepsType type;
  final void Function(int current)? onChange;

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum StepsSize { middle, small }

enum StepsStatus { wait, process, finish, error }

enum StepsType { normal, navigation }
