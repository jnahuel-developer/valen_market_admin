import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';

class CustomWebProductosSection extends ConsumerStatefulWidget {
  const CustomWebProductosSection({super.key});

  @override
  ConsumerState<CustomWebProductosSection> createState() =>
      CustomWebProductosSectionState();
}

class CustomWebProductosSectionState
    extends ConsumerState<CustomWebProductosSection> {
  late List<Map<String, dynamic>> _productosVisibles;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _productosVisibles = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarLista();
    });
  }

  Future<void> _inicializarLista() async {
    final fichaProvider = ref.read(fichaEnCursoProvider);

    try {
      if (fichaProvider.hayFichaValida) {
        _productosVisibles = fichaProvider.obtenerProductos();
      } else {
        _productosVisibles = fichaProvider.catalogoCache;
      }
    } catch (e, st) {
      debugPrint('⚠️ [ProductosSection] Error al cargar productos: $e');
      debugPrintStack(stackTrace: st);
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  int _cantidadSeleccionada(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productosFicha = fichaProvider.obtenerProductos();
    final existente = productosFicha.firstWhere(
      (p) =>
          p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
          idProducto.toString(),
      orElse: () => {},
    );
    if (existente.isEmpty) return 0;
    return (existente[FIELD_NAME__producto_ficha_model__Unidades] ?? 0).toInt();
  }

  void _incrementar(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productosFicha = fichaProvider.obtenerProductos();
    final existente = productosFicha.firstWhere(
      (p) =>
          p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
          idProducto.toString(),
      orElse: () => {},
    );

    if (existente.isEmpty) {
      final nuevo = Map<String, dynamic>.from(
        _productosVisibles.firstWhere(
          (p) =>
              p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
              idProducto.toString(),
        ),
      );
      nuevo[FIELD_NAME__producto_ficha_model__Unidades] = 1;
      fichaProvider.agregarProducto(nuevo);
    } else {
      final nuevaCantidad =
          (existente[FIELD_NAME__producto_ficha_model__Unidades] ?? 0) + 1;
      fichaProvider.actualizarProducto(idProducto, {
        FIELD_NAME__producto_ficha_model__Unidades: nuevaCantidad,
      });
    }

    setState(() {});
  }

  void _decrementar(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productosFicha = fichaProvider.obtenerProductos();
    final existente = productosFicha.firstWhere(
      (p) =>
          p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
          idProducto.toString(),
      orElse: () => {},
    );

    if (existente.isEmpty) return;

    final cantidadActual =
        (existente[FIELD_NAME__producto_ficha_model__Unidades] ?? 0).toInt();

    if (cantidadActual <= 1) {
      fichaProvider.eliminarProducto(idProducto);
    } else {
      fichaProvider.actualizarProducto(idProducto, {
        FIELD_NAME__producto_ficha_model__Unidades: cantidadActual - 1,
      });
    }

    setState(() {});
  }

  Future<void> _editarProducto(
      Map<String, dynamic> producto, int cantidad) async {
    await showDialog(
      context: context,
      builder: (context) => CustomWebPopupEditarProducto(
        productoCatalogo: producto,
        cantidadSeleccionada: cantidad,
        onAceptar: (resultado) {
          final fichaProvider = ref.read(fichaEnCursoProvider);
          final idProducto =
              producto[FIELD_NAME__producto_ficha_model__ID].toString();

          fichaProvider.actualizarProducto(idProducto, {
            FIELD_NAME__producto_ficha_model__Precio_Unitario:
                resultado[FIELD_NAME__producto_ficha_model__Precio_Unitario],
            FIELD_NAME__catalogo__Cantidad_De_Cuotas:
                resultado[FIELD_NAME__catalogo__Cantidad_De_Cuotas],
            FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: resultado[
                FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas],
          });

          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return CustomWebBloqueConTitulo(
        titulo: 'Productos',
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final fichaProvider = ref.watch(fichaEnCursoProvider);
    _productosVisibles = fichaProvider.hayFichaValida
        ? fichaProvider.obtenerProductos()
        : fichaProvider.catalogoCache;

    if (_productosVisibles.isEmpty) {
      return CustomWebBloqueConTitulo(
        titulo: 'Productos',
        child: const Center(
          child: Text(
            'No hay productos disponibles',
            style: TextStyle(color: WebColors.textoRosa, fontSize: 16),
          ),
        ),
      );
    }

    return CustomWebBloqueConTitulo(
      titulo: 'Productos',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _productosVisibles.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final producto = _productosVisibles[index];
            final idProducto =
                producto[FIELD_NAME__producto_ficha_model__ID]?.toString() ??
                    '';
            final cantidadSeleccionada = _cantidadSeleccionada(idProducto);

            return CustomWebFichaShopItem(
              producto: producto,
              cantidadSeleccionada: cantidadSeleccionada,
              onIncrement: () => _incrementar(idProducto),
              onDecrement: () => _decrementar(idProducto),
              onEdit: cantidadSeleccionada > 0
                  ? () => _editarProducto(producto, cantidadSeleccionada)
                  : null,
            );
          },
        ),
      ),
    );
  }
}
