import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/producto_ficha_model.dart';

class ProductoFichaProvider extends ChangeNotifier {
  final List<ProductoFichaModel> _productos = [];

  List<ProductoFichaModel> get productos => List.unmodifiable(_productos);

  // ------------------------------------------------------------
  // 🔹 Agregar producto
  // ------------------------------------------------------------
  void agregarProducto(ProductoFichaModel producto) {
    final index = _productos.indexWhere(
      (p) => p.uid == producto.uid,
    );
    if (index != -1) {
      _productos[index] = producto;
    } else {
      _productos.add(producto);
    }
    notifyListeners();
  }

  // ------------------------------------------------------------
  // 🔹 Eliminar producto
  // ------------------------------------------------------------
  void eliminarProductoPorUID(String uidProducto) {
    _productos.removeWhere((p) => p.uid == uidProducto);
    notifyListeners();
  }

  // ------------------------------------------------------------
  // 🔹 Actualizar cantidad de unidades
  // ------------------------------------------------------------
  void actualizarCantidadDeProducto(String uidProducto, int nuevaCantidad) {
    final index = _productos.indexWhere((p) => p.uid == uidProducto);
    if (index == -1) return;

    final producto = _productos[index];
    _productos[index] = producto.copyWith(
      unidades: nuevaCantidad,
    );

    notifyListeners();
  }

  // ------------------------------------------------------------
  // 🔹 Actualizar datos financieros del producto
  // ------------------------------------------------------------
  void actualizarValoresDelProducto({
    required String uidProducto,
    required double nuevoPrecioUnitario,
    required int nuevaCantidadDeCuotas,
    required double nuevoImporteDeLasCuotas,
  }) {
    final index = _productos.indexWhere((p) => p.uid == uidProducto);
    if (index == -1) return;

    final producto = _productos[index];
    _productos[index] = producto.copyWith(
      precioUnitario: nuevoPrecioUnitario,
      cantidadDeCuotas: nuevaCantidadDeCuotas,
      precioDeLasCuotas: nuevoImporteDeLasCuotas,
    );

    notifyListeners();
  }

  // ------------------------------------------------------------
  // 🔹 Limpiar lista
  // ------------------------------------------------------------
  void limpiarProductos() {
    _productos.clear();
    notifyListeners();
  }
}
