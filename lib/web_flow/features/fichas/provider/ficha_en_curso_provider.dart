import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_en_curso_model.dart';
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

      if (cliente == null) return;

      state = state.copyWith(
        uidCliente: uidCliente,
        nombreCliente: cliente['Nombre'] ?? '',
        apellidoCliente: cliente['Apellido'] ?? '',
        zonaCliente: cliente['Zona'] ?? '',
        direccionCliente: cliente['Dirección'] ?? '',
        telefonoCliente: cliente['Teléfono'] ?? '',
      );
    } catch (_) {}
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

  void actualizarFechaDeVenta(DateTime? fecha) {
    state = state.copyWith(fechaDeVenta: fecha);
    debugPrint('Fecha de venta actualizada: ${fecha?.toIso8601String()}');
  }

  void actualizarFrecuenciaDeAviso(String frecuencia) {
    state = state.copyWith(frecuenciaDeAviso: frecuencia);
    debugPrint('Frecuencia de aviso actualizada: $frecuencia');
  }

  void actualizarProximoAviso(DateTime fecha) {
    state = state.copyWith(proximoAviso: fecha);
    debugPrint('Próximo aviso actualizado: ${fecha.toIso8601String()}');
  }

  void cargarFichaDesdeMapa(Map<String, dynamic> ficha,
      {required String fichaId}) {
    final uidCliente = ficha['UID_Cliente'] as String?;
    final nombreCliente = ficha['Nombre'] as String?;
    final apellidoCliente = ficha['Apellido'] as String?;
    final zonaCliente = ficha['Zona'] as String?;
    final direccionCliente = ficha['Dirección'] as String?;
    final telefonoCliente = ficha['Teléfono'] as String?;

    DateTime? fechaDeVenta;
    DateTime? fechaDeAviso;

    // Se maneja de forma flexible el tipo de dato recibido para evitar errores
    final dynamic fechaVentaRaw = ficha['Fecha_de_venta'];
    final dynamic proximoAvisoRaw = ficha['Proximo_aviso'];

    if (fechaVentaRaw != null) {
      if (fechaVentaRaw is String) {
        try {
          fechaDeVenta = DateTime.parse(fechaVentaRaw);
        } catch (_) {}
      } else if (fechaVentaRaw is DateTime) {
        fechaDeVenta = fechaVentaRaw;
      } else if (fechaVentaRaw is Timestamp) {
        fechaDeVenta = fechaVentaRaw.toDate();
      }
    }

    if (proximoAvisoRaw != null) {
      if (proximoAvisoRaw is String) {
        try {
          fechaDeAviso = DateTime.parse(proximoAvisoRaw);
        } catch (_) {}
      } else if (proximoAvisoRaw is DateTime) {
        fechaDeAviso = proximoAvisoRaw;
      } else if (proximoAvisoRaw is Timestamp) {
        fechaDeAviso = proximoAvisoRaw.toDate();
      }
    }

    final int cantidadProductos = ficha['Cantidad_de_Productos'] ?? 0;
    final List<ProductoEnFicha> productos = [];

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
      fechaDeVenta: fechaDeVenta,
      frecuenciaDeAviso: ficha['Frecuencia_de_aviso'] as String?,
      proximoAviso: fechaDeAviso,
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

  void cargarSoloDatosDeFichaYProductos(Map<String, dynamic> ficha,
      {required String fichaId}) {
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

    final dynamic fechaVentaRaw = ficha['Fecha_de_venta'];
    DateTime? fechaDeVenta;

    if (fechaVentaRaw != null) {
      if (fechaVentaRaw is String) {
        try {
          fechaDeVenta = DateTime.parse(fechaVentaRaw);
        } catch (_) {}
      } else if (fechaVentaRaw is DateTime) {
        fechaDeVenta = fechaVentaRaw;
      } else if (fechaVentaRaw is Timestamp) {
        fechaDeVenta = fechaVentaRaw.toDate();
      }
    }

    final dynamic fechaAvisoRaw = ficha['Proximo_aviso'];
    DateTime? fechaDeAviso;

    if (fechaAvisoRaw != null) {
      if (fechaAvisoRaw is String) {
        try {
          fechaDeAviso = DateTime.parse(fechaAvisoRaw);
        } catch (_) {}
      } else if (fechaAvisoRaw is DateTime) {
        fechaDeAviso = fechaAvisoRaw;
      } else if (fechaAvisoRaw is Timestamp) {
        fechaDeAviso = fechaAvisoRaw.toDate();
      }
    }

    state = state.copyWith(
      id: fichaId,
      productos: productos,
      fechaDeVenta: fechaDeVenta,
      proximoAviso: fechaDeAviso,
    );
  }
}
