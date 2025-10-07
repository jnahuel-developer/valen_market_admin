import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebCampoFrecuenciaAviso extends StatefulWidget {
  final DateTime fechaBase;
  final Function(DateTime) onFechaCalculada;

  const CustomWebCampoFrecuenciaAviso({
    super.key,
    required this.fechaBase,
    required this.onFechaCalculada,
  });

  @override
  State<CustomWebCampoFrecuenciaAviso> createState() =>
      _CustomWebCampoFrecuenciaAvisoState();
}

class _CustomWebCampoFrecuenciaAvisoState
    extends State<CustomWebCampoFrecuenciaAviso> {
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  String _opcionSeleccionada = '7 días';
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _actualizarFecha();
  }

  void _actualizarFecha() {
    DateTime nuevaFecha;

    switch (_opcionSeleccionada) {
      case '7 días':
        nuevaFecha = widget.fechaBase.add(const Duration(days: 7));
        break;
      case '2 semanas':
        nuevaFecha = widget.fechaBase.add(const Duration(days: 14));
        break;
      case '1 mes':
        nuevaFecha = widget.fechaBase.add(const Duration(days: 30));
        break;
      default:
        nuevaFecha = widget.fechaBase;
        break;
    }

    _fechaController.text = _formatter.format(nuevaFecha);
    widget.onFechaCalculada(nuevaFecha);
  }

  Future<void> _mostrarSelectorDeFecha(BuildContext context) async {
    final DateTime hoy = DateTime.now();
    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: DateTime(hoy.year - 2),
      lastDate: DateTime(hoy.year + 2),
    );

    if (seleccion != null) {
      _fechaController.text = _formatter.format(seleccion);
      widget.onFechaCalculada(seleccion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final opciones = ['7 días', '2 semanas', '1 mes', 'Libre'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 150,
          child: Text(
            'Proximo aviso en:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // Radiobuttons
              for (var opcion in opciones)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: opcion,
                      groupValue: _opcionSeleccionada,
                      activeColor: WebColors.checkboxMorado,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _opcionSeleccionada = value;
                        });
                        if (value != 'Libre') {
                          _actualizarFecha();
                        }
                      },
                    ),
                    Text(opcion),
                    const SizedBox(width: 8),
                  ],
                ),

              const SizedBox(width: 20),

              // Campo de fecha
              SizedBox(
                width: 140,
                height: 45,
                child: TextField(
                  controller: _fechaController,
                  readOnly: true,
                  enabled: _opcionSeleccionada == 'Libre',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: WebColors.grisClaro),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: WebColors.checkboxMorado,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Botón para abrir calendario (solo si es Libre)
              IconButton(
                icon: const Icon(Icons.calendar_month),
                color: _opcionSeleccionada == 'Libre'
                    ? WebColors.checkboxMorado
                    : WebColors.grisClaro,
                onPressed: _opcionSeleccionada == 'Libre'
                    ? () => _mostrarSelectorDeFecha(context)
                    : null,
                tooltip: 'Seleccionar fecha libre',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
