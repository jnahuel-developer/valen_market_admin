import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebCampoFechaConCheckbox extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool useToday;
  final ValueChanged<bool> onCheckboxChanged;
  final ValueChanged<DateTime>? onDateSelected;

  const CustomWebCampoFechaConCheckbox({
    required this.label,
    required this.controller,
    required this.useToday,
    required this.onCheckboxChanged,
    this.onDateSelected,
    super.key,
  });

  @override
  State<CustomWebCampoFechaConCheckbox> createState() =>
      _CustomWebCampoFechaConCheckboxState();
}

class _CustomWebCampoFechaConCheckboxState
    extends State<CustomWebCampoFechaConCheckbox> {
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    // Si viene vacío, cargamos fecha actual
    if (widget.controller.text.isEmpty) {
      widget.controller.text = _formatter.format(DateTime.now());
    }
  }

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
      widget.controller.text = _formatter.format(seleccion);

      // Se notifica al padre que se seleccionó una nueva fecha
      widget.onDateSelected?.call(seleccion);
    } else {
      widget.controller.text = _formatter.format(today);

      // Si cancela, también se notifica que se usa hoy
      widget.onDateSelected?.call(today);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('KEY__cliente_section__campo__fecha_de_venta'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.useToday,
          onChanged: (value) {
            if (value != null) {
              widget.onCheckboxChanged(value);

              if (value) {
                widget.controller.text = _formatter.format(DateTime.now());
              }
              setState(() {});
            }
          },
          // Se define el color para cuando el Checkbox esté habilitado
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
                  controller: widget.controller,
                  readOnly: true,
                  enabled: !widget.useToday,
                  decoration: InputDecoration(
                    hintText: TEXTO_ES__fichas_screen__campo__fecha_placeholder,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    // Se definen los bordes cuando esté habilitado
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          VALUE__general_widget__campo__big_border_radius),
                      borderSide:
                          BorderSide(color: WebColors.bordeControlHabilitado),
                    ),
                    // Se definen los bordes cuando esté deshabilitado
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
                color: !widget.useToday
                    ? WebColors.iconHabilitado
                    : WebColors.controlDeshabilitado,
                onPressed: !widget.useToday
                    ? () => _mostrarSelectorDeFecha(context)
                    : null,
                tooltip: 'Seleccionar fecha',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
