import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebCatalogoScreen extends StatelessWidget {
  const WebCatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Catálogo',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomGradientButton(
                    text: 'VER CATÁLOGO',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PANTALLA_WEB__Catalogo__VerCatalogo,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'AGREGAR PRODUCTO',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PANTALLA_WEB__Catalogo__AgregarProducto,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'BUSCAR PRODUCTO',
                    onPressed: () {
                      // Implementar luego
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'MODIFICAR PRODUCTO',
                    onPressed: () {
                      // Implementar luego
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'ELIMINAR PRODUCTO',
                    onPressed: () {
                      // Implementar luego
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
