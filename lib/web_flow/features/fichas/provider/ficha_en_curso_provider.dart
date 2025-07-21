import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/model/ficha_en_curso_model.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

final fichaEnCursoProvider =
    StateNotifierProvider<FichaEnCursoNotifier, FichaEnCurso>(
  (ref) => FichaEnCursoNotifier(),
);

class FichaEnCursoNotifier extends StateNotifier<FichaEnCurso> {
  FichaEnCursoNotifier() : super(FichaEnCurso());

  Future<void> seleccionarClientePorUID(String uidCliente) async {
    try {
      final cliente =
          await ClientesServiciosFirebase.obtenerClientePorId(uidCliente);

      if (cliente == null) {
        return;
      }

      state = state.copyWith(
        uidCliente: uidCliente,
        nombreCliente: cliente['Nombre'] ?? '',
        apellidoCliente: cliente['Apellido'] ?? '',
        zonaCliente: cliente['Zona'] ?? '',
        direccionCliente: cliente['Dirección'] ?? '',
        telefonoCliente: cliente['Teléfono'] ?? '',
      );
    } catch (e) {}
  }

  void agregarProducto(ProductoEnFicha producto) {
    final indexExistente = state.productos
        .indexWhere((p) => p.uidProducto == producto.uidProducto);

    if (indexExistente != -1) {
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

      state = state.copyWith(productos: productosActualizados);
    } else {
      final productoConRestante = ProductoEnFicha(
        uidProducto: producto.uidProducto,
        unidades: producto.unidades,
        precioUnitario: producto.precioUnitario,
        cantidadDeCuotas: producto.cantidadDeCuotas,
        precioDeLasCuotas: producto.precioDeLasCuotas,
        saldado: false,
        restante: producto.unidades * producto.precioDeLasCuotas,
      );

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

  void cargarFichaDesdeMapa(Map<String, dynamic> ficha,
      {required String fichaId}) {
    final uidCliente = ficha['UID_Cliente'] as String?;
    final nombreCliente = ficha['Nombre'] as String?;
    final apellidoCliente = ficha['Apellido'] as String?;
    final zonaCliente = ficha['Zona'] as String?;
    final direccionCliente = ficha['Dirección'] as String?;
    final telefonoCliente = ficha['Teléfono'] as String?;

    final int cantidadProductos = ficha['Cantidad_de_Productos'] ?? 0;
    List<ProductoEnFicha> productos = [];

    for (int i = 0; i < cantidadProductos; i++) {
      productos.add(
        ProductoEnFicha(
          uidProducto: ficha['UID_Producto_$i'] ?? '',
          unidades: ficha['Unidades_Producto_$i'] ?? 0,
          precioUnitario: (ficha['Precio_Producto_$i'] ?? 0).toDouble(),
          cantidadDeCuotas: ficha['Cantidad_de_cuotas_Producto_$i'] ?? 0,
          precioDeLasCuotas:
              (ficha['Precio_de_las_cuotas_Producto_$i'] ?? 0).toDouble(),
          saldado: ficha['Saldado_Producto_$i'] ?? false,
          restante: (ficha['Restante_Producto_$i'] ?? 0).toDouble(),
        ),
      );
    }

    state = FichaEnCurso(
      id: fichaId,
      uidCliente: uidCliente,
      nombreCliente: nombreCliente,
      apellidoCliente: apellidoCliente,
      zonaCliente: zonaCliente,
      direccionCliente: direccionCliente,
      telefonoCliente: telefonoCliente,
      productos: productos,
    );
  }

  void actualizarDatosCliente({
    required String uidCliente,
    required String nombre,
    required String apellido,
    required String zona,
    required String direccion,
    required String telefono,
  }) {
    state = state.copyWith(
      uidCliente: uidCliente,
      nombreCliente: nombre,
      apellidoCliente: apellido,
      zonaCliente: zona,
      direccionCliente: direccion,
      telefonoCliente: telefono,
    );
  }
}
