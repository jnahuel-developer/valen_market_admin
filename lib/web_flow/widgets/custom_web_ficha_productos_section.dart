import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_en_curso_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';
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
          SnackBar(content: Text('Error al cargar productos: $e')));
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
    final productos = <Map<String, dynamic>>[];

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

    if (cantidadActual == 0) {
      // Nuevo producto -> Cargar todos los datos desde el catálogo
      _agregarProductoNuevo(producto, nuevaCantidad);
    } else {
      // Producto existente -> Solo se actualiza la cantidad
      _actualizarCantidadDeProducto(productoId, nuevaCantidad);
    }
  }

  void _decrementarProducto(Map<String, dynamic> producto) {
    final productoId = producto['id'];
    final cantidadActual = cantidades[productoId] ?? 0;
    if (cantidadActual == 0) return;

    final nuevaCantidad = cantidadActual - 1;

    setState(() {
      cantidades[productoId] = nuevaCantidad;
    });

    if (nuevaCantidad == 0) {
      ref
          .read(fichaEnCursoProvider.notifier)
          .eliminarProductoPorUID(productoId);
    } else {
      _actualizarCantidadDeProducto(productoId, nuevaCantidad);
    }
  }

  void _agregarProductoNuevo(Map<String, dynamic> producto, int cantidad) {
    final productoId = producto['id'];

    final productoEnFicha = ProductoEnFicha(
      uidProducto: productoId,
      nombreProducto: producto['nombreProducto'] ?? '',
      unidades: cantidad,
      precioUnitario: (producto['Precio'] ?? 0).toDouble(),
      cantidadDeCuotas: producto['CantidadDeCuotas'] ?? 1,
      precioDeLasCuotas: (producto['Precio'] ?? 0).toDouble() /
          (producto['CantidadDeCuotas'] ?? 1),
      saldado: false,
      restante: 0.0,
    );

    ref.read(fichaEnCursoProvider.notifier).agregarProducto(productoEnFicha);
  }

  void _actualizarCantidadDeProducto(String productoId, int nuevaCantidad) {
    final fichaNotifier = ref.read(fichaEnCursoProvider.notifier);
    final fichaActual = ref.read(fichaEnCursoProvider);

    final productoExistente = fichaActual.productos.firstWhere(
      (p) => p.uidProducto == productoId,
    );

    final actualizado = ProductoEnFicha(
      uidProducto: productoExistente.uidProducto,
      nombreProducto: productoExistente.nombreProducto,
      unidades: nuevaCantidad,
      precioUnitario: productoExistente.precioUnitario,
      cantidadDeCuotas: productoExistente.cantidadDeCuotas,
      precioDeLasCuotas: productoExistente.precioDeLasCuotas,
      saldado: productoExistente.saldado,
      restante: nuevaCantidad * productoExistente.precioDeLasCuotas,
    );

    fichaNotifier.agregarProducto(actualizado);
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

  Future<void> _mostrarDialogEditarProducto(
      Map<String, dynamic> producto, int cantidadSeleccionada) async {
    final productoId =
        producto['id'] ?? producto['UID'] ?? producto['uid'] ?? '';

    // intentar obtener la entrada del producto dentro de la ficha (si existe)
    ProductoEnFicha? productoEnFicha;
    try {
      productoEnFicha = ref
          .read(fichaEnCursoProvider)
          .productos
          .firstWhere((p) => p.uidProducto == productoId);
    } catch (_) {
      productoEnFicha = null;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomWebPopupEditarProducto(
        productoCatalogo: producto,
        productoEnFicha: productoEnFicha,
        cantidadSeleccionada: cantidadSeleccionada,
        onAceptar:
            (double nuevoPrecio, int nuevasCuotas, double nuevoPrecioCuotas) {
          // Llamamos al provider para actualizar los valores del producto dentro de la ficha
          ref.read(fichaEnCursoProvider.notifier).actualizarValoresDelProducto(
                uidProducto: productoId,
                precioUnitario: nuevoPrecio,
                cantidadDeCuotas: nuevasCuotas,
                precioDeLasCuotas: nuevoPrecioCuotas,
              );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto actualizado en la ficha')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Se enlaza el provider para refrescar automáticamente la UI cuando se actualice una ficha
    final fichaActual = ref.watch(fichaEnCursoProvider);
    final productosEnFicha = fichaActual.productos;

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
              color: WebColors.controlDeshabilitado,
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
                      final productoId = producto['id'] ??
                          producto['UID'] ??
                          producto['uid'] ??
                          '';
                      final cantidad = cantidades[productoId] ?? 0;

                      // Se busca si este producto está en la ficha
                      ProductoEnFicha? productoEnFicha;
                      try {
                        productoEnFicha = productosEnFicha
                            .firstWhere((p) => p.uidProducto == productoId);
                      } catch (_) {
                        productoEnFicha = null;
                      }

                      // Se toman valores de la ficha si existen (ediciones incluidas)
                      final double precioMostrado =
                          productoEnFicha?.precioUnitario.toDouble() ??
                              (producto['Precio'] ?? 0).toDouble();
                      final double precioCuotaMostrado =
                          productoEnFicha?.precioDeLasCuotas.toDouble() ??
                              ((producto['Precio'] ?? 0).toDouble() /
                                  (producto['CantidadDeCuotas'] ?? 1));
                      final int cuotasMostradas =
                          productoEnFicha?.cantidadDeCuotas ??
                              (producto['CantidadDeCuotas'] ?? 1);

                      return CustomWebFichaShopItem(
                        producto: producto,
                        cantidadSeleccionada: cantidad,
                        onIncrement: () => _incrementarProducto(producto),
                        onDecrement: () => _decrementarProducto(producto),
                        onEdit: cantidad > 0
                            ? () =>
                                _mostrarDialogEditarProducto(producto, cantidad)
                            : null,
                        // Se usan los valores editados
                        precioPorFicha: precioMostrado,
                        precioDeCuotaPorFicha: precioCuotaMostrado,
                        cantidadDeCuotas: cuotasMostradas,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
