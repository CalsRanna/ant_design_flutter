import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent tagStories() {
  return WidgetbookComponent(
    name: 'AntTag',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Center(child: AntTag(child: Text('default'))),
      ),
      WidgetbookUseCase(
        name: 'Custom color',
        builder: (_) => const Center(
          child: Wrap(
            spacing: 8,
            children: [
              AntTag(color: Color(0xFFFFF8B8), child: Text('light')),
              AntTag(color: Color(0xFF1677FF), child: Text('blue')),
              AntTag(color: Color(0xFF000080), child: Text('navy')),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Closable',
        builder: (_) => Center(
          child: AntTag(
            closable: true,
            onClose: () {},
            child: const Text('closable'),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Checkable',
        builder: (_) => const _CheckableTagDemo(),
      ),
    ],
  );
}

class _CheckableTagDemo extends StatefulWidget {
  const _CheckableTagDemo();

  @override
  State<_CheckableTagDemo> createState() => _CheckableTagDemoState();
}

class _CheckableTagDemoState extends State<_CheckableTagDemo> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) => Center(
    child: AntCheckableTag(
      checked: _checked,
      onChanged: (v) => setState(() => _checked = v),
      child: const Text('topic'),
    ),
  );
}
