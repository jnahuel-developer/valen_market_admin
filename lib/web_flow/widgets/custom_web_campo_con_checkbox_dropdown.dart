/// custom_web_campo_con_checkbox_dropdown.dart
///
/// Descripción:
/// - Campo compuesto por checkbox + label + dropdown (lista de zonas).
/// - No accede a sub-providers. Cuando el usuario cambia la opción y el campo
///   está editable, el widget ejecuta `onChanged` para que el parent arme el
///   Map y actualice el provider con `actualizarCliente(Map)` o aplique el filtro.
///
/// Interactúa con:
/// - CustomWebClienteSection (parent) que decide cómo usar la selección
///   (filtro o actualización del cliente en el provider).
library;

import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebCampoConCheckboxDropdown extends StatefulWidget {
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
  State<CustomWebCampoConCheckboxDropdown> createState() =>
      _CustomWebCampoConCheckboxDropdownState();
}

class _CustomWebCampoConCheckboxDropdownState
    extends State<CustomWebCampoConCheckboxDropdown> {
  String? _selectedOptionLocal;

  @override
  void initState() {
    super.initState();
    _selectedOptionLocal = widget.selectedOption;
  }

  @override
  void didUpdateWidget(covariant CustomWebCampoConCheckboxDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep local selected in sync if parent changed it
    if (widget.selectedOption != oldWidget.selectedOption) {
      _selectedOptionLocal = widget.selectedOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isEditable,
          onChanged: (value) {
            if (value != null) widget.onCheckboxChanged(value);
            setState(() {});
          },
          activeColor: WebColors.checkboxHabilitado,
        ),
        SizedBox(
          width: 90,
          child: Text(
            widget.label,
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
                color: widget.isEditable
                    ? WebColors.negro
                    : WebColors.bordeControlDeshabilitado,
              ),
              borderRadius: BorderRadius.circular(
                  VALUE__general_widget__campo__big_border_radius),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedOptionLocal?.isEmpty == true
                  ? null
                  : _selectedOptionLocal,
              onChanged: widget.isEditable
                  ? (value) {
                      setState(() => _selectedOptionLocal = value);
                      widget.onChanged(value);
                    }
                  : null,
              underline: const SizedBox(),
              iconEnabledColor: widget.isEditable
                  ? WebColors.negro
                  : WebColors.bordeControlDeshabilitado,
              style: TextStyle(
                fontStyle:
                    widget.isEditable ? FontStyle.normal : FontStyle.italic,
                color: WebColors.negro,
                fontSize: 16,
              ),
              hint: Text(
                'Seleccionar zona',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: WebColors.bordeControlDeshabilitado,
                  fontSize: 16,
                ),
              ),
              items: widget.options
                  .map((zona) => DropdownMenuItem<String>(
                        value: zona,
                        child: Text(zona),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
