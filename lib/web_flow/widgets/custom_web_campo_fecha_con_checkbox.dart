/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_CAMPO_FECHA_CON_CHECKBOX
///
/// 🔹 Rol: Controla la fecha de venta de una ficha.
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]:
///       • Lee la fecha de venta actual.
///       • Actualiza el campo de venta en el provider.
/// 🔹 Lógica:
///   - Si "usar hoy" está activo → carga la fecha actual y desactiva el selector.
///   - Si está desactivado → permite elegir una fecha manualmente.
///   - Inicializa automáticamente desde el Provider si hay una fecha previa.
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class CustomWebCampoFechaConCheckbox extends ConsumerStatefulWidget {
  final String label;

  const CustomWebCampoFechaConCheckbox({
    required this.label,
    super.key,
  });

  @override
  ConsumerState<CustomWebCampoFechaConCheckbox> createState() =>
      _CustomWebCampoFechaConCheckboxState();
}

class _CustomWebCampoFechaConCheckboxState
    extends ConsumerState<CustomWebCampoFechaConCheckbox> {
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  final TextEditingController _controller = TextEditingController();
  bool _useToday = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ficha = ref.read(fichaEnCursoProvider);
      final today = DateTime.now();

      if (ficha.fechaDeVenta != null) {
        final fecha = ficha.fechaDeVenta!;
        _controller.text = _formatter.format(fecha);
        _useToday = _mismaFecha(fecha, today);
      } else {
        _controller.text = _formatter.format(today);
        _useToday = true;

        ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
          'venta': today,
        });
      }

      setState(() {});
    });
  }

  bool _mismaFecha(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _mostrarSelectorDeFecha(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime limiteInferior =
        DateTime(today.year - 2, today.month, today.day);

    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: limiteInferior,
      lastDate: today,
    );

    if (seleccion != null) {
      final fechaNormalizada =
          DateTime(seleccion.year, seleccion.month, seleccion.day);

      _controller.text = _formatter.format(fechaNormalizada);
      ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
        'venta': fechaNormalizada,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('KEY__cliente_section__campo__fecha_de_venta'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _useToday,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _useToday = value);
            final DateTime today = DateTime.now();

            if (value) {
              _controller.text = _formatter.format(today);
              ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
                'venta': today,
              });
            }
          },
          activeColor: WebColors.checkboxHabilitado,
        ),
        SizedBox(
          width: 120,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 220,
                height: 50,
                child: TextField(
                  controller: _controller,
                  readOnly: true,
                  enabled: !_useToday,
                  decoration: InputDecoration(
                    hintText: TEXTO_ES__fichas_screen__campo__fecha_placeholder,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          VALUE__general_widget__campo__big_border_radius),
                      borderSide:
                          BorderSide(color: WebColors.bordeControlHabilitado),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          VALUE__general_widget__campo__big_border_radius),
                      borderSide: BorderSide(
                          color: WebColors.bordeControlDeshabilitado),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          VALUE__general_widget__campo__big_border_radius),
                      borderSide:
                          BorderSide(color: WebColors.negro, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                color: !_useToday
                    ? WebColors.iconHabilitado
                    : WebColors.controlDeshabilitado,
                onPressed:
                    !_useToday ? () => _mostrarSelectorDeFecha(context) : null,
                tooltip: 'Seleccionar fecha',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
