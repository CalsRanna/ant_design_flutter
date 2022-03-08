import 'package:flutter/material.dart';

class AntApp extends StatefulWidget {
  const AntApp({Key? key, this.body}) : super(key: key);

  final Widget? body;

  @override
  State<AntApp> createState() => _AntAppState();
}

class _AntAppState extends State<AntApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: widget.body,
        backgroundColor: const Color(0xffffffff),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
