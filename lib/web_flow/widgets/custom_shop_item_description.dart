import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomShopItemDescription extends StatelessWidget {
  final String nombre;
  final String descripcionCorta;
  final String? descripcionLarga;
  final double precio;
  final int cuotas;
  final int stock;
  final String imageUrl;
  final VoidCallback? onTap;

  const CustomShopItemDescription({
    super.key,
    required this.nombre,
    required this.descripcionCorta,
    this.descripcionLarga,
    required this.precio,
    required this.cuotas,
    required this.stock,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: WebColors.bordeRosa, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Nombre del producto (centrado)
            Center(
              child: Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Descripción corta (izquierda)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                descripcionCorta,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            // Descripción larga si existe
            if (descripcionLarga != null &&
                descripcionLarga!.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  descripcionLarga!,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 15),

            // Precio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Precio = \$${precio.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 5),

            // Cuotas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Cuotas = $cuotas',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 5),

            // Stock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                'Stock = $stock',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
