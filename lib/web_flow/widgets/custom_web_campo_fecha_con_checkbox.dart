import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';

class CustomWebCampoFechaConCheckbox extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool usarHoy;
  final ValueChanged<bool> onCheckboxChanged;

  const CustomWebCampoFechaConCheckbox({
    required this.label,
    required this.controller,
    required this.usarHoy,
    required this.onCheckboxChanged,
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
    if (widget.usarHoy) {
      widget.controller.text = _formatter.format(DateTime.now());
    }
  }

  Future<void> _mostrarSelectorDeFecha(BuildContext context) async {
    DateTime fechaSeleccionada =
        DateTime.now().subtract(const Duration(days: 1));
    final DateTime hoy = DateTime.now();

    final DateTime? resultado = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        int dia = fechaSeleccionada.day;
        int mes = fechaSeleccionada.month;
        int anio = fechaSeleccionada.year;

        return AlertDialog(
          title: const Text('Seleccionar fecha'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Día
                  DropdownButton<int>(
                    value: dia,
                    onChanged: (value) {
                      if (value != null) setModalState(() => dia = value);
                    },
                    items: List.generate(31, (i) => i + 1)
                        .map((d) =>
                            DropdownMenuItem(value: d, child: Text('$d')))
                        .toList(),
                  ),
                  // Mes
                  DropdownButton<int>(
                    value: mes,
                    onChanged: (value) {
                      if (value != null) setModalState(() => mes = value);
                    },
                    items: List.generate(12, (i) => i + 1)
                        .map((m) =>
                            DropdownMenuItem(value: m, child: Text('$m')))
                        .toList(),
                  ),
                  // Año
                  DropdownButton<int>(
                    value: anio,
                    onChanged: (value) {
                      if (value != null) setModalState(() => anio = value);
                    },
                    items: List.generate(25, (i) => hoy.year - i)
                        .map((a) =>
                            DropdownMenuItem(value: a, child: Text('$a')))
                        .toList(),
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
                final seleccion = DateTime(anio, mes, dia);
                if (seleccion.isAfter(hoy)) {
                  Navigator.pop(context, null);
                } else {
                  Navigator.pop(context, seleccion);
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (resultado != null) {
      widget.controller.text = _formatter.format(resultado);
    } else {
      widget.controller.text = _formatter.format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('KEY__cliente_section__campo__fecha_de_venta'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Checkbox
        Checkbox(
          value: widget.usarHoy,
          onChanged: (value) {
            if (value != null) {
              widget.onCheckboxChanged(value);
              if (value) {
                widget.controller.text = _formatter.format(DateTime.now());
              } else {
                widget.controller.clear();
              }
              setState(() {});
            }
          },
          activeColor: WebColors.checkboxMorado,
        ),

        // Etiqueta
        SizedBox(
          width: 90,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(width: 15),

        // Campo + Botón
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 220,
                height: 50,
                child: TextField(
                  controller: widget.controller,
                  enabled: widget.usarHoy,
                  readOnly: true,
                  style: TextStyle(
                    fontStyle:
                        widget.usarHoy ? FontStyle.italic : FontStyle.normal,
                    color: WebColors.negro,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: WebColors.grisClaro),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: WebColors.negro),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: WebColors.negro, width: 1.5),
                    ),
                    hintText: TEXTO_ES__fichas_screen__campo__fecha_placeholder,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                color: widget.usarHoy
                    ? WebColors.grisClaro
                    : WebColors.checkboxMorado,
                onPressed: widget.usarHoy
                    ? null
                    : () => _mostrarSelectorDeFecha(context),
                tooltip: 'Seleccionar fecha',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
