import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomBigButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? textColor;

  const CustomBigButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.azul,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.amarillo, width: 5),
        ),
        alignment: Alignment.center,
        child: Text(
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
