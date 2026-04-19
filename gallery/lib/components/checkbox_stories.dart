import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent checkboxStories() {
  return WidgetbookComponent(
    name: 'AntCheckbox',
    useCases: [
      WidgetbookUseCase(
        name: 'Single',
        builder: (_) => const _CheckboxSingle(),
      ),
      WidgetbookUseCase(
        name: 'Group horizontal',
        builder: (_) => const _CheckboxGroupDemo(direction: Axis.horizontal),
      ),
      WidgetbookUseCase(
        name: 'Group vertical',
        builder: (_) => const _CheckboxGroupDemo(direction: Axis.vertical),
      ),
    ],
  );
}

class _CheckboxSingle extends StatefulWidget {
  const _CheckboxSingle();

  @override
  State<_CheckboxSingle> createState() => _CheckboxSingleState();
}

class _CheckboxSingleState extends State<_CheckboxSingle> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
    child: AntCheckbox(
      checked: _checked,
      onChanged: (v) => setState(() => _checked = v),
      label: const Text('accept terms'),
    ),
  );
}

class _CheckboxGroupDemo extends StatefulWidget {
  const _CheckboxGroupDemo({required this.direction});

  final Axis direction;
  @override
  State<_CheckboxGroupDemo> createState() => _CheckboxGroupDemoState();
}

class _CheckboxGroupDemoState extends State<_CheckboxGroupDemo> {
  List<String> _value = ['read'];
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: AntCheckboxGroup<String>(
      direction: widget.direction,
      options: const [
        AntOption(value: 'read', label: 'Reading'),
        AntOption(value: 'write', label: 'Writing'),
        AntOption(value: 'gym', label: 'Gym'),
      ],
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    ),
  );
}
