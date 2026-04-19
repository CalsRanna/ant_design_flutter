import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent typographyStories() {
  return WidgetbookComponent(
    name: 'Typography',
    useCases: [
      WidgetbookUseCase(
        name: 'Title (h1 - h5)',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AntTitle('Title h1'),
              AntTitle('Title h2', level: AntTitleLevel.h2),
              AntTitle('Title h3', level: AntTitleLevel.h3),
              AntTitle('Title h4', level: AntTitleLevel.h4),
              AntTitle('Title h5', level: AntTitleLevel.h5),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Text (types)',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AntText('normal'),
              AntText('secondary', type: AntTextType.secondary),
              AntText('tertiary', type: AntTextType.tertiary),
              AntText('disabled', type: AntTextType.disabled),
              AntText('success', type: AntTextType.success),
              AntText('warning', type: AntTextType.warning),
              AntText('danger', type: AntTextType.danger),
              AntText('code()', code: true),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Paragraph',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: AntParagraph(
            'Ant Design Flutter is a UI library that brings Ant Design '
            'v5 to Flutter for web and desktop applications.',
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Link',
        builder: (_) => Center(
          child: AntLink('Click me', onPressed: () {}),
        ),
      ),
    ],
  );
}
