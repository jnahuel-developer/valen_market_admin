import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_fecha_con_checkbox.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_frecuencia_aviso.dart';

class CustomWebFichaFechasSection extends ConsumerStatefulWidget {
  const CustomWebFichaFechasSection({super.key});

  @override
  ConsumerState<CustomWebFichaFechasSection> createState() =>
      _CustomWebFichaFechasSectionState();
}

class _CustomWebFichaFechasSectionState
    extends ConsumerState<CustomWebFichaFechasSection> {
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  final TextEditingController _fechaVentaController = TextEditingController();
  final TextEditingController _fechaAvisoController = TextEditingController();

  bool _usarHoy = true;
  final String _frecuenciaSeleccionada = '7 días';

  @override
  void initState() {
    super.initState();
    _inicializarDesdeProvider();
  }

  void _inicializarDesdeProvider() {
    final ficha = ref.read(fichaEnCursoProvider);

    // Fecha de venta
    if (ficha.fechaDeVenta != null) {
      _fechaVentaController.text = _formatter.format(ficha.fechaDeVenta!);
      _usarHoy = false;
    } else {
      _fechaVentaController.text = _formatter.format(DateTime.now());
      _usarHoy = true;
    }

    // Fecha de aviso
//    if (ficha.proximoAviso != null) {
//      _fechaAvisoController.text = _formatter.format(ficha.proximoAviso!);
//    } else {
    final hoy = DateTime.now();
    final aviso = hoy.add(const Duration(days: 7));
    _fechaAvisoController.text = _formatter.format(aviso);
//      ref.read(fichaEnCursoProvider.notifier).actualizarProximoAviso(aviso);
//    }
  }

  void _actualizarFechaAvisoSegunFrecuencia() {
    final hoy = DateTime.now();
    DateTime nuevaFecha;

    switch (_frecuenciaSeleccionada) {
      case '7 días':
        nuevaFecha = hoy.add(const Duration(days: 7));
        break;
      case '2 semanas':
        nuevaFecha = hoy.add(const Duration(days: 14));
        break;
      case '1 mes':
        nuevaFecha = DateTime(hoy.year, hoy.month + 1, hoy.day);
        break;
      case 'Libre':
        // Si es libre, el usuario elige manualmente — no se modifica acá.
        return;
      default:
        nuevaFecha = hoy.add(const Duration(days: 7));
    }

    _fechaAvisoController.text = _formatter.format(nuevaFecha);
//    ref.read(fichaEnCursoProvider.notifier).actualizarProximoAviso(nuevaFecha);
  }

  @override
  Widget build(BuildContext context) {
    return CustomWebBloqueConTitulo(
      titulo: 'Fechas de control',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha de venta (movida desde sección cliente)
          CustomWebCampoFechaConCheckbox(
            label: '¿Vendida hoy?',
            controller: _fechaVentaController,
            usarHoy: _usarHoy,
            onCheckboxChanged: (v) {
              setState(() => _usarHoy = v);

              if (!v) {
                debugPrint('Modo manual activado, esperando selección.');
              } else {
                final hoy = DateTime.now();
                _fechaVentaController.text = _formatter.format(hoy);
                debugPrint('Usando fecha de hoy: $hoy');

                ref
                    .read(fichaEnCursoProvider.notifier)
                    .actualizarFechaDeVenta(hoy);
              }
            },
            onDateSelected: (fechaSeleccionada) {
              debugPrint('Fecha de venta seleccionada: $fechaSeleccionada');
              ref
                  .read(fichaEnCursoProvider.notifier)
                  .actualizarFechaDeVenta(fechaSeleccionada);
            },
          ),
          const SizedBox(height: 20),

          // Frecuencia de aviso
          CustomWebCampoFrecuenciaAviso(
            fechaBase: DateTime.now(),
            onFechaCalculada: (nuevaFecha) {
//              ref
//                  .read(fichaEnCursoProvider.notifier)
//                  .actualizarProximoAviso(nuevaFecha);
            },
          ),
        ],
      ),
    );
  }
}
