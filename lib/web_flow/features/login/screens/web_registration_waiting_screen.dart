import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_gradient_button.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/auth_servicios_firebase_web.dart';

class WebRegistrationWaitingScreen extends StatefulWidget {
  const WebRegistrationWaitingScreen({super.key});

  @override
  State<WebRegistrationWaitingScreen> createState() =>
      _WebRegistrationWaitingScreenState();
}

class _WebRegistrationWaitingScreenState
    extends State<WebRegistrationWaitingScreen> {
  bool _validando = false;

  Future<void> _verificarConfirmacion() async {
    setState(() => _validando = true);

    try {
      final user = await AuthServiciosFirebaseWeb.getCurrentUserWithReload();
      if (user != null && user.emailVerified) {
        final tokenOk = await AuthServiciosFirebaseWeb.loginConGoogle();

        if (!mounted) return;

        if (tokenOk) {
          Navigator.pushReplacementNamed(context, PANTALLA_WEB__Dropbox__Check);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Falló la autorización con Google'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📧 Aún no has verificado tu email'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verificando email: $e')),
      );
    } finally {
      if (mounted) setState(() => _validando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Esperando verificación',
            pantallaPadreRouteName: PANTALLA_WEB__Login,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Se ha enviado un correo de verificación.\n'
                        'Por favor, revisá tu casilla y confirmá tu email antes de continuar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      _validando
                          ? const CircularProgressIndicator()
                          : CustomGradientButton(
                              text: 'YA CONFIRMÉ MI EMAIL',
                              onPressed: _verificarConfirmacion,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
