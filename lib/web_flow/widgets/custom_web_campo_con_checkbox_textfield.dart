/// custom_web_campo_con_checkbox_textfield.dart
///
/// Descripción:
/// - Campo compuesto por checkbox + label + textfield.
/// - No accede a sub-providers. Solo proporciona la UI para que el operador
///   edite un valor (nombre o apellido) y emita eventos al parent via
///   onCheckboxChanged / onTextChanged (ambos usan Map-only en la capa superior).
/// - Mantiene la apariencia y el comportamiento: cuando el checkbox está
///   desactivado, el TextField está en modo lectura (estilo itálico).
///
/// Interactúa con:
/// - CustomWebClienteSection (parent) que maneja la lista y llama a
///   fichaEnCursoProvider.actualizarCliente(Map) cuando corresponda.
library;

import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebCampoConCheckboxTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditable;
  final ValueChanged<bool> onCheckboxChanged;
  final ValueChanged<String>? onTextChanged;

  const CustomWebCampoConCheckboxTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditable,
    required this.onCheckboxChanged,
    this.onTextChanged,
  });

  @override
  State<CustomWebCampoConCheckboxTextField> createState() =>
      _CustomWebCampoConCheckboxTextFieldState();
}

class _CustomWebCampoConCheckboxTextFieldState
    extends State<CustomWebCampoConCheckboxTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.isEditable,
          onChanged: (value) {
            if (value != null) widget.onCheckboxChanged(value);
            setState(
                () {}); // permit visual update if parent changes isEditable
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
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: widget.controller,
              enabled: widget.isEditable,
              style: TextStyle(
                fontStyle:
                    widget.isEditable ? FontStyle.normal : FontStyle.italic,
                color: WebColors.negro,
                fontSize: 16,
              ),
              onSubmitted: widget.isEditable ? widget.onTextChanged : null,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
                  borderSide:
                      BorderSide(color: WebColors.bordeControlHabilitado),
                ),
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
