import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoConCheckboxDropdown extends StatefulWidget {
  final String label;

  const CustomWebCampoConCheckboxDropdown({
    super.key,
    required this.label,
  });

  @override
  State<CustomWebCampoConCheckboxDropdown> createState() =>
      _CustomWebCampoConCheckboxDropdownState();
}

class _CustomWebCampoConCheckboxDropdownState
    extends State<CustomWebCampoConCheckboxDropdown> {
  bool editable = false;
  String? selectedValue;

  final List<String> zonas = ['Norte', 'Sur', 'Este', 'Oeste'];

  @override
  Widget build(BuildContext context) {
    final borderColor =
        editable ? WebColors.bordeNegro : WebColors.bordeGrisClaro;
    final fontStyle = editable ? FontStyle.normal : FontStyle.italic;

    return Row(
      children: [
        Checkbox(
          value: editable,
          onChanged: (val) {
            setState(() {
              editable = val ?? false;
            });
          },
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(30),
              color: WebColors.blanco,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                'Seleccionar ${widget.label.toLowerCase()}',
                style: TextStyle(fontStyle: fontStyle),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: zonas.map((zona) {
                return DropdownMenuItem<String>(
                  value: zona,
                  child: Text(zona),
                );
              }).toList(),
              onChanged: editable
                  ? (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
