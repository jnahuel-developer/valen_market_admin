import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',
      routes: getAppRoutes(),
      initialRoute: '/',
    );
  }
}
