import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class CustomWebProductosSection extends StatefulWidget {
  const CustomWebProductosSection({super.key});

  @override
  State<CustomWebProductosSection> createState() =>
      _CustomWebProductosSectionState();
}

class _CustomWebProductosSectionState extends State<CustomWebProductosSection> {
  final CatalogoServiciosFirebase _catalogoService =
      CatalogoServiciosFirebase();
  List<Map<String, dynamic>> _productos = [];
  Map<String, int> cantidades = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await _catalogoService.obtenerTodosLosProductos();
      setState(() {
        _productos = productos;
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WebColors.blanco,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WebColors.bordeRosa, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zona de filtros (por ahora solo un placeholder)
          Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: WebColors.grisClaro,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text('Zona de Filtros (próximamente)'),
          ),

          // Zona de productos
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, // Máximo ancho por ítem
                      mainAxisSpacing: 12, // Espacio vertical entre ítems
                      crossAxisSpacing: 12, // Espacio horizontal entre ítems
                      childAspectRatio: 0.75, // Relación ancho/alto
                    ),
                    itemCount: _productos.length,
                    itemBuilder: (context, index) {
                      final producto = _productos[index];
                      final productoId = producto['id'];
                      final cantidad = cantidades[productoId] ?? 0;

                      return CustomWebFichaShopItem(
                        producto: producto,
                        cantidadSeleccionada: cantidad,
                        onIncrement: () {
                          setState(() {
                            cantidades[productoId] = cantidad + 1;
                          });
                        },
                        onDecrement: () {
                          if (cantidad > 0) {
                            setState(() {
                              cantidades[productoId] = cantidad - 1;
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
