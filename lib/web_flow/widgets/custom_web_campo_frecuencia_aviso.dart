/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_CAMPO_FRECUENCIA_AVISO
///
/// 🔹 Rol: Controla la programación del próximo aviso al cliente.
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]:
///       • Lee el próximo aviso actual.
///       • Actualiza la fecha de aviso según la opción seleccionada.
/// 🔹 Lógica:
///   - Los 3 primeros checkboxes generan fechas fijas (+7, +15, +30 días).
///   - El cuarto habilita la selección manual mediante un calendario.
///   - La fecha seleccionada se guarda en el Provider en formato normalizado.
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class CustomWebCampoFrecuenciaAviso extends ConsumerStatefulWidget {
  const CustomWebCampoFrecuenciaAviso({super.key});

  @override
  ConsumerState<CustomWebCampoFrecuenciaAviso> createState() =>
      _CustomWebCampoFrecuenciaAvisoState();
}

class _CustomWebCampoFrecuenciaAvisoState
    extends ConsumerState<CustomWebCampoFrecuenciaAviso> {
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  final TextEditingController _controller = TextEditingController();
  String _opcionSeleccionada =
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ficha = ref.read(fichaEnCursoProvider);
      final today = DateTime.now();

      if (ficha.proximoAviso != null) {
        final aviso = ficha.proximoAviso!;
        final diff = aviso.difference(today).inDays;

        if (diff == VALUE__frecuencia_aviso_widget__campo__opcion_1) {
          _opcionSeleccionada =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1;
        } else if (diff == VALUE__frecuencia_aviso_widget__campo__opcion_2) {
          _opcionSeleccionada =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_2;
        } else if (diff == VALUE__frecuencia_aviso_widget__campo__opcion_3) {
          _opcionSeleccionada =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_3;
        } else {
          _opcionSeleccionada =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4;
        }

        _controller.text = _formatter.format(aviso);
      } else {
        _actualizarFecha(); // Inicializa con +7 días por defecto
      }

      setState(() {});
    });
  }

  void _actualizarFecha() {
    DateTime fecha;
    switch (_opcionSeleccionada) {
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1:
        fecha = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_1));
        break;
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_2:
        fecha = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_2));
        break;
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_3:
        fecha = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_3));
        break;
      default:
        fecha = DateTime.now();
    }

    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    _controller.text = _formatter.format(fechaNormalizada);

    ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
      'proximoAviso': fechaNormalizada,
    });
  }

  Future<void> _mostrarSelectorDeFecha(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime upperLimit = DateTime(
      today.year,
      today.month +
          VALUE__frecuencia_aviso_widget__campo__limite_superior_mensual,
      today.day,
    );

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: upperLimit,
    );

    if (selectedDate != null) {
      final fechaNormalizada =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

      _controller.text = _formatter.format(fechaNormalizada);

      ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
        'proximoAviso': fechaNormalizada,
      });

      setState(() {
        _opcionSeleccionada =
            TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final opciones = [
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1,
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_2,
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_3,
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 150,
          child: Text(
            TEXTO_ES__frecuencia_aviso_widget__campo__titulo,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              for (var opcion in opciones)
                Row(
                  children: [
                    Radio<String>(
                      value: opcion,
                      groupValue: _opcionSeleccionada,
                      activeColor: WebColors.radioButtonHabilitado,
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _opcionSeleccionada = v);
                        if (v !=
                            TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4) {
                          _actualizarFecha();
                        }
                      },
                    ),
                    Text(opcion),
                    const SizedBox(width: 8),
                  ],
                ),
              const SizedBox(width: 20),
              SizedBox(
                width: 140,
                height: 45,
                child: TextField(
                  controller: _controller,
                  readOnly: true,
                  enabled: _opcionSeleccionada ==
                      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4,
                  decoration: InputDecoration(
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
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                color: _opcionSeleccionada ==
                        TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4
                    ? WebColors.iconHabilitado
                    : WebColors.controlDeshabilitado,
                onPressed: _opcionSeleccionada ==
                        TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4
                    ? () => _mostrarSelectorDeFecha(context)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
