import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomHomeButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;
  final Key? fieldKey;

  const CustomHomeButton({
    super.key,
    required this.iconPath,
    required this.text,
    this.onTap,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      key: fieldKey,
      child: Container(
        width: 390,
        height: 70,

        // Recuadro azul con bordes amarillos
        decoration: BoxDecoration(
          color: AppColors.azul,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.amarillo, width: 5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 25),

            // Ícono a mostrar
            SvgPicture.asset(
              iconPath,
              width: 25,
              height: 25,
              colorFilter:
                  const ColorFilter.mode(AppColors.amarillo, BlendMode.srcIn),
            ),

            // Espacio entre ícono y texto
            const SizedBox(width: 20),

            // Texto a mostrar
            Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 25,
                color: AppColors.amarillo,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
