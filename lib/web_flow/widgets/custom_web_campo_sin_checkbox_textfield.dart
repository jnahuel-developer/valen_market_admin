/// custom_web_campo_sin_checkbox_textfield.dart
///
/// Descripción:
/// - Campo de solo lectura que muestra la Dirección o el Teléfono del cliente.
/// - No accede a sub-providers. Lee FichaEnCursoProvider para obtener el valor
///   actual del cliente y lo muestra. Cada cambio en el provider se reflejará
///   automáticamente por `ref.watch` en la UI.
///
/// Interactúa con:
/// - CustomWebClienteSection (parent)
/// - FichaEnCursoProvider (solo lectura: direccionCliente / telefonoCliente)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class CustomWebCampoSinCheckboxTextField extends ConsumerWidget {
  final String label;
  final bool isDireccion;

  const CustomWebCampoSinCheckboxTextField({
    super.key,
    required this.label,
    required this.isDireccion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ficha = ref.watch(fichaEnCursoProvider);
    final texto = isDireccion
        ? (ficha.direccionCliente ?? '')
        : (ficha.telefonoCliente ?? '');

    // Use a controller only to display the current value; recreate ensures it updates when texto changes.
    final controller = TextEditingController(text: texto);

    return Row(
      children: [
        const SizedBox(width: 40),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: controller,
              enabled: false,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: WebColors.negro,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
                  borderSide:
                      BorderSide(color: WebColors.bordeControlDeshabilitado),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
