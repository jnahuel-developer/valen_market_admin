import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/keys.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/widgets/custom_home_button.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgHome,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Menu superior
          const CustomTopBar(title: TEXTO_ES__home_screen__titulo),

          //Cuerpo principal
          Positioned.fill(
            top: 130,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomHomeButton(
                    iconPath: AppAssets.iconUser,
                    fieldKey: KEY__home_screen__boton__clientes,
                    text: TEXTO_ES__home_screen__boton__clientes,
                    onTap: () =>
                        Navigator.pushNamed(context, PANTALLA__Clientes),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconCart,
                    fieldKey: KEY__home_screen__boton__catalogo,
                    text: TEXTO_ES__home_screen__boton__catalogo,
                    onTap: () =>
                        Navigator.pushNamed(context, PANTALLA__Catalogo),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconTicket,
                    fieldKey: KEY__home_screen__boton__fichas,
                    text: TEXTO_ES__home_screen__boton__fichas,
                    onTap: () => Navigator.pushNamed(context, PANTALLA__Fichas),
                  ),
                  const SizedBox(height: 40),
                  CustomHomeButton(
                    iconPath: AppAssets.iconCar,
                    fieldKey: KEY__home_screen__boton__recorrido,
                    text: TEXTO_ES__home_screen__boton__recorrido,
                    onTap: () =>
                        Navigator.pushNamed(context, PANTALLA__Recorrido),
                  ),
                  const SizedBox(height: 40),
                  const CustomHomeButton(
                    iconPath: AppAssets.iconStatistic,
                    fieldKey: KEY__home_screen__boton__estadisticas,
                    text: TEXTO_ES__home_screen__boton__estadisticas,
                  ),
                  const SizedBox(height: 40),
                  const CustomHomeButton(
                    iconPath: AppAssets.iconPromotion,
                    fieldKey: KEY__home_screen__boton__promociones,
                    text: TEXTO_ES__home_screen__boton__promociones,
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
