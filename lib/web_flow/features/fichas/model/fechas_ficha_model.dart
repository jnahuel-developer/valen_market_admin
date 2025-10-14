import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';

class FechasFichaModel {
  final DateTime fechaDeCreacion;
  final DateTime? venta;
  final DateTime? proximoAviso;

  FechasFichaModel({
    required this.fechaDeCreacion,
    this.venta,
    this.proximoAviso,
  });

  factory FechasFichaModel.fromMap(Map<String, dynamic> data) {
    return FechasFichaModel(
      fechaDeCreacion:
          (data[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
      venta:
          (data[FIELD_NAME__fecha_ficha_model__Venta] as Timestamp?)?.toDate(),
      proximoAviso:
          (data[FIELD_NAME__fecha_ficha_model__Proximo_Aviso] as Timestamp?)
              ?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: fechaDeCreacion,
      if (venta != null) FIELD_NAME__fecha_ficha_model__Venta: venta,
      if (proximoAviso != null)
        FIELD_NAME__fecha_ficha_model__Proximo_Aviso: proximoAviso,
    };
  }
}
