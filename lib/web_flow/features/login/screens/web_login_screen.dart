import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_gradient_button.dart';

class WebLoginScreen extends StatelessWidget {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomGradientButton(
                  text: 'INICIAR SESIÓN',
                  onPressed: () {
                    Navigator.pushNamed(context, PANTALLA_WEB__Login__ConEmail);
                  },
                ),
                const SizedBox(height: 30),
                CustomGradientButton(
                  text: 'RECUPERAR CONTRASEÑA',
                  onPressed: () {
//                    Navigator.pushNamed(
//                        context, PANTALLA_WEB__Login__RecuperarPassword);
                  },
                ),
                const SizedBox(height: 30),
                CustomGradientButton(
                  text: 'CREAR CUENTA',
                  onPressed: () {
                    Navigator.pushNamed(
                        context, PANTALLA_WEB__Login__CrearUsuario);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
