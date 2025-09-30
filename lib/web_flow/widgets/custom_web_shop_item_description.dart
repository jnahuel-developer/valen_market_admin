import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/catalogo/screens/web_editar_producto_screen.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class CustomShopItemDescription extends StatelessWidget {
  final String id;
  final String nombre;
  final String descripcionCorta;
  final String? descripcionLarga;
  final double precio;
  final int cuotas;
  final int stock;
  final String imageUrl;
  final VoidCallback? onRefresh;

  const CustomShopItemDescription({
    super.key,
    required this.id,
    required this.nombre,
    required this.descripcionCorta,
    this.descripcionLarga,
    required this.precio,
    required this.cuotas,
    required this.stock,
    required this.imageUrl,
    this.onRefresh,
  });

  Future<void> _confirmarAccion(BuildContext context, String tipo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$tipo producto'),
        content: Text("¿Seguro que quieres $tipo el producto '$nombre'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(tipo),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      switch (tipo) {
        case 'Eliminar':
          await CatalogoServiciosFirebase().eliminarProducto(id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Producto '$nombre' eliminado")),
            );
            onRefresh?.call();
          }
          break;
        case 'Editar':
          final producto = {
            'id': id,
            'NombreDelProducto': nombre,
            'DescripcionCorta': descripcionCorta,
            'DescripcionLarga': descripcionLarga,
            'Precio': precio,
            'CantidadDeCuotas': cuotas,
            'Stock': stock,
            'LinkDeLaFoto': imageUrl,
          };
          if (context.mounted) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WebEditarProductoScreen(producto: producto),
              ),
            );
            if (result == true) onRefresh?.call();
          }
          break;
        case 'Promocionar':
          // Acción futura
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
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
        children: [
          const SizedBox(height: 5),
          // Imagen del producto con margen y borde
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: WebColors.textoRosa, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image, size: 100)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Botones de acciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Promocionar',
                  icon:
                      const Icon(Icons.local_offer, color: WebColors.textoRosa),
                  onPressed: () => _confirmarAccion(context, 'Promocionar'),
                ),
                IconButton(
                  tooltip: 'Editar',
                  icon: const Icon(Icons.edit, color: WebColors.textoRosa),
                  onPressed: () => _confirmarAccion(context, 'Editar'),
                ),
                IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarAccion(context, 'Eliminar'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Nombre del producto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Texto descriptivo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textItem('Resumen', descripcionCorta, fontSize: 16),
                const SizedBox(height: 8),
                if (descripcionLarga != null &&
                    descripcionLarga!.trim().isNotEmpty)
                  _textItem('Descripción', descripcionLarga!, fontSize: 12),
                if (descripcionLarga != null &&
                    descripcionLarga!.trim().isNotEmpty)
                  const SizedBox(height: 8),
                _textItem('Precio', '\$${precio.toInt()}', fontSize: 16),
                const SizedBox(height: 8),
                _textItem('Cuotas', cuotas.toString(), fontSize: 16),
                const SizedBox(height: 8),
                _textItem('Stock', stock.toString(), fontSize: 16),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
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
