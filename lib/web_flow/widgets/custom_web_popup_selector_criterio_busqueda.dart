import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';

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
          _buildCriterioButton(context, 'Cliente seleccionado'),
          const SizedBox(height: 12),
          _buildCriterioButton(context, 'Nombre seleccionado'),
          const SizedBox(height: 12),
          _buildCriterioButton(context, 'Apellido seleccionado'),
          const SizedBox(height: 12),
          _buildCriterioButton(context, 'Zona seleccionada'),
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
      width: 280,
      height: 50,
    );
  }
}
