import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomBigButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final Key? fieldKey;

  const CustomBigButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      key: fieldKey,
      child: Container(
        width: 400,
        height: 60,

        // Recuadro azul con bordes amarillos
        decoration: BoxDecoration(
          color: AppColors.azul,
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          border: Border.all(color: AppColors.amarillo, width: 5),
        ),
        alignment: Alignment.center,
        child:
            // Texto a mostrar
            Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.amarillo,
          ),
        ),
      ),
    );
  }
}
