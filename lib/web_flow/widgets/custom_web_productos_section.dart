import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebProductosSection extends StatelessWidget {
  const CustomWebProductosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: WebColors.bordeRosa, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          'SECCIÓN DE PRODUCTOS\n(Próximamente)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
