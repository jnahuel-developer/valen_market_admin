import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebFichaShopItem extends StatelessWidget {
  final Map<String, dynamic> producto;
  final int cantidadSeleccionada;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CustomWebFichaShopItem({
    super.key,
    required this.producto,
    required this.cantidadSeleccionada,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final String nombre = producto['NombreDelProducto'] ?? '';
    final double precio = (producto['Precio'] ?? 0).toDouble();
    final int stock = (producto['Stock'] ?? 0).toInt();
    final String imageUrl = producto['LinkDeLaFoto'] ?? '';

    final String precioFormateado =
        NumberFormat('#,###', 'es_AR').format(precio);

    return Container(
      decoration: BoxDecoration(
        color: WebColors.blanco,
        border: Border.all(color: WebColors.bordeRosa, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Contenedor de la imagen
          Container(
            width: 140, // Más angosto
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

          // Precio y Stock
          Text(
            'Precio: \$ $precioFormateado',
            style: const TextStyle(fontSize: 14),
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
