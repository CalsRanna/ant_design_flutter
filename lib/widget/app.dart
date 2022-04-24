import 'package:flutter/material.dart';

class AntApp extends MaterialApp {
  const AntApp({Widget? home, Key? key})
      : super(
          debugShowCheckedModeBanner: false,
          home: home,
          key: key,
        );

  const AntApp.router({
    Key? key,
    required RouteInformationParser<Object> routeInformationParser,
    required RouterDelegate<Object> routerDelegate,
  }) : super.router(
          debugShowCheckedModeBanner: false,
          key: key,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
        );
}
