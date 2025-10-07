import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/auth_servicios_firebase_web.dart';

class WebLoginEmailPasswordScreen extends StatefulWidget {
  const WebLoginEmailPasswordScreen({super.key});

  @override
  State<WebLoginEmailPasswordScreen> createState() =>
      _WebLoginEmailPasswordScreenState();
}

class _WebLoginEmailPasswordScreenState
    extends State<WebLoginEmailPasswordScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  bool _cargando = false;

  Future<void> _iniciarSesion() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe completar ambos campos.')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final loginOk =
          await AuthServiciosFirebaseWeb.loginConEmail(email, password);

      if (!mounted) return;

      if (loginOk) {
        final uid = await AuthServiciosFirebaseWeb.obtenerUidActual();

        if (uid != null) {
          await _secureStorage.write(key: 'UID', value: uid);
          final tokenGoogleOk = await AuthServiciosFirebaseWeb.loginConGoogle();

          if (!mounted) return;
          if (tokenGoogleOk) {
            Navigator.pushReplacementNamed(
                context, PANTALLA_WEB__Dropbox__Check);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('❌ Falló la autorización con Google')),
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ No se pudo obtener el UID')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('❌ Falló el login con email y contraseña')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Login con Email',
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
                      CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Contraseña',
                        controller: _passwordController,
                        isPassword: true,
                        isRequired: true,
                      ),
                      const SizedBox(height: 40),
                      _cargando
                          ? const CircularProgressIndicator()
                          : CustomGradientButton(
                              text: 'CONFIRMAR',
                              onPressed: _iniciarSesion,
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
