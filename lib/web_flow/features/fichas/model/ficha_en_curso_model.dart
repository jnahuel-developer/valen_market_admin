class ProductoEnFicha {
  final String uidProducto;
  final int unidades;
  final double precioUnitario;
  final int cantidadDeCuotas;
  final double precioDeLasCuotas;
  final bool saldado;
  final double restante;

  ProductoEnFicha({
    required this.uidProducto,
    required this.unidades,
    required this.precioUnitario,
    required this.cantidadDeCuotas,
    required this.precioDeLasCuotas,
    required this.saldado,
    required this.restante,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidProducto': uidProducto,
      'unidades': unidades,
      'precioUnitario': precioUnitario,
      'cantidadDeCuotas': cantidadDeCuotas,
      'precioDeLasCuotas': precioDeLasCuotas,
      'saldado': saldado,
      'restante': restante,
    };
  }
}

class FichaEnCurso {
  final String? uidCliente;
  final String? nombreCliente;
  final String? apellidoCliente;
  final String? zonaCliente;
  final String? direccionCliente;
  final String? telefonoCliente;
  final List<ProductoEnFicha> productos;

  FichaEnCurso({
    this.uidCliente,
    this.nombreCliente,
    this.apellidoCliente,
    this.zonaCliente,
    this.direccionCliente,
    this.telefonoCliente,
    this.productos = const [],
  });

  FichaEnCurso copyWith({
    String? uidCliente,
    String? nombreCliente,
    String? apellidoCliente,
    String? zonaCliente,
    String? direccionCliente,
    String? telefonoCliente,
    List<ProductoEnFicha>? productos,
  }) {
    return FichaEnCurso(
      uidCliente: uidCliente ?? this.uidCliente,
      nombreCliente: nombreCliente ?? this.nombreCliente,
      apellidoCliente: apellidoCliente ?? this.apellidoCliente,
      zonaCliente: zonaCliente ?? this.zonaCliente,
      direccionCliente: direccionCliente ?? this.direccionCliente,
      telefonoCliente: telefonoCliente ?? this.telefonoCliente,
      productos: productos ?? this.productos,
    );
  }

  bool get esValida => uidCliente != null && productos.isNotEmpty;
}
