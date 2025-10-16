/// ---------------------------------------------------------------------------
/// PRODUCTO_FICHA_PROVIDER
///
/// 🔹 Rol general:
/// Gestiona la lista de productos asociados a la ficha en curso.
/// Es responsable de mantener coherencia en unidades, precios y cuotas.
///
/// 🔹 Forma de uso:
///   - Se utiliza solo dentro de [FichaEnCursoProvider].
///   - No debe ser accedido directamente por los Widgets.
///
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]: mediante sus métodos de alto nivel:
///       • `modificarCantidadDeProducto()`
///       • `actualizarValoresDelProducto()`
///   - [ProductoFichaModel]: modelo individual de producto.
///
/// 🔹 Lógica principal:
///   - Permite agregar, actualizar o eliminar productos.
///   - Actualiza cantidades y datos financieros de forma controlada.
///   - Mantiene la lista en estado inmutable hacia el exterior.
///
/// 🔹 Métodos disponibles:
///   • `List<ProductoFichaModel> get productos`
///   • `void agregarProducto(ProductoFichaModel producto)`
///   • `void eliminarProductoPorUID(String uidProducto)`
///   • `void actualizarCantidadDeProducto(String uidProducto, int nuevaCantidad)`
///   • `void actualizarValoresDelProducto({ ... })`
///   • `void limpiarProductos()`
///
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/producto_ficha_model.dart';

class ProductosFichaProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _productos = [];

  /// Devuelve una copia completa de la lista actual
  List<Map<String, dynamic>> obtenerProductos() =>
      _productos.map((p) => Map<String, dynamic>.from(p)).toList();

  /// Agrega un nuevo producto (si no existe ya por UID)
  void agregarProducto(Map<String, dynamic> nuevoProducto) {
    final producto = ProductoFichaModel.fromMap(nuevoProducto);
    final existe = _productos
        .any((p) => p[FIELD_NAME__producto_ficha_model__UID] == producto.uid);
    if (!existe && producto.uid.isNotEmpty) {
      _productos.add(producto.toMap());
      notifyListeners();
    }
  }

  /// Actualiza un producto existente por UID
  void actualizarProducto(String uid, Map<String, dynamic> datosActualizados) {
    final index = _productos
        .indexWhere((p) => p[FIELD_NAME__producto_ficha_model__UID] == uid);
    if (index != -1) {
      final productoExistente = ProductoFichaModel.fromMap(_productos[index])
          .copyWith(datosActualizados);
      _productos[index] = productoExistente.toMap();
      notifyListeners();
    }
  }

  /// Elimina un producto por UID
  void eliminarProducto(String uid) {
    _productos
        .removeWhere((p) => p[FIELD_NAME__producto_ficha_model__UID] == uid);
    notifyListeners();
  }

  /// Limpia completamente la lista de productos
  void limpiarProductos() {
    _productos.clear();
    notifyListeners();
  }

  /// Devuelve una copia independiente de la lista actual
  List<Map<String, dynamic>> copiarProductos() =>
      _productos.map((p) => Map<String, dynamic>.from(p)).toList();
}
