import 'package:flutter/widgets.dart';

/// Minimal scaffold example.
///
/// Real component demos will be added starting in Phase 3.
void main() {
  runApp(const _ScaffoldApp());
}

class _ScaffoldApp extends StatelessWidget {
  const _ScaffoldApp();

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF1677FF),
      title: 'ant_design_flutter 2.0 scaffold',
      home: const Center(
        child: Text(
          'ant_design_flutter 2.0 scaffold',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 24, color: Color(0xFF1677FF)),
        ),
      ),
    );
  }
}
