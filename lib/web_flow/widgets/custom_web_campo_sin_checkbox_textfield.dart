import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
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

    // Se lee el Map del cliente cargado en la ficha
    final cliente = ficha.obtenerCliente();

    // Se obtiene la dirección del Map de datos del cliente
    final direccion = cliente[FIELD_NAME__cliente_ficha_model__Direccion];

    // Se obtiene la dirección del Map de datos del cliente
    final telefono = cliente[FIELD_NAME__cliente_ficha_model__Telefono];

    // Se verifica si se debe mostrar la dirección o el teléfono
    final texto = isDireccion ? (direccion ?? '') : (telefono ?? '');

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
