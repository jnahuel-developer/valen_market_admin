import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomOpcionesDesplegables extends StatelessWidget {
  final List<String> opciones;
  final String? valorSeleccionado;
  final Function(String?) onChanged;

  const CustomOpcionesDesplegables({
    super.key,
    required this.opciones,
    required this.valorSeleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.sombra,
        borderRadius: BorderRadius.circular(
            VALUE__general_widget__campo__big_border_radius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valorSeleccionado,
          hint: const Text(
            'Seleccionar',
            style: TextStyle(color: Colors.white),
          ),
          dropdownColor: Colors.black87,
          style: const TextStyle(color: Colors.yellow, fontSize: 16),
          isExpanded: true,
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          items: opciones.map((String valor) {
            return DropdownMenuItem<String>(
              value: valor,
              child: Center(child: Text(valor.toUpperCase())),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
