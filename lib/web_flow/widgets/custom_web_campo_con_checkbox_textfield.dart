import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebCampoConCheckboxTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditable;
  final ValueChanged<bool> onCheckboxChanged;
  final ValueChanged<String>? onTextChanged; // Nuevo parámetro opcional

  const CustomWebCampoConCheckboxTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditable,
    required this.onCheckboxChanged,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isEditable,
          onChanged: (value) {
            if (value != null) onCheckboxChanged(value);
          },
          // Se define el color para cuando el Checkbox esté habilitado
          activeColor: WebColors.checkboxHabilitado,
        ),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: controller,
              enabled: isEditable,
              style: TextStyle(
                fontStyle: isEditable ? FontStyle.normal : FontStyle.italic,
                color: WebColors.negro,
                fontSize: 16,
              ),
              onSubmitted: isEditable
                  ? onTextChanged
                  : null, // Ejecutar al presionar Enter
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                // Se definen los bordes cuando esté habilitado
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
                  borderSide:
                      BorderSide(color: WebColors.bordeControlHabilitado),
                ),
                // Se definen los bordes cuando esté deshabilitado
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
                  borderSide:
                      BorderSide(color: WebColors.bordeControlDeshabilitado),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
                  borderSide: BorderSide(color: WebColors.negro, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
