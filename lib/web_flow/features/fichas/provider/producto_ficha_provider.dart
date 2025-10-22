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
        .any((p) => p[FIELD_NAME__producto_ficha_model__ID] == producto.id);
    if (!existe && producto.id.isNotEmpty) {
      _productos.add(producto.toMap());
      notifyListeners();
    }
  }

  /// Actualiza un producto existente por UID
  void actualizarProducto(String id, Map<String, dynamic> datosActualizados) {
    final index = _productos
        .indexWhere((p) => p[FIELD_NAME__producto_ficha_model__ID] == id);
    if (index != -1) {
      final productoExistente = ProductoFichaModel.fromMap(_productos[index])
          .copyWith(datosActualizados);
      _productos[index] = productoExistente.toMap();
      notifyListeners();
    }
  }

  /// Elimina un producto por UID
  void eliminarProducto(String id) {
    _productos
        .removeWhere((p) => p[FIELD_NAME__producto_ficha_model__ID] == id);
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
