import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomWebFichaShopItem extends StatelessWidget {
  final Map<String, dynamic> producto;
  final int cantidadSeleccionada;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onEdit;
  final double? precioPorFicha;
  final double? precioDeCuotaPorFicha;
  final int? cantidadDeCuotas;

  const CustomWebFichaShopItem({
    super.key,
    required this.producto,
    required this.cantidadSeleccionada,
    required this.onIncrement,
    required this.onDecrement,
    this.onEdit,
    this.precioPorFicha,
    this.precioDeCuotaPorFicha,
    this.cantidadDeCuotas,
  });

  @override
  Widget build(BuildContext context) {
    final String nombre =
        producto['NombreDelProducto'] ?? producto['Nombre'] ?? '';
    final double precio =
        (precioPorFicha ?? producto['Precio'] ?? 0).toDouble();
    final int stock = (producto['Stock'] ?? 0).toInt();
    final String imageUrl = producto['LinkDeLaFoto'] ?? '';

    final String precioFormateado =
        NumberFormat('#,###', 'es_AR').format(precio);

    final double precioCuota = (precioDeCuotaPorFicha ??
            (producto['Precio'] ?? 0) / (producto['CantidadDeCuotas'] ?? 1))
        .toDouble();
    final int cuotas = cantidadDeCuotas ?? (producto['CantidadDeCuotas'] ?? 1);

    final String precioCuotaFormateado =
        NumberFormat('#,###', 'es_AR').format(precioCuota);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: WebColors.blanco,
            border: Border.all(color: WebColors.bordeRosa, width: 2),
            borderRadius: BorderRadius.circular(
                VALUE__general_widget__campo__big_border_radius),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen
              Container(
                width: 140,
                height: 120,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: WebColors.blanco,
                  border: Border.all(color: WebColors.bordeRosa),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 50),
                ),
              ),
              const SizedBox(height: 10),

              // Nombre
              Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              // Precio y cuotas
              Text(
                'Precio: \$ $precioFormateado',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),

              if (cuotas > 1)
                Text(
                  '$cuotas cuotas de \$ $precioCuotaFormateado',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),

              Text(
                'Stock: $stock',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),

              // Controles de cantidad
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onPressed: cantidadSeleccionada > 0 ? onDecrement : null,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 70,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: WebColors.bordeRosa),
                      borderRadius: BorderRadius.circular(30),
                      color: WebColors.blanco,
                    ),
                    child: Text(
                      cantidadSeleccionada.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildCircleButton(
                    icon: Icons.add,
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Botón de edición
        if (onEdit != null && cantidadSeleccionada > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                key: Key(
                    'KEY__custom_web_ficha_shop_item__boton__editar__${producto['id'] ?? producto['UID'] ?? ''}'),
                icon: Icon(Icons.edit, size: 20, color: WebColors.textoRosa),
                onPressed: onEdit,
                tooltip: 'Editar producto en ficha',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCircleButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: WebColors.plataTranslucida,
        border: Border.all(color: WebColors.bordeRosa),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: WebColors.textoRosa),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }
}
