import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent buttonStories() {
  return WidgetbookComponent(
    name: 'AntButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Types',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AntButton(
                type: AntButtonType.primary,
                onPressed: () {},
                child: const Text('Primary'),
              ),
              AntButton(onPressed: () {}, child: const Text('Default')),
              AntButton(
                type: AntButtonType.dashed,
                onPressed: () {},
                child: const Text('Dashed'),
              ),
              AntButton(
                type: AntButtonType.text,
                onPressed: () {},
                child: const Text('Text'),
              ),
              AntButton(
                type: AntButtonType.link,
                onPressed: () {},
                child: const Text('Link'),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Sizes',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AntButton(
                size: AntComponentSize.small,
                onPressed: () {},
                child: const Text('Small'),
              ),
              AntButton(onPressed: () {}, child: const Text('Middle')),
              AntButton(
                size: AntComponentSize.large,
                onPressed: () {},
                child: const Text('Large'),
              ),
            ],
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'States',
        builder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AntButton(
                type: AntButtonType.primary,
                loading: true,
                onPressed: () {},
                child: const Text('Loading'),
              ),
              AntButton(
                type: AntButtonType.primary,
                disabled: true,
                onPressed: () {},
                child: const Text('Disabled'),
              ),
              AntButton(
                danger: true,
                onPressed: () {},
                child: const Text('Danger'),
              ),
              AntButton(
                type: AntButtonType.primary,
                ghost: true,
                onPressed: () {},
                child: const Text('Ghost'),
              ),
              SizedBox(
                width: 200,
                child: AntButton(
                  type: AntButtonType.primary,
                  block: true,
                  onPressed: () {},
                  child: const Text('Block'),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
