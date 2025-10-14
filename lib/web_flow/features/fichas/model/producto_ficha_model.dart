import 'package:valen_market_admin/constants/fieldNames.dart';

class ProductoFichaModel {
  final String uid;
  final String nombre;
  final double precioUnitario;
  final int cantidadDeCuotas;
  final double precioDeLasCuotas;
  final int unidades;

  ProductoFichaModel({
    required this.uid,
    required this.nombre,
    required this.precioUnitario,
    required this.precioDeLasCuotas,
    required this.cantidadDeCuotas,
    required this.unidades,
  });

  factory ProductoFichaModel.fromMap(Map<String, dynamic> data) {
    return ProductoFichaModel(
      uid: data[FIELD_NAME__producto_ficha_model__UID] ?? '',
      nombre: data[FIELD_NAME__producto_ficha_model__Nombre] ?? '',
      precioUnitario:
          data[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0,
      precioDeLasCuotas:
          data[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ?? 0,
      cantidadDeCuotas:
          data[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ?? 0,
      unidades: data[FIELD_NAME__producto_ficha_model__Unidades] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__producto_ficha_model__UID: uid,
      FIELD_NAME__producto_ficha_model__Nombre: nombre,
      FIELD_NAME__producto_ficha_model__Precio_Unitario: precioUnitario,
      FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: precioDeLasCuotas,
      FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas: cantidadDeCuotas,
      FIELD_NAME__producto_ficha_model__Unidades: unidades,
    };
  }

  /// Crea una copia con cambios seleccionados
  ProductoFichaModel copyWith({
    String? uid,
    String? nombre,
    double? precioUnitario,
    int? cantidadDeCuotas,
    double? precioDeLasCuotas,
    int? unidades,
  }) {
    return ProductoFichaModel(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidadDeCuotas: cantidadDeCuotas ?? this.cantidadDeCuotas,
      precioDeLasCuotas: precioDeLasCuotas ?? this.precioDeLasCuotas,
      unidades: unidades ?? this.unidades,
    );
  }
}
