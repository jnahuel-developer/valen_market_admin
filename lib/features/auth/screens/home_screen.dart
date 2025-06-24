import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_home_button.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgHome,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const CustomTopBar(title: 'Home'),
          Positioned.fill(
            top: 130,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomHomeButton(
                    iconPath: AppAssets.iconUser,
                    text: 'Clientes',
                    onTap: () => Navigator.pushNamed(context, '/clientes'),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconCart,
                    text: 'Catálogo',
                    onTap: () => Navigator.pushNamed(context, '/catalogo'),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconTicket,
                    text: 'Fichas',
                    onTap: () => Navigator.pushNamed(context, '/fichas'),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconCar,
                    text: 'Recorrido',
                    onTap: () => Navigator.pushNamed(context, '/recorrido'),
                  ),
                  const SizedBox(height: 40),
                  const CustomHomeButton(
                    iconPath: AppAssets.iconStatistic,
                    text: 'Estadísticas',
                  ),
                  const SizedBox(height: 40),
                  const CustomHomeButton(
                    iconPath: AppAssets.iconPromotion,
                    text: 'Promociones',
                  ),
                  const SizedBox(height: 100), // margen inferior
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
