import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';

/// An application that uses Ant Design.
///
/// A root widget which should be used as the application entry point. It provide
/// [GlobalQuery] to solve overlay entry's offset and other feature.
///
/// It basic was a sub class of Material App and some few params provided to use.
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
  Map<Key, double> notificationTops = {};

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
      tops: tops,
      notificationTops: notificationTops,
      insert: _insert,
      remove: _remove,
      insertNotification: _insertNotification,
      removeNotification: _removeNotification,
      child: app,
    );
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

  void _insertNotification(Key key, double top) {
    setState(() {
      notificationTops[key] = top;
    });
  }

  void _removeNotification(Key key) {
    setState(() {
      notificationTops.remove(key);
    });
  }
}

class GlobalQuery extends InheritedWidget {
  const GlobalQuery({
    Key? key,
    required Widget child,
    required this.tops,
    required this.notificationTops,
    required this.insert(ValueKey key, double top),
    required this.remove(ValueKey key),
    required this.insertNotification(Key key, double top),
    required this.removeNotification(Key key),
  }) : super(key: key, child: child);

  final Map<ValueKey, double> tops;
  final Map<Key, double> notificationTops;
  final void Function(ValueKey key, double top) insert;
  final void Function(ValueKey key) remove;
  final void Function(Key key, double top) insertNotification;
  final void Function(Key key) removeNotification;

  static GlobalQuery? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalQuery>();
  }

  @override
  bool updateShouldNotify(GlobalQuery oldWidget) {
    return oldWidget.tops != tops ||
        oldWidget.notificationTops != notificationTops;
  }
}
