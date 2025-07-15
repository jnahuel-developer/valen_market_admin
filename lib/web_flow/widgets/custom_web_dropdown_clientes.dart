import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

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
          borderSide: BorderSide(color: WebColors.bordeGrisClaro, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: WebColors.bordeGrisClaro, width: 1.5),
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
