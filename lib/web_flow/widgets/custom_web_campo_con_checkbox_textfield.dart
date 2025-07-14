import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoConCheckboxTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditable;
  final ValueChanged<bool> onCheckboxChanged;

  const CustomWebCampoConCheckboxTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditable,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isEditable,
          onChanged: (bool? newValue) {
            if (newValue != null) onCheckboxChanged(newValue);
          },
          activeColor: WebColors.checkboxMorado,
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            enabled: isEditable,
            style: TextStyle(
              fontStyle: isEditable ? FontStyle.normal : FontStyle.italic,
              color: WebColors.Negro,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: WebColors.bordeGrisClaro),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: WebColors.bordeGrisClaro),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: WebColors.Negro, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
