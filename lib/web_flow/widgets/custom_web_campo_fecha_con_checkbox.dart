import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';

class CustomWebCampoFechaConCheckbox extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool usarHoy;
  final ValueChanged<bool> onCheckboxChanged;
  final ValueChanged<DateTime>? onDateSelected; // 🆕 Nuevo callback

  const CustomWebCampoFechaConCheckbox({
    required this.label,
    required this.controller,
    required this.usarHoy,
    required this.onCheckboxChanged,
    this.onDateSelected, // 🆕
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
    final DateTime hoy = DateTime.now();
    DateTime fechaActual = hoy;

    final DateTime? seleccion = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        int dia = fechaActual.day;
        int mes = fechaActual.month;
        int anio = fechaActual.year;

        return AlertDialog(
          title: const Text('Seleccionar fecha'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<int>(
                    value: dia,
                    items: List.generate(31, (i) => i + 1)
                        .map((d) =>
                            DropdownMenuItem(value: d, child: Text('$d')))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => dia = v ?? dia),
                  ),
                  DropdownButton<int>(
                    value: mes,
                    items: List.generate(12, (i) => i + 1)
                        .map((m) =>
                            DropdownMenuItem(value: m, child: Text('$m')))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => mes = v ?? mes),
                  ),
                  DropdownButton<int>(
                    value: anio,
                    items: List.generate(25, (i) => hoy.year - i)
                        .map((a) =>
                            DropdownMenuItem(value: a, child: Text('$a')))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => anio = v ?? anio),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, DateTime(anio, mes, dia));
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (seleccion != null) {
      widget.controller.text = _formatter.format(seleccion);

      // Se notifica al padre que se seleccionó una nueva fecha
      widget.onDateSelected?.call(seleccion);
    } else {
      widget.controller.text = _formatter.format(hoy);

      // Si cancela, también se notifica que se usa hoy
      widget.onDateSelected?.call(hoy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('KEY__cliente_section__campo__fecha_de_venta'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.usarHoy,
          onChanged: (value) {
            if (value != null) {
              widget.onCheckboxChanged(value);

              if (value) {
                widget.controller.text = _formatter.format(DateTime.now());
              }
              setState(() {});
            }
          },
          activeColor: WebColors.checkboxMorado,
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
                  enabled: !widget.usarHoy,
                  decoration: InputDecoration(
                    hintText: TEXTO_ES__fichas_screen__campo__fecha_placeholder,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: WebColors.grisClaro),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: WebColors.negro, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                color: !widget.usarHoy
                    ? WebColors.checkboxMorado
                    : WebColors.grisClaro,
                onPressed: !widget.usarHoy
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
