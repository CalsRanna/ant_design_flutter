import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent switchStories() {
  return WidgetbookComponent(
    name: 'AntSwitch',
    useCases: [
      WidgetbookUseCase(name: 'Default', builder: (_) => const _SwitchDemo()),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntSwitch(
                checked: true,
                size: AntComponentSize.small,
                onChanged: (_) {},
              ),
              const SizedBox(width: 16),
              AntSwitch(checked: true, onChanged: (_) {}),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Loading',
        builder: (_) => Center(
          child: AntSwitch(
            checked: true,
            loading: true,
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  );
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
    child: AntSwitch(
      checked: _checked,
      onChanged: (v) => setState(() => _checked = v),
    ),
  );
}
