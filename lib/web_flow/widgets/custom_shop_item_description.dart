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
        width: 350, // fijo para versión en grid de 3 columnas
        margin: const EdgeInsets.all(15),
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
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
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

            // Contenido textual alineado y equiespaciado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textItem('Resumen', descripcionCorta, fontSize: 18),
                  const SizedBox(height: 10),
                  if (descripcionLarga != null &&
                      descripcionLarga!.trim().isNotEmpty)
                    _textItem('Descripción', descripcionLarga!, fontSize: 12),
                  if (descripcionLarga != null &&
                      descripcionLarga!.trim().isNotEmpty)
                    const SizedBox(height: 10),
                  _textItem('Precio', '\$${precio.toStringAsFixed(2)}',
                      fontSize: 18),
                  const SizedBox(height: 10),
                  _textItem('Cuotas', cuotas.toString(), fontSize: 18),
                  const SizedBox(height: 10),
                  _textItem('Stock', stock.toString(), fontSize: 18),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textItem(String label, String value, {double fontSize = 14}) {
    return Text(
      '$label = $value',
      style: TextStyle(fontSize: fontSize),
    );
  }
}
