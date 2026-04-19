import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

const _demoIcon = IconData(0xe5ca, fontFamily: 'MaterialIcons');

WidgetbookComponent inputStories() {
  return WidgetbookComponent(
    name: 'AntInput',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(width: 260, child: AntInput(placeholder: 'input')),
        ),
      ),
      WidgetbookUseCase(
        name: 'Status',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AntInput(placeholder: 'default'),
                SizedBox(height: 12),
                AntInput(placeholder: 'error', status: AntStatus.error),
                SizedBox(height: 12),
                AntInput(placeholder: 'warning', status: AntStatus.warning),
              ],
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Prefix / suffix / clear',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: AntInput(
              placeholder: 'search',
              prefix: AntIcon(_demoIcon, size: AntComponentSize.small),
              allowClear: true,
            ),
          ),
        ),
      ),
      WidgetbookUseCase(
        name: 'Disabled / read-only',
        builder: (_) => const Padding(
          padding: EdgeInsets.all(24),
          child: SizedBox(
            width: 260,
            child: Column(
              children: [
                AntInput(disabled: true, placeholder: 'disabled'),
                SizedBox(height: 12),
                AntInput(readOnly: true, value: 'read-only'),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
