import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_home_button.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgClientes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const CustomTopBar(title: 'CLIENTES'),
          Positioned.fill(
            top: 130,
            child: Column(
              children: [
                CustomHomeButton(
                    iconPath: AppAssets.iconAdd,
                    text: 'Agregar',
                    onTap: () {
                      Navigator.pushNamed(context, '/agregar_cliente');
                    }),
                const SizedBox(height: 40),
                CustomHomeButton(
                  iconPath: AppAssets.iconSearch,
                  text: 'Buscar',
                  onTap: () {
                    Navigator.pushNamed(context, 'BuscarCliente');
                  },
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
