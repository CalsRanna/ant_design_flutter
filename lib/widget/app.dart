import 'package:flutter/material.dart';

class AntApp extends StatefulWidget {
  const AntApp({Key? key, this.home}) : super(key: key);

  final Widget? home;

  @override
  State<AntApp> createState() => _AntAppState();
}

class _AntAppState extends State<AntApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget.home,
      debugShowCheckedModeBanner: false,
    );
  }
}
