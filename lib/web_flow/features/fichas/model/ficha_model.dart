import 'package:valen_market_admin/constants/fieldNames.dart';
import 'cliente_ficha_model.dart';
import 'fechas_ficha_model.dart';
import 'producto_ficha_model.dart';
import 'pagos_ficha_model.dart';

class FichaModel {
  final String? id;
  final int numeroDeFicha;
  final int cantidadDeProductos;
  final ClienteFichaModel cliente;
  final FechasFichaModel fechas;
  final PagosFichaModel pagos;
  final List<ProductoFichaModel> productos;

  FichaModel({
    this.id,
    required this.numeroDeFicha,
    required this.cantidadDeProductos,
    required this.cliente,
    required this.fechas,
    required this.pagos,
    required this.productos,
  });

  factory FichaModel.fromMap(Map<String, dynamic> data) {
    final productosList = <ProductoFichaModel>[];
    if (data[FIELD_NAME__ficha_model__Productos] != null) {
      (data[FIELD_NAME__ficha_model__Productos] as Map).forEach((key, value) {
        if (int.tryParse(key) != null && value is Map<String, dynamic>) {
          productosList.add(ProductoFichaModel.fromMap(value));
        }
      });
    }

    return FichaModel(
      id: data[FIELD_NAME__ficha_model__ID_De_Ficha],
      numeroDeFicha: data[FIELD_NAME__ficha_model__Numero_De_Ficha] ?? 0,
      cantidadDeProductos:
          data[FIELD_NAME__ficha_model__Cantidad_De_Productos] ?? 0,
      cliente: ClienteFichaModel.fromMap(
          data[FIELD_NAME__ficha_model__Cliente] ?? {}),
      fechas:
          FechasFichaModel.fromMap(data[FIELD_NAME__ficha_model__Fechas] ?? {}),
      pagos:
          PagosFichaModel.fromMap(data[FIELD_NAME__ficha_model__Pagos] ?? {}),
      productos: productosList,
    );
  }

  Map<String, dynamic> toMap() {
    final productosMap = <String, dynamic>{};
    for (int i = 0; i < productos.length; i++) {
      productosMap[i.toString()] = productos[i].toMap();
    }

    return {
      FIELD_NAME__ficha_model__ID_De_Ficha: id,
      FIELD_NAME__ficha_model__Numero_De_Ficha: numeroDeFicha,
      FIELD_NAME__ficha_model__Cantidad_De_Productos: cantidadDeProductos,
      FIELD_NAME__ficha_model__Cliente: cliente.toMap(),
      FIELD_NAME__ficha_model__Fechas: fechas.toMap(),
      FIELD_NAME__ficha_model__Pagos: pagos.toMap(),
      FIELD_NAME__ficha_model__Productos: productosMap,
    };
  }
}
