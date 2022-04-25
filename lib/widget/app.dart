import 'package:flutter/material.dart';

class AntApp extends MaterialApp {
  const AntApp({Widget? home, Key? key, bool showPerformanceOverlay = false})
      : super(
          debugShowCheckedModeBanner: false,
          home: home,
          key: key,
          showPerformanceOverlay: showPerformanceOverlay,
        );

  const AntApp.router({
    Key? key,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
    bool showPerformanceOverlay = false,
  }) : super.router(
          debugShowCheckedModeBanner: false,
          key: key,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          showPerformanceOverlay: showPerformanceOverlay,
        );
}
