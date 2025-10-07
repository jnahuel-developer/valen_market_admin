import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Inicio',
            pantallaPadreRouteName: null,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomGradientButton(
                    text: 'CLIENTES',
                    onPressed: () {
                      Navigator.pushNamed(context, PANTALLA_WEB__Clientes);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'CATÁLOGO',
                    onPressed: () {
                      Navigator.pushNamed(context, PANTALLA_WEB__Catalogo);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'FICHAS',
                    onPressed: () {
                      Navigator.pushNamed(
                          context, PANTALLA_WEB__Fichas__Agregar_Buscar);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'PLANILLA DE COBROS',
                    onPressed: () {
                      // Acción futura
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
