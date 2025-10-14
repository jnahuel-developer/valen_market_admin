import 'package:valen_market_admin/constants/fieldNames.dart';

import 'pago_item_model.dart';

class PagosFichaModel {
  final int cantidadDeCuotas;
  final int cuotasPagas;
  final int restante;
  final bool saldado;
  final int importeSaldado;
  final int importeCuota;
  final int importeTotal;
  final List<PagoItemModel> pagos;

  PagosFichaModel({
    required this.cantidadDeCuotas,
    required this.cuotasPagas,
    required this.restante,
    required this.saldado,
    required this.importeSaldado,
    required this.importeCuota,
    required this.importeTotal,
    required this.pagos,
  });

  factory PagosFichaModel.fromMap(Map<String, dynamic> data) {
    final pagosList = <PagoItemModel>[];
    data.forEach((key, value) {
      if (int.tryParse(key) != null && value is Map<String, dynamic>) {
        pagosList.add(PagoItemModel.fromMap(value));
      }
    });

    return PagosFichaModel(
      cantidadDeCuotas:
          data[FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas] ?? 0,
      cuotasPagas: data[FIELD_NAME__pago_ficha_model__Cuotas_Pagas] ?? 0,
      restante: data[FIELD_NAME__pago_ficha_model__Restante] ?? 0,
      saldado: data[FIELD_NAME__pago_ficha_model__Saldado] ?? false,
      importeSaldado: data[FIELD_NAME__pago_ficha_model__Importe_Saldado] ?? 0,
      importeCuota: data[FIELD_NAME__pago_ficha_model__Importe_Cuota] ?? 0,
      importeTotal: data[FIELD_NAME__pago_ficha_model__Importe_Total] ?? 0,
      pagos: pagosList,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas: cantidadDeCuotas,
      FIELD_NAME__pago_ficha_model__Cuotas_Pagas: cuotasPagas,
      FIELD_NAME__pago_ficha_model__Restante: restante,
      FIELD_NAME__pago_ficha_model__Saldado: saldado,
      FIELD_NAME__pago_ficha_model__Importe_Saldado: importeSaldado,
      FIELD_NAME__pago_ficha_model__Importe_Cuota: importeCuota,
      FIELD_NAME__pago_ficha_model__Importe_Total: importeTotal,
    };

    for (int i = 0; i < pagos.length; i++) {
      map[i.toString()] = pagos[i].toMap();
    }

    return map;
  }
}
