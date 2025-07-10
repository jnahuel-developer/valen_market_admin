import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomStyles {
  static ButtonStyle botonCristal({
    double borderRadius = 30,
    double borderWidth = 1,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: WebColors.plataTranslucida,
      foregroundColor: WebColors.rosaMetalicoClaro,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: WebColors.bordeRosa,
          width: borderWidth,
        ),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        letterSpacing: 1.1,
      ),
    );
  }
}
