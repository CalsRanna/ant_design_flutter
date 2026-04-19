import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

const _demoIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

WidgetbookComponent iconStories() {
  return WidgetbookComponent(
    name: 'AntIcon',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Center(child: AntIcon(_demoIcon)),
      ),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AntIcon(_demoIcon, size: AntComponentSize.small),
              SizedBox(width: 16),
              AntIcon(_demoIcon),
              SizedBox(width: 16),
              AntIcon(_demoIcon, size: AntComponentSize.large),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Custom color',
        builder: (_) => const Center(
          child: AntIcon(_demoIcon, color: Color(0xFF1677FF)),
        ),
      ),
    ],
  );
}
