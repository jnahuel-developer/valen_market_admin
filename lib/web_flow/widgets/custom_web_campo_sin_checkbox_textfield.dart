import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoSinCheckboxTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomWebCampoSinCheckboxTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            enabled: false,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: WebColors.Negro,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: WebColors.bordeGrisClaro),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
