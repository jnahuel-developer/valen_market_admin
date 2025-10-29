import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';

class CustomWebProductosSection extends ConsumerStatefulWidget {
  const CustomWebProductosSection({super.key});

  @override
  ConsumerState<CustomWebProductosSection> createState() =>
      CustomWebProductosSectionState();
}

class CustomWebProductosSectionState
    extends ConsumerState<CustomWebProductosSection> {
  bool _cargando = true;
  List<Map<String, dynamic>> _productosVisibles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarLista();
    });
  }

  /* -------------------------------------------------------------------- */
  /* Function: _inicializarLista                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Initializes the list of visible products depending on   */
  /*  whether a valid record (ficha) exists or not.                       */
  /*                                                                      */
  /* Input: none                                                          */
  /* Output: Future<void>                                                 */
  /* -------------------------------------------------------------------- */
  Future<void> _inicializarLista() async {
    final fichaProvider = ref.read(fichaEnCursoProvider);

    try {
      // Se carga la lista de productos según si existe una ficha válida
      if (fichaProvider.hayFichaValida) {
        _productosVisibles = fichaProvider.obtenerProductos();
      } else {
        // Si no hay ficha válida, se usa el catálogo cacheado o se actualiza
        if (fichaProvider.catalogoCache.isEmpty) {
          await fichaProvider.actualizarCacheProductos();
        }
        _productosVisibles = fichaProvider.catalogoCache;
      }
    } catch (e, st) {
      debugPrint('Error al inicializar lista de productos: $e');
      debugPrintStack(stackTrace: st);
      _productosVisibles = [];
    } finally {
      setState(() => _cargando = false);
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: _buscarProductoPorId                                       */
  /* -------------------------------------------------------------------- */
  /* Description: Returns a product Map from the current record by ID,    */
  /*  or an empty Map if it does not exist.                               */
  /*                                                                      */
  /* Input: String idProducto                                             */
  /* Output: Map<String, dynamic>                                         */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> _buscarProductoPorId(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productosFicha = fichaProvider.obtenerProductos();

    return productosFicha.firstWhere(
      (p) =>
          p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
          idProducto.toString(),
      orElse: () => {},
    );
  }

  /* -------------------------------------------------------------------- */
  /* Function: _cantidadSeleccionada                                      */
  /* -------------------------------------------------------------------- */
  /* Description: Returns the current quantity of a product in the record.*/
  /*                                                                      */
  /* Input: String idProducto                                             */
  /* Output: int                                                          */
  /* -------------------------------------------------------------------- */
  int _cantidadSeleccionada(String idProducto) {
    final producto = _buscarProductoPorId(idProducto);
    if (producto.isEmpty) return 0;
    return (producto[FIELD_NAME__producto_ficha_model__Unidades] ?? 0).toInt();
  }

  /* -------------------------------------------------------------------- */
  /* Function: _incrementar                                               */
  /* -------------------------------------------------------------------- */
  /* Description: Increments the quantity of a product, or adds it if it  */
  /*  does not exist in the record.                                       */
  /*                                                                      */
  /* Input: String idProducto                                             */
  /* Output: void                                                         */
  /* -------------------------------------------------------------------- */
  void _incrementar(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productoExistente = _buscarProductoPorId(idProducto);

    // Si el producto no existe, se agrega desde el catálogo visible
    if (productoExistente.isEmpty) {
      final productoCatalogo = Map<String, dynamic>.from(
        _productosVisibles.firstWhere(
          (p) =>
              p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
              idProducto.toString(),
        ),
      );
      productoCatalogo[FIELD_NAME__producto_ficha_model__Unidades] = 1;
      fichaProvider.agregarProducto(productoCatalogo);
    } else {
      final nuevaCantidad =
          (productoExistente[FIELD_NAME__producto_ficha_model__Unidades] ?? 0) +
              1;
      fichaProvider.actualizarProducto(idProducto, {
        FIELD_NAME__producto_ficha_model__Unidades: nuevaCantidad,
      });
    }

    // Se actualiza el estado local para refrescar la vista
    setState(() {});
  }

  /* -------------------------------------------------------------------- */
  /* Function: _decrementar                                               */
  /* -------------------------------------------------------------------- */
  /* Description: Decrements the quantity of a product. If the resulting  */
  /*  value is zero, it removes the product from the record.              */
  /*                                                                      */
  /* Input: String idProducto                                             */
  /* Output: void                                                         */
  /* -------------------------------------------------------------------- */
  void _decrementar(String idProducto) {
    final fichaProvider = ref.read(fichaEnCursoProvider);
    final productoExistente = _buscarProductoPorId(idProducto);

    if (productoExistente.isEmpty) return;

    final cantidadActual =
        (productoExistente[FIELD_NAME__producto_ficha_model__Unidades] ?? 0)
            .toInt();

    if (cantidadActual <= 1) {
      fichaProvider.eliminarProducto(idProducto);
    } else {
      fichaProvider.actualizarProducto(idProducto, {
        FIELD_NAME__producto_ficha_model__Unidades: cantidadActual - 1,
      });
    }

    setState(() {});
  }

  /* -------------------------------------------------------------------- */
  /* Function: _editarProducto                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Opens the edit popup for the selected product.          */
  /*                                                                      */
  /* Input: String idProducto                                             */
  /* Output: Future<void>                                                 */
  /* -------------------------------------------------------------------- */
  Future<void> _editarProducto(String idProducto) async {
    await showDialog(
      context: context,
      builder: (context) =>
          CustomWebPopupEditarProducto(idProducto: idProducto),
    );

    // Se actualiza el estado local para reflejar los cambios
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return CustomWebBloqueConTitulo(
        titulo: TEXTO__custom_web_ficha_productos_section__titulo,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_productosVisibles.isEmpty) {
      return CustomWebBloqueConTitulo(
        titulo: TEXTO__custom_web_ficha_productos_section__titulo,
        child: const Center(
          child: Text(
            TEXTO__custom_web_ficha_productos_section__campo__sin_productos,
            style: TextStyle(color: WebColors.textoRosa, fontSize: 16),
          ),
        ),
      );
    }

    // Construcción principal del bloque de productos
    return CustomWebBloqueConTitulo(
      titulo: TEXTO__custom_web_ficha_productos_section__titulo,
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
                  ? () => _editarProducto(idProducto)
                  : null,
            );
          },
        ),
      ),
    );
  }
}
