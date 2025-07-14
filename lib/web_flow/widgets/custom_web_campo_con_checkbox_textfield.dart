import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoConCheckboxTextField extends StatefulWidget {
  final String label;

  const CustomWebCampoConCheckboxTextField({
    super.key,
    required this.label,
  });

  @override
  State<CustomWebCampoConCheckboxTextField> createState() =>
      _CustomWebCampoConCheckboxTextFieldState();
}

class _CustomWebCampoConCheckboxTextFieldState
    extends State<CustomWebCampoConCheckboxTextField> {
  bool editable = false;
  final TextEditingController controller = TextEditingController();

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
          child: TextField(
            controller: controller,
            enabled: editable,
            style: TextStyle(fontStyle: fontStyle),
            decoration: InputDecoration(
              filled: true,
              fillColor: WebColors.blanco,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
