import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return AntApp(
      home: Builder(
        builder: (ctx) {
          final alias = AntTheme.aliasOf(ctx);
          return ColoredBox(
            color: alias.colorPrimaryBackground,
            child: Center(
              child: Text(
                'Hello Ant',
                style: TextStyle(
                  color: alias.colorPrimary,
                  fontSize: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
