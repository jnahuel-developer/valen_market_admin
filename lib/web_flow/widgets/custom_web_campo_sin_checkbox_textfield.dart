import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoSinCheckboxTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller = TextEditingController();

  CustomWebCampoSinCheckboxTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 50), // espacio reservado para el checkbox ausente
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontStyle: FontStyle.italic),
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: WebColors.blanco,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    BorderSide(color: WebColors.bordeGrisClaro, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    BorderSide(color: WebColors.bordeGrisClaro, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
