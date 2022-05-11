import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter/widgets.dart';

class Scaffold extends StatelessWidget {
  const Scaffold({Key? key, required this.body})
      : floatingActionButton = null,
        super(key: key);

  const Scaffold.floatingActionButton({
    Key? key,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black.withOpacity(0.85),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        child: IconTheme(
          child: body,
          data: const IconThemeData(color: Colors.gray_7, size: 16),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
