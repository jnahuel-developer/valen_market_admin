import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/Android_flow/widgets/custom_top_bar.dart';

class RecorridoScreen extends StatelessWidget {
  const RecorridoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgRecorrido,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const CustomTopBar(title: 'RECORRIDO'),
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
