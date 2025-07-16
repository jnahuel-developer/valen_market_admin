import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/model/ficha_en_curso_model.dart';

final fichaEnCursoProvider =
    StateNotifierProvider<FichaEnCursoNotifier, FichaEnCurso>(
  (ref) => FichaEnCursoNotifier(),
);

class FichaEnCursoNotifier extends StateNotifier<FichaEnCurso> {
  FichaEnCursoNotifier() : super(FichaEnCurso());

  void seleccionarCliente(String uidCliente) {
    state = state.copyWith(uidCliente: uidCliente);
  }

  void agregarProducto(ProductoEnFicha producto) {
    // Verificamos si el producto ya existe en la lista
    final indexExistente = state.productos
        .indexWhere((p) => p.uidProducto == producto.uidProducto);

    if (indexExistente != -1) {
      // Ya existe: actualizamos el producto con la nueva cantidad y recalculamos el restante
      final productoExistente = state.productos[indexExistente];
      final nuevaCantidad = producto.unidades;

      final productoActualizado = ProductoEnFicha(
        uidProducto: producto.uidProducto,
        unidades: nuevaCantidad,
        precioUnitario: producto.precioUnitario,
        cantidadDeCuotas: producto.cantidadDeCuotas,
        precioDeLasCuotas: producto.precioDeLasCuotas,
        saldado: productoExistente.saldado,
        restante: nuevaCantidad * producto.precioDeLasCuotas,
      );

      final productosActualizados = [...state.productos];
      productosActualizados[indexExistente] = productoActualizado;

      print(
          '🔄 Producto actualizado en provider: ${producto.uidProducto} - unidades: $nuevaCantidad');
      state = state.copyWith(productos: productosActualizados);
    } else {
      // No existe: agregamos el producto
      final productoConRestante = ProductoEnFicha(
        uidProducto: producto.uidProducto,
        unidades: producto.unidades,
        precioUnitario: producto.precioUnitario,
        cantidadDeCuotas: producto.cantidadDeCuotas,
        precioDeLasCuotas: producto.precioDeLasCuotas,
        saldado: false,
        restante: producto.unidades * producto.precioDeLasCuotas,
      );

      print(
          '🆕 Producto agregado al provider: ${producto.uidProducto} - unidades: ${producto.unidades}');
      state =
          state.copyWith(productos: [...state.productos, productoConRestante]);
    }
  }

  void eliminarProductoPorUID(String uidProducto) {
    final nuevosProductos =
        state.productos.where((p) => p.uidProducto != uidProducto).toList();
    state = state.copyWith(productos: nuevosProductos);
  }

  void limpiarFicha() {
    state = FichaEnCurso();
  }
}
