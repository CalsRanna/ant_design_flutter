import 'package:ant_design_flutter/style/color.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';

class AntScaffold extends StatelessWidget {
  const AntScaffold({Key? key, this.body, this.floatingActionButton})
      : super(key: key);

  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black.withOpacity(0.85),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        child: IconTheme(
          child: Container(child: body),
          data: const IconThemeData(color: Colors.gray_7, size: 16),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
