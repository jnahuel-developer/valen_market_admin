import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoEnFicha {
  final String uidProducto;
  final String nombreProducto;
  final int unidades;
  final double precioUnitario;
  final int cantidadDeCuotas;
  final double precioDeLasCuotas;
  final bool saldado;
  final double restante;
  final int cuotasPagas;
  final double totalSaldado;

  ProductoEnFicha({
    required this.uidProducto,
    required this.nombreProducto,
    required this.unidades,
    required this.precioUnitario,
    required this.cantidadDeCuotas,
    required this.precioDeLasCuotas,
    required this.saldado,
    required this.restante,
    this.cuotasPagas = 0,
    this.totalSaldado = 0.0,
  });

  ProductoEnFicha copyWith({
    String? uidProducto,
    String? nombreProducto,
    int? unidades,
    double? precioUnitario,
    int? cantidadDeCuotas,
    double? precioDeLasCuotas,
    bool? saldado,
    double? restante,
    int? cuotasPagas,
    double? totalSaldado,
  }) {
    return ProductoEnFicha(
      uidProducto: uidProducto ?? this.uidProducto,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      unidades: unidades ?? this.unidades,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidadDeCuotas: cantidadDeCuotas ?? this.cantidadDeCuotas,
      precioDeLasCuotas: precioDeLasCuotas ?? this.precioDeLasCuotas,
      saldado: saldado ?? this.saldado,
      restante: restante ?? this.restante,
      cuotasPagas: cuotasPagas ?? this.cuotasPagas,
      totalSaldado: totalSaldado ?? this.totalSaldado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uidProducto': uidProducto,
      'nombreProducto': nombreProducto,
      'unidades': unidades,
      'precioUnitario': precioUnitario,
      'cantidadDeCuotas': cantidadDeCuotas,
      'precioDeLasCuotas': precioDeLasCuotas,
      'saldado': saldado,
      'restante': restante,
      'cuotasPagas': cuotasPagas,
      'totalSaldado': totalSaldado,
    };
  }
}

class FichaEnCurso {
  final String? id;
  final String? uidCliente;
  final String? nombreCliente;
  final String? apellidoCliente;
  final String? zonaCliente;
  final String? direccionCliente;
  final String? telefonoCliente;
  final List<ProductoEnFicha> productos;
  final DateTime? fechaDeVenta;
  final String? frecuenciaDeAviso;
  final DateTime? proximoAviso;
  final double totalFicha;
  final double totalSaldadoFicha;
  final int cuotasRestantesFicha;

  FichaEnCurso({
    this.id,
    this.uidCliente,
    this.nombreCliente,
    this.apellidoCliente,
    this.zonaCliente,
    this.direccionCliente,
    this.telefonoCliente,
    this.productos = const [],
    this.fechaDeVenta,
    this.frecuenciaDeAviso,
    this.proximoAviso,
    this.totalFicha = 0.0,
    this.totalSaldadoFicha = 0.0,
    this.cuotasRestantesFicha = 0,
  });

  FichaEnCurso copyWith({
    String? id,
    String? uidCliente,
    String? nombreCliente,
    String? apellidoCliente,
    String? zonaCliente,
    String? direccionCliente,
    String? telefonoCliente,
    List<ProductoEnFicha>? productos,
    DateTime? fechaDeVenta,
    String? frecuenciaDeAviso,
    DateTime? proximoAviso,
    double? totalFicha,
    double? totalSaldadoFicha,
    int? cuotasRestantesFicha,
  }) {
    return FichaEnCurso(
      id: id ?? this.id,
      uidCliente: uidCliente ?? this.uidCliente,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      apellidoCliente: apellidoCliente ?? this.apellidoCliente,
      zonaCliente: zonaCliente ?? this.zonaCliente,
      direccionCliente: direccionCliente ?? this.direccionCliente,
      telefonoCliente: telefonoCliente ?? this.telefonoCliente,
      productos: productos ?? this.productos,
      fechaDeVenta: fechaDeVenta ?? this.fechaDeVenta,
      frecuenciaDeAviso: frecuenciaDeAviso ?? this.frecuenciaDeAviso,
      proximoAviso: proximoAviso ?? this.proximoAviso,
      totalFicha: totalFicha ?? this.totalFicha,
      totalSaldadoFicha: totalSaldadoFicha ?? this.totalSaldadoFicha,
      cuotasRestantesFicha: cuotasRestantesFicha ?? this.cuotasRestantesFicha,
    );
  }

  bool get esValida => uidCliente != null && productos.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {
      'UID_Cliente': uidCliente,
      'Nombre': nombreCliente,
      'Apellido': apellidoCliente,
      'Zona': zonaCliente,
      'Dirección': direccionCliente,
      'Teléfono': telefonoCliente,
      'Cantidad_de_Productos': productos.length,
      'Total_Ficha': totalFicha,
      'Total_Saldado_Ficha': totalSaldadoFicha,
      'Cuotas_Restantes_Ficha': cuotasRestantesFicha,
      if (fechaDeVenta != null)
        'FechaDeVenta': Timestamp.fromDate(fechaDeVenta!),
      'Frecuencia_de_aviso': frecuenciaDeAviso,
      if (proximoAviso != null)
        'ProximoAviso': Timestamp.fromDate(proximoAviso!),
      ..._productosToMap(),
    };
  }

  Map<String, dynamic> _productosToMap() {
    final Map<String, dynamic> productosMap = {};
    for (int i = 0; i < productos.length; i++) {
      final producto = productos[i];
      productosMap.addAll({
        'UID_Producto_$i': producto.uidProducto,
        'nombreProducto_$i': producto.nombreProducto,
        'Unidades_Producto_$i': producto.unidades,
        'Precio_Producto_$i': producto.precioUnitario,
        'Cantidad_de_cuotas_Producto_$i': producto.cantidadDeCuotas,
        'Precio_de_las_cuotas_Producto_$i': producto.precioDeLasCuotas,
        'Saldado_Producto_$i': producto.saldado,
        'Restante_Producto_$i': producto.restante,
        'Cuotas_Pagas_Producto_$i': producto.cuotasPagas,
        'Total_Saldado_Producto_$i': producto.totalSaldado,
      });
    }
    return productosMap;
  }

  @override
  String toString() {
    return '''
FichaEnCurso:
  UID Cliente: $uidCliente
  Nombre: $nombreCliente
  Apellido: $apellidoCliente
  Zona: $zonaCliente
  Dirección: $direccionCliente
  Teléfono: $telefonoCliente
  Fecha de venta: ${fechaDeVenta ?? 'No definida'}
  Frecuencia de aviso: $frecuenciaDeAviso
  Próximo aviso: ${proximoAviso ?? 'No definido'}
  Productos: ${productos.length}
  Total ficha: $totalFicha
  Total saldado ficha: $totalSaldadoFicha
  Cuotas restantes: $cuotasRestantesFicha
''';
  }
}
