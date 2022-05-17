import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/material.dart' as material show Scaffold;
import 'package:flutter/widgets.dart';

/// A scaffold of ant design flutter's widget which provides a default text style
/// and icon theme.
///
/// This scaffold only has body and floating action button if you ever need to do
/// some extra work. Basicly, body is the only widget you should put in this.
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
          data: const IconThemeData(color: Colors.gray_7, size: 16),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
