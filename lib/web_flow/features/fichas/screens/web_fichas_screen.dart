import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebFichasScreen extends StatelessWidget {
  const WebFichasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Fichas',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Expanded(child: CustomWebClienteSection()),
                  SizedBox(width: 20),
                  Expanded(child: CustomWebProductosSection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
