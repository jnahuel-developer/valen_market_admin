import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebDropdownClientes extends StatelessWidget {
  final List<String> clientes;
  final String? clienteSeleccionado;
  final ValueChanged<String?> onChanged;

  const CustomWebDropdownClientes({
    super.key,
    required this.clientes,
    required this.clienteSeleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: clienteSeleccionado,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Seleccionar cliente',
        filled: true,
        fillColor: WebColors.blanco,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
              color: WebColors.bordeControlDeshabilitado, width: 1.5),
        ),
        // Se definen los bordes cuando esté habilitado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.bordeControlHabilitado),
        ),
        // Se definen los bordes cuando esté deshabilitado
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.bordeControlDeshabilitado),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.negro, width: 1.5),
        ),
      ),
      items: clientes
          .map((cliente) => DropdownMenuItem<String>(
                value: cliente,
                child: Text(cliente),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
