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
  final List<ProductoEnFicha> productos;

  FichaEnCurso({
    this.uidCliente,
    this.productos = const [],
  });

  FichaEnCurso copyWith({
    String? uidCliente,
    List<ProductoEnFicha>? productos,
  }) {
    return FichaEnCurso(
      uidCliente: uidCliente ?? this.uidCliente,
      productos: productos ?? this.productos,
    );
  }

  bool get esValida => uidCliente != null && productos.isNotEmpty;
}
