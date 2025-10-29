import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/producto_ficha_model.dart';

class ProductosFichaProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------- */
  /* Estructura interna en formato de lista                               */
  /* -------------------------------------------------------------------- */
  final List<Map<String, dynamic>> _productos = [];

  /* -------------------------------------------------------------------- */
  /* Function: obtenerProductos                                           */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: List                                                         */
  /* -------------------------------------------------------------------- */
  /* Description: Generate a list of the data loaded in memory            */
  /* -------------------------------------------------------------------- */
  List<Map<String, dynamic>> obtenerProductos() =>
      _productos.map((p) => Map<String, dynamic>.from(p)).toList();

  /* -------------------------------------------------------------------- */
  /* Function: agregarProducto                                            */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Add a new product (if it doesn't already exist by UID)  */
  /* -------------------------------------------------------------------- */
  void agregarProducto(Map<String, dynamic> nuevoProducto) {
    // Se contruye un modelo con los datos suministrados
    final producto = ProductoFichaModel.fromMap(nuevoProducto);

    // Se verifica si el producto existe en la lista
    final existe = _productos
        .any((p) => p[FIELD_NAME__producto_ficha_model__ID] == producto.id);

    // Si el producto no existe y su ID es válido, se lo agrega
    if (!existe && producto.id.isNotEmpty) {
      // Se agrega el producto en la lista
      _productos.add(producto.toMap());

      // Se emite la señal para que se actualicen los diversos controles afectados
      notifyListeners();
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarProducto                                         */
  /* -------------------------------------------------------------------- */
  /* Input: The product ID and its data Map                               */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Update an existing product by UID                       */
  /* -------------------------------------------------------------------- */
  void actualizarProducto(String id, Map<String, dynamic> datosActualizados) {
    // Se obtiene el índice del producto en la lista
    final index = _productos
        .indexWhere((p) => p[FIELD_NAME__producto_ficha_model__ID] == id);

    debugPrint('List completa antes del cambio: $_productos');

    // Se verifica si existe para actualizarlo
    if (index != -1) {
      // Se obtienen los datos del producto a almacenar
      final productoExistente = ProductoFichaModel.fromMap(_productos[index])
          .copyWith(datosActualizados);

      // Se actualiza el producto en la lista con los datos suministrados
      _productos[index] = productoExistente.toMap();

      debugPrint('List completa después del cambio: $_productos');

      // Se emite la señal para que se actualicen los diversos controles afectados
      notifyListeners();
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: eliminarProducto                                           */
  /* -------------------------------------------------------------------- */
  /* Input: The product ID                                                */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Delete an existing product by UID                       */
  /* -------------------------------------------------------------------- */
  void eliminarProducto(String id) {
    // Se elimina el producto que tenga el ID indicado
    _productos
        .removeWhere((p) => p[FIELD_NAME__producto_ficha_model__ID] == id);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: limpiarProductos                                           */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Completely clear the product list                       */
  /* -------------------------------------------------------------------- */
  void limpiarProductos() {
    _productos.clear();

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: copiarProductos                                            */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: List                                                         */
  /* -------------------------------------------------------------------- */
  /* Description: Return an independent copy of the current list          */
  /* -------------------------------------------------------------------- */
  List<Map<String, dynamic>> copiarProductos() =>
      _productos.map((p) => Map<String, dynamic>.from(p)).toList();
}
