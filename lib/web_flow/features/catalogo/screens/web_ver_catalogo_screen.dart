import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_shop_item_description.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class WebVerCatalogoScreen extends StatefulWidget {
  const WebVerCatalogoScreen({super.key});

  @override
  State<WebVerCatalogoScreen> createState() => _WebVerCatalogoScreenState();
}

class _WebVerCatalogoScreenState extends State<WebVerCatalogoScreen> {
  final _catalogoService = CatalogoServiciosFirebase();
  bool _cargando = true;
  List<Map<String, dynamic>> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    try {
      final productos = await _catalogoService.obtenerTodosLosProductos();
      if (!mounted) return;
      setState(() {
        _productos = productos;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el catálogo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Catálogo completo',
            pantallaPadreRouteName: PANTALLA_WEB__Catalogo,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _productos.isEmpty
                    ? const Center(
                        child: Text('No hay productos en el catálogo.'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 1000;
                          final itemWidth = isWide
                              ? 350.0
                              : (constraints.maxWidth - 30).toDouble();

                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15,
                              runSpacing: 15,
                              children: _productos.map((producto) {
                                return SizedBox(
                                  width: itemWidth,
                                  child: CustomShopItemDescription(
                                    nombre: producto['NombreDelProducto'] ?? '',
                                    descripcionCorta:
                                        producto['DescripcionCorta'] ?? '',
                                    descripcionLarga:
                                        producto['DescripcionLarga'],
                                    precio:
                                        (producto['Precio'] ?? 0).toDouble(),
                                    cuotas: (producto['CantidadDeCuotas'] ?? 0)
                                        .toInt(),
                                    stock: (producto['Stock'] ?? 0).toInt(),
                                    imageUrl: producto['LinkDeLaFoto'] ?? '',
                                    onTap: () {
                                      // Acción futura
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
