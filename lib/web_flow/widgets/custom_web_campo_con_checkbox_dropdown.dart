import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoConCheckboxDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedOption;
  final bool isEditable;
  final ValueChanged<bool> onCheckboxChanged;
  final ValueChanged<String?> onChanged;

  const CustomWebCampoConCheckboxDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOption,
    required this.isEditable,
    required this.onCheckboxChanged,
    required this.onChanged,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isEditable ? WebColors.Negro : WebColors.bordeGrisClaro,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedOption,
              onChanged: isEditable ? onChanged : null,
              underline: const SizedBox(),
              iconEnabledColor:
                  isEditable ? WebColors.Negro : WebColors.bordeGrisClaro,
              style: TextStyle(
                fontStyle: isEditable ? FontStyle.normal : FontStyle.italic,
                color: WebColors.Negro,
                fontSize: 14,
              ),
              hint: Text(
                'Seleccionar zona',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: WebColors.bordeGrisClaro,
                  fontSize: 14,
                ),
              ),
              items: options.map((zona) {
                return DropdownMenuItem<String>(
                  value: zona,
                  child: Text(zona),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
