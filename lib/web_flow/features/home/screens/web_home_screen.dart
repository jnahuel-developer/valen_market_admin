import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Home',
            pantallaPadreRouteName: null,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildButton(context, 'CLIENTES', () {
                    Navigator.pushNamed(
                      context,
                      PANTALLA_WEB__Clientes,
                    );
                  }),
                  const SizedBox(height: 20),
                  _buildButton(context, 'CATÁLOGO', () {
                    Navigator.pushNamed(
                      context,
                      PANTALLA_WEB__Catalogo,
                    );
                  }),
                  const SizedBox(height: 20),
                  _buildButton(context, 'FICHAS', () {}),
                  const SizedBox(height: 20),
                  _buildButton(context, 'PLANILLA DE COBROS', () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 320,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: WebColors.plataTranslucida,
          foregroundColor: WebColors.textoRosa,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              color: WebColors.bordeRosa,
              width: 2,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
