import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';

class PopupSelectorCriterioBusqueda extends StatelessWidget {
  final Function(String criterioSeleccionado) onCriterioSeleccionado;

  const PopupSelectorCriterioBusqueda({
    super.key,
    required this.onCriterioSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar criterio de búsqueda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCriterioButton(context,
              TEXTO__resultados_widget__criterio__cliente_seleccionado),
          const SizedBox(height: 12),
          _buildCriterioButton(
              context, TEXTO__resultados_widget__criterio__nombre_seleccionado),
          const SizedBox(height: 12),
          _buildCriterioButton(context,
              TEXTO__resultados_widget__criterio__apellido_seleccionado),
          const SizedBox(height: 12),
          _buildCriterioButton(
              context, TEXTO__resultados_widget__criterio__zona_seleccionada),
          const SizedBox(height: 12),
          _buildCriterioButton(
              context, TEXTO__resultados_widget__criterio__fecha_de_venta),
          const SizedBox(height: 12),
          _buildCriterioButton(
              context, TEXTO__resultados_widget__criterio__fecha_de_aviso),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  Widget _buildCriterioButton(BuildContext context, String criterio) {
    return CustomGradientButton(
      text: criterio,
      onPressed: () {
        onCriterioSeleccionado(criterio);
        Navigator.of(context).pop(); // Cerrar el popup
      },
      width: 400,
      height: 70,
    );
  }
}
