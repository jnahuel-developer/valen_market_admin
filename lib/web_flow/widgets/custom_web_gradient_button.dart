import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 300,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            WebColors.fondoEtiquetaBloque,
            WebColors.fondoEtiquetaBloque,
          ],
        ),
        borderRadius: BorderRadius.circular(
            VALUE__general_widget__campo__big_border_radius),
        border: Border.all(
          color: WebColors.bordeRosa,
          width: 2,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: WebColors.textoRosa,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                VALUE__general_widget__campo__big_border_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            // Contorno negro del texto (stroke)
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2.5
                  ..color = WebColors.bordeNegro,
              ),
            ),
            // Texto relleno rosa con sombra
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: WebColors.blanco,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
