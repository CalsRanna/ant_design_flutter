import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter_gallery/components/button_stories.dart';
import 'package:ant_design_flutter_gallery/components/checkbox_stories.dart';
import 'package:ant_design_flutter_gallery/components/icon_stories.dart';
import 'package:ant_design_flutter_gallery/components/input_stories.dart';
import 'package:ant_design_flutter_gallery/components/radio_stories.dart';
import 'package:ant_design_flutter_gallery/components/switch_stories.dart';
import 'package:ant_design_flutter_gallery/components/tag_stories.dart';
import 'package:ant_design_flutter_gallery/components/typography_stories.dart';
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
          name: 'Round 1 — Atoms',
          children: [iconStories(), typographyStories()],
        ),
        WidgetbookCategory(
          name: 'Round 2 — Form controls',
          children: [
            buttonStories(),
            inputStories(),
            checkboxStories(),
            radioStories(),
            switchStories(),
            tagStories(),
          ],
        ),
      ],
      appBuilder: (context, child) => AntConfigProvider(
        theme: AntThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      ),
      addons: const [],
    );
  }
}
