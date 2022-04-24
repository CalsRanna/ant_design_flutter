import 'package:ant_design_flutter/style/color.dart';
import 'package:flutter/material.dart' hide Colors;

class AntScaffold extends StatelessWidget {
  const AntScaffold({Key? key, this.body}) : super(key: key);

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
        child: IconTheme(
          child: Container(child: body),
          data: const IconThemeData(color: Colors.gray_7, size: 16),
        ),
      ),
    );
  }
}
