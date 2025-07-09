import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/widgets/custom_home_button.dart';

class FichasScreen extends StatelessWidget {
  const FichasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgFichas,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const CustomTopBar(title: 'FICHAS'),
          Positioned.fill(
            top: 130,
            child: Column(
              children: [
                CustomHomeButton(
                  iconPath: AppAssets.iconAdd,
                  text: 'Agregar',
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                CustomHomeButton(
                  iconPath: AppAssets.iconSearch,
                  text: 'Buscar',
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                CustomHomeButton(
                  iconPath: AppAssets.iconMoney,
                  text: 'Marcar Pago',
                  onTap: () {},
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
