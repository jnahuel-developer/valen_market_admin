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
          onChanged: (value) {
            if (value != null) onCheckboxChanged(value);
          },
          activeColor: WebColors.checkboxMorado,
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
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isEditable ? WebColors.negro : WebColors.grisClaro,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedOption,
              onChanged: isEditable ? onChanged : null,
              underline: const SizedBox(),
              iconEnabledColor:
                  isEditable ? WebColors.negro : WebColors.grisClaro,
              style: TextStyle(
                fontStyle: isEditable ? FontStyle.normal : FontStyle.italic,
                color: WebColors.negro,
                fontSize: 16,
              ),
              hint: Text(
                'Seleccionar zona',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: WebColors.grisClaro,
                  fontSize: 16,
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
