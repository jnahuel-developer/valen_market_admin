import 'package:flutter/material.dart';
import 'package:valen_market_admin/services/firebase/auth_servicios_firebase_web.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  bool _logueando = false;

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final logueado = await AuthServiciosFirebaseWeb.estaLogueado();
    if (!mounted) return;
    if (logueado) {
      Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
    }
  }

  Future<void> _login() async {
    setState(() => _logueando = true);
    final ok = await AuthServiciosFirebaseWeb.loginConGoogle();

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Falló el login con Google')),
      );
    }
    setState(() => _logueando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _logueando
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _login,
                child: const Text('Iniciar sesión con Google'),
              ),
      ),
    );
  }
}
