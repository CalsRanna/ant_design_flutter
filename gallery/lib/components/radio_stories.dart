import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent radioStories() {
  return WidgetbookComponent(
    name: 'AntRadio',
    useCases: [
      WidgetbookUseCase(name: 'Single', builder: (_) => const _RadioSingle()),
      WidgetbookUseCase(
        name: 'Group horizontal',
        builder: (_) => const _RadioGroupDemo(direction: Axis.horizontal),
      ),
      WidgetbookUseCase(
        name: 'Group vertical',
        builder: (_) => const _RadioGroupDemo(direction: Axis.vertical),
      ),
    ],
  );
}

class _RadioSingle extends StatefulWidget {
  const _RadioSingle();

  @override
  State<_RadioSingle> createState() => _RadioSingleState();
}

class _RadioSingleState extends State<_RadioSingle> {
  String? _value;
  @override
  Widget build(BuildContext context) => Center(
    child: AntRadio<String>(
      value: 'only',
      groupValue: _value,
      onChanged: (v) => setState(() => _value = v),
      label: const Text('only'),
    ),
  );
}

class _RadioGroupDemo extends StatefulWidget {
  const _RadioGroupDemo({required this.direction});

  final Axis direction;
  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  String? _value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: AntRadioGroup<String>(
      direction: widget.direction,
      options: const [
        AntOption(value: 'm', label: 'Male'),
        AntOption(value: 'f', label: 'Female'),
        AntOption(value: 'o', label: 'Other'),
      ],
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    ),
  );
}
