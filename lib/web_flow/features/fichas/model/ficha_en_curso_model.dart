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
  final String? id; // Nuevo: ID de la ficha
  final String? uidCliente;
  final String? nombreCliente;
  final String? apellidoCliente;
  final String? zonaCliente;
  final String? direccionCliente;
  final String? telefonoCliente;
  final List<ProductoEnFicha> productos;

  FichaEnCurso({
    this.id,
    this.uidCliente,
    this.nombreCliente,
    this.apellidoCliente,
    this.zonaCliente,
    this.direccionCliente,
    this.telefonoCliente,
    this.productos = const [],
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
      ..._productosToMap(),
    };
  }

  Map<String, dynamic> _productosToMap() {
    final Map<String, dynamic> productosMap = {};

    for (int i = 0; i < productos.length; i++) {
      final producto = productos[i];
      productosMap.addAll({
        'UID_Producto_$i': producto.uidProducto,
        'Unidades_Producto_$i': producto.unidades,
        'Precio_Producto_$i': producto.precioUnitario,
        'Cantidad_de_cuotas_Producto_$i': producto.cantidadDeCuotas,
        'Precio_de_las_cuotas_Producto_$i': producto.precioDeLasCuotas,
        'Saldado_Producto_$i': producto.saldado,
        'Restante_Producto_$i': producto.restante,
      });
    }

    return productosMap;
  }

  /// -------------------------
  /// NUEVO: para debug del cliente
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
  Productos: ${productos.length}
''';
  }
}
