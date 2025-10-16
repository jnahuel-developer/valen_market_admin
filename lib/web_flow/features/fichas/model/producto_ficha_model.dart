import 'package:valen_market_admin/constants/fieldNames.dart';

class ProductoFichaModel {
  final String uid;
  final String nombre;
  final num precioUnitario;
  final num precioDeLasCuotas;
  final int unidades;

  ProductoFichaModel({
    required this.uid,
    required this.nombre,
    required this.precioUnitario,
    required this.precioDeLasCuotas,
    required this.unidades,
  });

  factory ProductoFichaModel.fromMap(Map<String, dynamic> data) {
    return ProductoFichaModel(
      uid: (data[FIELD_NAME__producto_ficha_model__UID] ?? '').toString(),
      nombre: (data[FIELD_NAME__producto_ficha_model__Nombre] ?? '').toString(),
      precioUnitario:
          (data[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0),
      precioDeLasCuotas:
          (data[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ?? 0),
      unidades: int.tryParse(
              '${data[FIELD_NAME__producto_ficha_model__Unidades] ?? 0}') ??
          0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__producto_ficha_model__UID: uid,
      FIELD_NAME__producto_ficha_model__Nombre: nombre,
      FIELD_NAME__producto_ficha_model__Precio_Unitario: precioUnitario,
      FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: precioDeLasCuotas,
      FIELD_NAME__producto_ficha_model__Unidades: unidades,
    };
  }

  static ProductoFichaModel productoVacio() => ProductoFichaModel(
        uid: '',
        nombre: '',
        precioUnitario: 0,
        precioDeLasCuotas: 0,
        unidades: 0,
      );

  ProductoFichaModel copyWith(Map<String, dynamic> cambios) {
    return ProductoFichaModel(
      uid: cambios[FIELD_NAME__producto_ficha_model__UID] ?? uid,
      nombre: cambios[FIELD_NAME__producto_ficha_model__Nombre] ?? nombre,
      precioUnitario:
          cambios[FIELD_NAME__producto_ficha_model__Precio_Unitario] ??
              precioUnitario,
      precioDeLasCuotas:
          cambios[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ??
              precioDeLasCuotas,
      unidades: cambios[FIELD_NAME__producto_ficha_model__Unidades] ?? unidades,
    );
  }
}
