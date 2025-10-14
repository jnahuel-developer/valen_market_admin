/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_FICHA_PRODUCTOS_SECTION
///
/// 🔹 Rol: Contenedor de la sección de productos de la ficha. Muestra un grid
///   con los productos (catalogo completo cuando no hay ficha en curso; sólo
///   los productos de la ficha cuando existe una ficha cargada).
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]:
///       • Lee si hay ficha en curso y la lista de productos de la ficha.
///       • Solicita modificar cantidades y actualizar valores financieros.
///   - [CatalogoServiciosFirebase]:
///       • Cuando no hay ficha, obtiene catálogo completo.
///       • Cuando hay ficha, obtiene datos de catálogo por UID para enriquecer
///         la vista de cada producto en ficha.
/// 🔹 Lógica:
///   - Cuando la ficha está vacía, se carga el catálogo completo y se muestran
///     los productos con cantidad 0 (localmente). Al incrementar, se llama al
///     provider para agregar/modificar el producto en la ficha mediante mapas.
///   - Cuando la ficha está cargada, se muestran sólo los productos de la ficha
///     enriquecidos con datos del catálogo. Incrementos/decrementos y edición
///     se realizan vía métodos del provider.
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
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

  /// Lista de productos preparados para mostrar en el grid.
  /// Cada elemento es el Map de catálogo enriquecido (contiene al menos
  /// los campos del catálogo y el ID del documento en 'ID').
  List<Map<String, dynamic>> _productosVisibles = [];

  /// Cantidades locales (cuando estamos mostrando catálogo) o reflejo de
  /// cantidades en ficha (cuando la ficha está cargada).
  final Map<String, int> _cantidades = {};

  @override
  void initState() {
    super.initState();
    _inicializarLista();
  }

  Future<void> _inicializarLista() async {
    setState(() => _cargando = true);

    final fichaActual = ref.read(fichaEnCursoProvider);
    final productosEnFicha = fichaActual.productos;

    try {
      // Si la ficha está vacía, se carga catálogo completo
      if (fichaActual.estaVacia) {
        final catalogo = await _catalogoService.obtenerTodosLosProductos();
        // catalogo: List<Map<String,dynamic>> donde cada mapa incluye 'ID'
        setState(() {
          _productosVisibles = catalogo;
          _cantidades.clear();
          for (final prod in catalogo) {
            final id = prod[FIELD_NAME__producto_ficha_model__UID];
            _cantidades[id] = 0;
          }
          _cargando = false;
        });
      } else {
        // Ficha cargada: mostrar sólo los productos de la ficha, enriquecidos
        final List<Map<String, dynamic>> lista = [];
        _cantidades.clear();

        for (final p in productosEnFicha) {
          final uid = p.uid;
          // se intenta obtener datos del catálogo para enriquecer
          final catalogoProducto =
              await _catalogoService.obtenerProductoPorId(uid);
          final Map<String, dynamic> merged = {};
          if (catalogoProducto != null) {
            merged.addAll(catalogoProducto);
          }
          // Aseguramos que el mapa contenga el ID/UID que usaremos
          merged[FIELD_NAME__producto_ficha_model__UID] = uid;
          merged['ID'] = uid;
          // Guardamos cantidad según producto de ficha
          _cantidades[uid] = p.unidades;
          lista.add(merged);
        }

        setState(() {
          _productosVisibles = lista;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando productos: $e')),
        );
      }
    }
  }

  Future<void> _incrementarProducto(Map<String, dynamic> producto) async {
    final productoId =
        producto['ID'] ?? producto[FIELD_NAME__producto_ficha_model__UID];
    final cantidadActual = _cantidades[productoId] ?? 0;

    // Construir datosCatalogo que exige el provider (se agregan claves necesarias)
    final datosCatalogo = Map<String, dynamic>.from(producto);
    // Asegurar clave de UID en formato esperado por provider
    datosCatalogo[FIELD_NAME__producto_ficha_model__UID] = productoId;

    // Llamada al provider
    ref.read(fichaEnCursoProvider).modificarCantidadDeProducto(
          uidProducto: productoId,
          incrementar: true,
          datosCatalogo: datosCatalogo,
        );

    // Actualizar vista localmente para feedback inmediato
    setState(() {
      _cantidades[productoId] = cantidadActual + 1;
    });
  }

  Future<void> _decrementarProducto(Map<String, dynamic> producto) async {
    final productoId = producto[FIELD_NAME__producto_ficha_model__UID];
    final cantidadActual = _cantidades[productoId] ?? 0;
    if (cantidadActual == 0) return;

    final datosCatalogo = Map<String, dynamic>.from(producto);
    datosCatalogo[FIELD_NAME__producto_ficha_model__UID] = productoId;

    ref.read(fichaEnCursoProvider).modificarCantidadDeProducto(
          uidProducto: productoId,
          incrementar: false,
          datosCatalogo: datosCatalogo,
        );

    setState(() {
      _cantidades[productoId] = (cantidadActual - 1).clamp(0, 99999);
    });
  }

  Future<void> _mostrarDialogEditarProducto(
      Map<String, dynamic> producto, int cantidadSeleccionada) async {
    final productoId = producto[FIELD_NAME__producto_ficha_model__UID];

    // Abrir popup y esperar mapa resultado
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CustomWebPopupEditarProducto(
        productoCatalogo: producto,
        cantidadSeleccionada: cantidadSeleccionada,
        onAceptar: (Map<String, dynamic> resultadoMap) {
          // resultadoMap debe contener:
          // { 'nuevoPrecioUnitario': double, 'nuevaCantidadDeCuotas': int, 'nuevoPrecioDeCuotas': double }
          final nuevoPrecio =
              resultadoMap['nuevoPrecioUnitario'] as double? ?? 0.0;
          final nuevasCuotas =
              resultadoMap['nuevaCantidadDeCuotas'] as int? ?? 1;
          final nuevoImporteCuotas =
              resultadoMap['nuevoPrecioDeCuotas'] as double? ?? 0.0;

          // Llamar al provider para actualizar valores financieros del producto
          ref.read(fichaEnCursoProvider).actualizarValoresDelProducto(
                uidProducto: productoId,
                nuevoPrecioUnitario: nuevoPrecio,
                nuevaCantidadDeCuotas: nuevasCuotas,
                nuevoImporteDeLasCuotas: nuevoImporteCuotas,
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
    // Se observa el provider para reaccionar si la ficha se actualiza externamente
    final fichaActual = ref.watch(fichaEnCursoProvider);

    // Si la ficha cambió y estamos mostrando catálogo, reinicializar para que
    // la lista visible y las cantidades se sincronicen. Pequeña heurística:
    // si ficha no está vacía y antes se mostraba catálogo, recargar.
    if (!fichaActual.estaVacia &&
        _productosVisibles.isNotEmpty &&
        (_cantidades.values.every((q) => q == 0))) {
      // recargar para mostrar sólo productos de ficha
      WidgetsBinding.instance.addPostFrameCallback((_) => _inicializarLista());
    }

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
                    itemCount: _productosVisibles.length,
                    itemBuilder: (context, index) {
                      final producto = _productosVisibles[index];
                      final productoId = producto['ID'] ??
                          producto[FIELD_NAME__producto_ficha_model__UID] ??
                          '';
                      final cantidad = _cantidades[productoId] ?? 0;

                      // Mostrar datos (si existe en ficha, preferir valores de ficha;
                      // en este widget los valores financieros mostrados vendrán desde
                      // catálogo o desde la ficha según lo que exista en la ficha).
                      return CustomWebFichaShopItem(
                        producto: producto,
                        cantidadSeleccionada: cantidad,
                        onIncrement: () => _incrementarProducto(producto),
                        onDecrement: () => _decrementarProducto(producto),
                        onEdit: cantidad > 0
                            ? () =>
                                _mostrarDialogEditarProducto(producto, cantidad)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
