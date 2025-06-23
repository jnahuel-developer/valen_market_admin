import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => LoginScreen(),
    '/register': (context) => RegisterScreen(),
  };
}
