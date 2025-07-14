import 'package:flutter/material.dart';

class CustomWebCampoConCheckboxDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? valueSeleccionado;
  final bool editable;
  final ValueChanged<String?> onChanged;
  final ValueChanged<bool> onCheckboxChanged;

  const CustomWebCampoConCheckboxDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.valueSeleccionado,
    required this.editable,
    required this.onChanged,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: editable,
          onChanged: (val) => onCheckboxChanged(val ?? false),
        ),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: IgnorePointer(
            ignoring: !editable,
            child: DropdownButtonFormField<String>(
              value: valueSeleccionado,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              items: items.map((zona) {
                return DropdownMenuItem(
                  value: zona,
                  child: Text(zona),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
