import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/keys.dart';
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

      // Se lee el Map de fechas cargadas en la ficha
      final fechas = ficha.obtenerFechas();

      // Se obtiene la fecha de venta del Map de fechas
      final fechaVenta =
          fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta] as DateTime?;

      // Se toma la fecha de hoy
      final DateTime today = DateTime.now();

      // Se verifica si existe una fecha de venta cargada en la ficha en curso
      if (fechaVenta != null) {
        // Si la hay, se la carga en el controlador para que el operador la vea
        _controller.text = _formatter.format(fechaVenta);

        // Se verifica si la fecha de venta cargada es de hoy
        _useToday = _esMismaFecha(fechaVenta, today);
      } else {
        // Caso contrario, no hay fecha de venta. Se debe setear hoy por defecto
        _controller.text = _formatter.format(today);
        _useToday = true;

        // Se actualiza la fecha de venta en el Provider
        ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
          FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: today,
        });
      }

      setState(() {});
    });
  }

  // Función auxiliar para comparar 2 fechas. No se usan los datos de la hora
  bool _esMismaFecha(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _mostrarSelectorDeFecha(BuildContext context) async {
    final DateTime hoy = DateTime.now();
    final DateTime limiteInferior = DateTime(hoy.year - 2, hoy.month, hoy.day);

    final DateTime? seleccion = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: limiteInferior,
      lastDate: hoy,
    );

    if (seleccion != null) {
      final fechaNormalizada =
          DateTime(seleccion.year, seleccion.month, seleccion.day);

      setState(() {
        _controller.text = _formatter.format(fechaNormalizada);
        _useToday = _esMismaFecha(fechaNormalizada, hoy);
      });

      ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: fechaNormalizada,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: KEY__cliente_section__campo__fecha_de_venta,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Checkbox para usar la fecha de hoy
        Checkbox(
          value: _useToday,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _useToday = value);

            final DateTime hoy = DateTime.now();
            if (value) {
              // Si el usuario marca el checkbox, se usa la fecha de hoy
              _controller.text = _formatter.format(hoy);
              ref.read(fichaEnCursoProvider.notifier).actualizarFechas({
                FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: hoy,
              });
            }
          },
          activeColor: WebColors.checkboxHabilitado,
        ),

        // Etiqueta "Fecha de venta"
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

        // Campo de texto + ícono calendario
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 220,
                height: 50,
                child: TextField(
                  controller: _controller,
                  readOnly: true, // nunca editable manualmente
                  enabled:
                      !_useToday, // visualmente deshabilitado si se usa hoy
                  decoration: InputDecoration(
                    hintText: TEXTO__fichas_screen__campo__fecha_placeholder,
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
                tooltip: TEXTO__fichas_fechas_widget__campo__seleccionar_fecha,
                onPressed:
                    !_useToday ? () => _mostrarSelectorDeFecha(context) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
