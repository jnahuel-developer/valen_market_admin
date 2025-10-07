import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/textos.dart';
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
  final TextEditingController _sellDateController = TextEditingController();
  bool _useToday = true;

  @override
  void initState() {
    super.initState();
    _inicializarDesdeProvider();
  }

  void _inicializarDesdeProvider() {
    final ficha = ref.read(fichaEnCursoProvider);
    final today = DateTime.now();

    if (ficha.fechaDeVenta != null) {
      final fechaVenta = ficha.fechaDeVenta!;
      _sellDateController.text = _formatter.format(fechaVenta);

      // Se compara con la fecha actual ignorando la hora
      final bool mismaFecha = fechaVenta.year == today.year &&
          fechaVenta.month == today.month &&
          fechaVenta.day == today.day;

      _useToday = mismaFecha;
    } else {
      _sellDateController.text = _formatter.format(today);
      _useToday = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(fichaEnCursoProvider.notifier).actualizarFechaDeVenta(today);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomWebBloqueConTitulo(
      titulo: TEXTO_ES__fichas_fechas_widget__campo__titulo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWebCampoFechaConCheckbox(
            label: TEXTO_ES__fichas_fechas_widget__campo__label,
            controller: _sellDateController,
            useToday: _useToday,
            onCheckboxChanged: (v) {
              setState(() => _useToday = v);
              final date = v ? DateTime.now() : null;
              if (date != null) {
                _sellDateController.text = _formatter.format(date);
                ref
                    .read(fichaEnCursoProvider.notifier)
                    .actualizarFechaDeVenta(date);
              }
            },
            onDateSelected: (selectedDate) {
              ref
                  .read(fichaEnCursoProvider.notifier)
                  .actualizarFechaDeVenta(selectedDate);
            },
          ),
          const SizedBox(height: 20),
          CustomWebCampoFrecuenciaAviso(),
        ],
      ),
    );
  }
}
