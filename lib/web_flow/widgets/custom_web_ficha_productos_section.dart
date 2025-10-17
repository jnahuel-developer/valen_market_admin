import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class CustomWebProductosSection extends ConsumerStatefulWidget {
  const CustomWebProductosSection({super.key});

  @override
  ConsumerState<CustomWebProductosSection> createState() =>
      CustomWebProductosSectionState();
}

class CustomWebProductosSectionState
    extends ConsumerState<CustomWebProductosSection> {
  final CatalogoServiciosFirebase _catalogoService =
      CatalogoServiciosFirebase();

  bool _cargando = true;
  List<Map<String, dynamic>> _productosCatalogo = [];

  @override
  void initState() {
    super.initState();
    _cargarCatalogoInicial();
  }

  Future<void> _cargarCatalogoInicial() async {
    // Solo carga catálogo si el provider está vacío (modo agregar)
    final ficha = ref.read(fichaEnCursoProvider);
    if (!ficha.hayFichaValida) {
      // No cargar catálogo ahora, ya hay productos en la ficha
      setState(() => _cargando = false);
      return;
    }

    try {
      final catalogo = await _catalogoService.obtenerTodosLosProductos();
      setState(() {
        _productosCatalogo = catalogo;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando catálogo: $e')),
        );
      }
    }
  }

  void _onIncrementar(Map<String, dynamic> productoMap) {
    final uid = productoMap[FIELD_NAME__producto_ficha_model__ID].toString();
    if (uid.isEmpty) return;

    // Llamar al provider para incrementar
    ref.read(fichaEnCursoProvider.notifier).modificarCantidadDeProducto(
          uidProducto: uid,
          incrementar: true,
          datosCatalogo: productoMap,
        );
  }

  void _onDecrementar(Map<String, dynamic> productoMap) {
    final uid = productoMap[FIELD_NAME__producto_ficha_model__ID].toString();
    if (uid.isEmpty) return;

    // Llamar al provider para decrementar
    ref.read(fichaEnCursoProvider.notifier).modificarCantidadDeProducto(
          uidProducto: uid,
          incrementar: false,
          datosCatalogo: productoMap,
        );
  }

  void _onEditarProducto(Map<String, dynamic> productoMap, int cantidad) async {
    final uid = productoMap[FIELD_NAME__producto_ficha_model__ID].toString();
    if (uid.isEmpty) return;

    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CustomWebPopupEditarProducto(
        productoCatalogo: productoMap,
        cantidadSeleccionada: cantidad,
        onAceptar: (resultadoMap) {
          final nuevoPrecio =
              (resultadoMap['nuevoPrecioUnitario'] as double?) ?? 0.0;
          final nuevasCuotas =
              (resultadoMap['nuevaCantidadDeCuotas'] as int?) ?? 1;
          final nuevoImporteCuotas =
              (resultadoMap['nuevoPrecioDeCuotas'] as double?) ?? 0.0;

          ref.read(fichaEnCursoProvider.notifier).actualizarValoresDelProducto(
                uidProducto: uid,
                nuevoPrecioUnitario: nuevoPrecio,
                nuevaCantidadDeCuotas: nuevasCuotas,
                nuevoImporteDeLasCuotas: nuevoImporteCuotas,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ficha = ref.watch(fichaEnCursoProvider);

    return CustomWebBloqueConTitulo(
      titulo: 'Datos de los productos',
      child: _cargando
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final productosAMostrar = ficha.hayFichaValida
                    ? _productosCatalogo
                    : ficha.productos
                        .map((prodModel) => prodModel.toMap())
                        .toList();

                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productosAMostrar.length,
                  itemBuilder: (context, index) {
                    final productoMap = productosAMostrar[index];

                    // UID seguro (compatibilidad con catálogo o ficha)
                    final uid =
                        productoMap[FIELD_NAME__producto_ficha_model__ID]
                            .toString();

                    int cantidadActual = 0;

                    if (uid.isNotEmpty && !ficha.hayFichaValida) {
                      final existente = ficha
                          .obtenerProductos()
                          .where((p) => p.id == uid)
                          .toList(); // devuelve lista (vacía si no hay coincidencias)

                      if (existente.isNotEmpty) {
                        cantidadActual = existente.first.unidades;
                      }
                    }

                    return CustomWebFichaShopItem(
                      producto: productoMap,
                      cantidadSeleccionada: cantidadActual,
                      onIncrement: () => _onIncrementar(productoMap),
                      onDecrement: () => _onDecrementar(productoMap),
                      onEdit: cantidadActual > 0
                          ? () => _onEditarProducto(productoMap, cantidadActual)
                          : null,
                    );
                  },
                );
              },
            ),
    );
  }
}
