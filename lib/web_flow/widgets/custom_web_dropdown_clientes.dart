/// custom_web_dropdown_clientes.dart
///
/// Descripción:
/// - Muestra un Dropdown con la lista de clientes (recibida como List<String>).
/// - No accede a sub-providers. Solo lee el FichaEnCursoProvider para mostrar
///   el cliente actualmente cargado en la ficha (nombre + apellido).
/// - Al cambiar selección, se delega la acción al callback `onChanged` provisto
///   por el contenedor/parent (quien mantiene la lista completa y realizará el
///   mapeo a Map<String,dynamic> y actualizará el provider con `actualizarCliente`).
///
/// Interactúa con:
/// - CustomWebClienteSection (parent)
/// - FichaEnCursoProvider (solo lectura: nombreCliente / apellidoCliente)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class CustomWebDropdownClientes extends ConsumerWidget {
  final List<String> clientes;
  final String? clienteSeleccionado;
  final ValueChanged<String?> onChanged;

  const CustomWebDropdownClientes({
    super.key,
    required this.clientes,
    required this.clienteSeleccionado,
    required this.onChanged,
  });

  String? _formatNombreFromProvider(String? nombre, String? apellido) {
    if ((nombre ?? '').isEmpty && (apellido ?? '').isEmpty) return null;
    final n = (nombre ?? '').isEmpty ? '' : nombre!;
    final a = (apellido ?? '').isEmpty ? '' : apellido!;
    final full = '${_capitalizar(n)} ${_capitalizar(a)}'.trim();
    return full.isEmpty ? null : full;
  }

  String _capitalizar(String texto) =>
      texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ficha = ref.watch(fichaEnCursoProvider);
    final providerSelected =
        _formatNombreFromProvider(ficha.nombreCliente, ficha.apellidoCliente);

    // Use the explicit clienteSeleccionado if provided by parent; otherwise use provider.
    final valueToUse = clienteSeleccionado ?? providerSelected;

    return DropdownButtonFormField<String>(
      initialValue: valueToUse,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Seleccionar cliente',
        filled: true,
        fillColor: WebColors.blanco,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(
              color: WebColors.bordeControlDeshabilitado, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius),
          borderSide: BorderSide(color: WebColors.bordeControlHabilitado),
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
