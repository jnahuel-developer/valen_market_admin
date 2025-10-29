import 'package:valen_market_admin/constants/fieldNames.dart';

class ProductoFichaModel {
  final String id;
  final String nombre;
  final num precioUnitario;
  final num precioDeLasCuotas;
  final int unidades;
  final int cantidadDeCuotas;

  ProductoFichaModel({
    required this.id,
    required this.nombre,
    required this.precioUnitario,
    required this.precioDeLasCuotas,
    required this.unidades,
    required this.cantidadDeCuotas,
  });

  factory ProductoFichaModel.fromMap(Map<String, dynamic> data) {
    return ProductoFichaModel(
      id: (data[FIELD_NAME__producto_ficha_model__ID] ?? '').toString(),
      nombre: (data[FIELD_NAME__producto_ficha_model__Nombre] ?? '').toString(),
      precioUnitario:
          (data[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0),
      precioDeLasCuotas:
          (data[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ?? 0),
      unidades: int.tryParse(
              '${data[FIELD_NAME__producto_ficha_model__Unidades] ?? 0}') ??
          0,
      cantidadDeCuotas:
          (data[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__producto_ficha_model__ID: id,
      FIELD_NAME__producto_ficha_model__Nombre: nombre,
      FIELD_NAME__producto_ficha_model__Precio_Unitario: precioUnitario,
      FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: precioDeLasCuotas,
      FIELD_NAME__producto_ficha_model__Unidades: unidades,
      FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas: cantidadDeCuotas,
    };
  }

  static ProductoFichaModel productoVacio() => ProductoFichaModel(
        id: '',
        nombre: '',
        precioUnitario: 0,
        precioDeLasCuotas: 0,
        unidades: 0,
        cantidadDeCuotas: 0,
      );

  ProductoFichaModel copyWith(Map<String, dynamic> cambios) {
    return ProductoFichaModel(
      id: cambios[FIELD_NAME__producto_ficha_model__ID] ?? id,
      nombre: cambios[FIELD_NAME__producto_ficha_model__Nombre] ?? nombre,
      precioUnitario:
          cambios[FIELD_NAME__producto_ficha_model__Precio_Unitario] ??
              precioUnitario,
      precioDeLasCuotas:
          cambios[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ??
              precioDeLasCuotas,
      unidades: cambios[FIELD_NAME__producto_ficha_model__Unidades] ?? unidades,
      cantidadDeCuotas:
          cambios[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ??
              cantidadDeCuotas,
    );
  }
}
