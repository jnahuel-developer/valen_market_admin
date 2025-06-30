import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/keys.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_home_button.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgClientes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Menu superior
          const CustomTopBar(title: TEXTO_ES__clientes_screen__titulo),

          // Cuerpo principal con botones de accion
          Positioned.fill(
            top: 130,
            child: Column(
              children: [
                // Boton para ir a la pantalla de agregar un cliente
                CustomHomeButton(
                    iconPath: AppAssets.iconAdd,
                    fieldKey: KEY__clientes_screen__boton__agregar_cliente,
                    text: TEXTO_ES__clientes_screen__boton__agregar_cliente,
                    onTap: () {
                      Navigator.pushNamed(
                          context, PANTALLA__Clientes__AgregarCliente);
                    }),

                // Separacion entre botones
                const SizedBox(height: 40),

                // Boton para ir a la pantalla de buscar un cliente
                CustomHomeButton(
                  iconPath: AppAssets.iconSearch,
                  fieldKey: KEY__clientes_screen__boton__buscar_cliente,
                  text: TEXTO_ES__clientes_screen__boton__buscar_cliente,
                  onTap: () {
                    Navigator.pushNamed(
                        context, PANTALLA__Clientes__BuscarCliente);
                  },
                ),
              ],
            ),
          ),

          // Menu inferior
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
