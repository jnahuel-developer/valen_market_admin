import 'package:flutter/material.dart';
import '../config/environment.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valen Market Admin',
      home: LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        // Agregá más rutas aquí si hace falta
      },
    );
  }
}
