import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: [
        WidgetbookCategory(
          name: 'Placeholder',
          children: [
            WidgetbookComponent(
              name: 'Empty',
              useCases: [
                WidgetbookUseCase(
                  name: 'Scaffold',
                  builder: _emptyUseCase,
                ),
              ],
            ),
          ],
        ),
      ],
      addons: const [],
    );
  }
}

Widget _emptyUseCase(BuildContext context) {
  return const Center(
    child: Text(
      'ant_design_flutter 2.0 gallery — add components here from Phase 1.',
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
    ),
  );
}
