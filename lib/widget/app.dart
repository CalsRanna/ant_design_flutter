import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';

class AntApp extends StatefulWidget {
  const AntApp({
    Key? key,
    this.home,
    this.showPerformanceOverlay = false,
  })  : routeInformationParser = null,
        routerDelegate = null,
        super(key: key);

  const AntApp.router({
    Key? key,
    required this.showPerformanceOverlay,
    required this.routeInformationParser,
    required this.routerDelegate,
  })  : home = null,
        super(key: key);

  final Widget? home;
  final bool showPerformanceOverlay;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;

  @override
  State<AntApp> createState() => _AntAppState();
}

class _AntAppState extends State<AntApp> {
  int messageCount = 0;
  Map<ValueKey, double> tops = {};

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.home,
      showPerformanceOverlay: widget.showPerformanceOverlay,
    );
    if (widget.routerDelegate != null) {
      app = MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: widget.routeInformationParser!,
        routerDelegate: widget.routerDelegate!,
        showPerformanceOverlay: widget.showPerformanceOverlay,
      );
    }

    return GlobalQuery(
      child: app,
      messageCount: messageCount,
      tops: tops,
      decreseMessageCount: _decreseMessageCount,
      increseMessageCount: _increseMessageCount,
      insert: _insert,
      remove: _remove,
    );
  }

  void _decreseMessageCount() {
    setState(() {
      messageCount -= 1;
    });
  }

  void _increseMessageCount() {
    setState(() {
      messageCount += 1;
    });
  }

  void _insert(ValueKey key, double top) {
    setState(() {
      tops[key] = top;
    });
  }

  void _remove(ValueKey key) {
    setState(() {
      tops.remove(key);
    });
  }
}

class GlobalQuery extends InheritedWidget {
  const GlobalQuery({
    Key? key,
    required Widget child,
    required this.messageCount,
    required this.tops,
    required this.decreseMessageCount(),
    required this.increseMessageCount(),
    required this.insert(ValueKey key, double top),
    required this.remove(ValueKey key),
  }) : super(key: key, child: child);

  final int messageCount;
  final Map<ValueKey, double> tops;
  final void Function() decreseMessageCount;
  final void Function() increseMessageCount;
  final void Function(ValueKey key, double top) insert;
  final void Function(ValueKey key) remove;

  static GlobalQuery? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalQuery>();
  }

  @override
  bool updateShouldNotify(GlobalQuery oldWidget) {
    return oldWidget.messageCount != messageCount;
  }
}
