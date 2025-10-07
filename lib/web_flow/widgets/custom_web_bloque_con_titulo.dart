import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebBloqueConTitulo extends StatelessWidget {
  final String titulo;
  final Widget child;

  const CustomWebBloqueConTitulo({
    super.key,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            color: WebColors.blanco,
            borderRadius: BorderRadius.circular(
                VALUE__general_widget__campo__big_border_radius),
            border: Border.all(color: WebColors.bordeRosa, width: 2),
          ),
          child: child,
        ),
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: WebColors.fondoEtiquetaBloque,
                border: Border.all(color: WebColors.bordeRosa, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: WebColors.textoRosa,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
