import 'dart:ui';

import 'package:crypto_flutter_app/route_maker.dart';
import 'package:flutter/material.dart';

import 'SizingTool.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isAuthorized = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      ),
      initialRoute: isAuthorized ? "/traders" : "/select_country",
      onGenerateRoute: (RouteSettings routeSettings)
        => RouteMaker.onGenerateRouteMaker(routeSettings)
    );
  }
}
