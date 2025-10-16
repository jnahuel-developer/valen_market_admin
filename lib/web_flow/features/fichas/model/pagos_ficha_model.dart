import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pago_item_model.dart';

class PagosFichaModel {
  final int cantidadDeCuotas;
  final int cuotasPagas;
  final num importeTotal;
  final num importeCuota;
  final num importeSaldado;
  final num restante;
  final bool saldado;
  final List<PagoItemModel> pagosRealizados;

  PagosFichaModel({
    required this.cantidadDeCuotas,
    required this.cuotasPagas,
    required this.importeTotal,
    required this.importeCuota,
    required this.importeSaldado,
    required this.restante,
    required this.saldado,
    required this.pagosRealizados,
  });

  factory PagosFichaModel.fromMap(Map<String, dynamic> data) {
    final pagos = (data[FIELD_NAME__pago_ficha_model__Pagos_Realizados]
                as List<dynamic>?)
            ?.map((p) => PagoItemModel.fromMap(Map<String, dynamic>.from(p)))
            .toList() ??
        [];

    return PagosFichaModel(
      cantidadDeCuotas:
          data[FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas] ?? 0,
      cuotasPagas: data[FIELD_NAME__pago_ficha_model__Cuotas_Pagas] ?? 0,
      importeTotal: data[FIELD_NAME__pago_ficha_model__Importe_Total] ?? 0,
      importeCuota: data[FIELD_NAME__pago_ficha_model__Importe_Cuota] ?? 0,
      importeSaldado: data[FIELD_NAME__pago_ficha_model__Importe_Saldado] ?? 0,
      restante: data[FIELD_NAME__pago_ficha_model__Restante] ?? 0,
      saldado: data[FIELD_NAME__pago_ficha_model__Saldado] ?? false,
      pagosRealizados: pagos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas: cantidadDeCuotas,
      FIELD_NAME__pago_ficha_model__Cuotas_Pagas: cuotasPagas,
      FIELD_NAME__pago_ficha_model__Importe_Total: importeTotal,
      FIELD_NAME__pago_ficha_model__Importe_Cuota: importeCuota,
      FIELD_NAME__pago_ficha_model__Importe_Saldado: importeSaldado,
      FIELD_NAME__pago_ficha_model__Restante: restante,
      FIELD_NAME__pago_ficha_model__Saldado: saldado,
      FIELD_NAME__pago_ficha_model__Pagos_Realizados:
          pagosRealizados.map((p) => p.toMap()).toList(),
    };
  }

  static PagosFichaModel pagosVacios() => PagosFichaModel(
        cantidadDeCuotas: 0,
        cuotasPagas: 0,
        importeTotal: 0,
        importeCuota: 0,
        importeSaldado: 0,
        restante: 0,
        saldado: false,
        pagosRealizados: [],
      );
}
