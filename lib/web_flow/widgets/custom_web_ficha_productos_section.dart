import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/model/ficha_en_curso_model.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class CustomWebProductosSection extends ConsumerStatefulWidget {
  final List<ProductoEnFicha>? productosDeFicha;

  const CustomWebProductosSection({
    super.key,
    this.productosDeFicha,
  });

  @override
  ConsumerState<CustomWebProductosSection> createState() =>
      CustomWebProductosSectionState();
}

class CustomWebProductosSectionState
    extends ConsumerState<CustomWebProductosSection> {
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
      if (widget.productosDeFicha != null) {
        await _cargarProductosDesdeFicha();
      } else {
        await _cargarCatalogoCompleto();
      }
    } catch (e) {
      setState(() => _cargando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  Future<void> _cargarCatalogoCompleto() async {
    final productos = await _catalogoService.obtenerTodosLosProductos();
    setState(() {
      _productos = productos;
      _cargando = false;
    });
  }

  Future<void> _cargarProductosDesdeFicha() async {
    final productos = <Map<String, dynamic>>{};

    for (final productoEnFicha in widget.productosDeFicha!) {
      final producto = await _catalogoService
          .obtenerProductoPorId(productoEnFicha.uidProducto);

      if (producto != null) {
        productos.add(producto);
        cantidades[productoEnFicha.uidProducto] = productoEnFicha.unidades;
      }
    }

    setState(() {
      _productos = productos.toList();
      _cargando = false;
    });
  }

  void _incrementarProducto(Map<String, dynamic> producto) {
    final productoId = producto['id'];
    final cantidadActual = cantidades[productoId] ?? 0;
    final nuevaCantidad = cantidadActual + 1;

    setState(() {
      cantidades[productoId] = nuevaCantidad;
    });

    _agregarOActualizarEnProvider(producto, nuevaCantidad);
  }

  void _decrementarProducto(Map<String, dynamic> producto) {
    final productoId = producto['id'];
    final cantidadActual = cantidades[productoId] ?? 0;
    if (cantidadActual == 0) return;

    final nuevaCantidad = cantidadActual - 1;

    setState(() {
      cantidades[productoId] = nuevaCantidad;
    });

    _agregarOActualizarEnProvider(producto, nuevaCantidad);
  }

  void _agregarOActualizarEnProvider(
      Map<String, dynamic> producto, int cantidadSeleccionada) {
    final productoId = producto['id'];

    if (cantidadSeleccionada == 0) {
      ref
          .read(fichaEnCursoProvider.notifier)
          .eliminarProductoPorUID(productoId);
      return;
    }

    final productoEnFicha = ProductoEnFicha(
      uidProducto: productoId,
      unidades: cantidadSeleccionada,
      precioUnitario: producto['Precio']?.toDouble() ?? 0.0,
      cantidadDeCuotas: producto['CantidadDeCuotas'] ?? 1,
      precioDeLasCuotas: 0.0,
      saldado: false,
      restante: 0.0,
    );

    ref.read(fichaEnCursoProvider.notifier).agregarProducto(productoEnFicha);
  }

  // Método público para resetear los productos y cantidades
  Future<void> resetear() async {
    setState(() {
      _productos = [];
      cantidades = {};
      _cargando = true;
    });

    await _cargarCatalogoCompleto();
  }

  @override
  Widget build(BuildContext context) {
    return CustomWebBloqueConTitulo(
      titulo: 'Datos de los productos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _productos.length,
                    itemBuilder: (context, index) {
                      final producto = _productos[index];
                      final productoId = producto['id'];
                      final cantidad = cantidades[productoId] ?? 0;

                      return CustomWebFichaShopItem(
                        producto: producto,
                        cantidadSeleccionada: cantidad,
                        onIncrement: () => _incrementarProducto(producto),
                        onDecrement: () => _decrementarProducto(producto),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
