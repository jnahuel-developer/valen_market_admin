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

  String _textSelectedRadioButton =
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ficha = ref.read(fichaEnCursoProvider);
      final DateTime today = DateTime.now();

      // Se evalúa si existe una fecha de aviso previa
      if (ficha.proximoAviso != null) {
        final DateTime aviso = ficha.proximoAviso!;
        final int diffDays = aviso.difference(today).inDays + 1;

        // Se evalúan las diferencias predefinidas para determinar el RadioButton
        if (diffDays == VALUE__frecuencia_aviso_widget__campo__opcion_1) {
          _textSelectedRadioButton =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1;
        } else if (diffDays ==
            VALUE__frecuencia_aviso_widget__campo__opcion_2) {
          _textSelectedRadioButton =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_2;
        } else if (diffDays ==
            VALUE__frecuencia_aviso_widget__campo__opcion_3) {
          _textSelectedRadioButton =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_3;
        } else {
          _textSelectedRadioButton =
              TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4;
        }

        // Se carga la fecha existente en el control
        _dateController.text = _formatter.format(aviso);
      } else {
        // Si no existe, se usa la opción por defecto (7 días)
        final DateTime newDate = today.add(
          const Duration(days: VALUE__frecuencia_aviso_widget__campo__opcion_1),
        );
        _dateController.text = _formatter.format(newDate);
        ref.read(fichaEnCursoProvider.notifier).actualizarProximoAviso(newDate);
      }

      setState(() {});
    });
  }

  void _actualizarFecha() {
    DateTime newDate;
    switch (_textSelectedRadioButton) {
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_1:
        newDate = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_1));
        break;
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_2:
        newDate = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_2));
        break;
      case TEXTO_ES__frecuencia_aviso_widget__campo__opcion_3:
        newDate = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_3));
        break;
      default:
        newDate = DateTime.now().add(const Duration(
            days: VALUE__frecuencia_aviso_widget__campo__opcion_1));
    }

    _dateController.text = _formatter.format(newDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fichaEnCursoProvider.notifier).actualizarProximoAviso(newDate);
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
      _dateController.text = _formatter.format(selectedDate);
      ref.read(fichaEnCursoProvider.notifier).actualizarFrecuenciaDeAviso(
          TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4);
      ref
          .read(fichaEnCursoProvider.notifier)
          .actualizarProximoAviso(selectedDate);

      setState(() {
        _textSelectedRadioButton =
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
      TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: opcion,
                      groupValue: _textSelectedRadioButton,
                      activeColor: WebColors.radioButtonHabilitado,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _textSelectedRadioButton = value;
                        });
                        _actualizarFecha();
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
                  controller: _dateController,
                  readOnly: true,
                  enabled: _textSelectedRadioButton ==
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
                color: _textSelectedRadioButton ==
                        TEXTO_ES__frecuencia_aviso_widget__campo__opcion_4
                    ? WebColors.iconHabilitado
                    : WebColors.controlDeshabilitado,
                onPressed: _textSelectedRadioButton ==
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
