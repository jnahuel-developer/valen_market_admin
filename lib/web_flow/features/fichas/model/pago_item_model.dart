import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';

class PagoItemModel {
  final DateTime fecha;
  final String medio;
  final int monto;

  PagoItemModel({
    required this.fecha,
    required this.medio,
    required this.monto,
  });

  factory PagoItemModel.fromMap(Map<String, dynamic> data) {
    return PagoItemModel(
      fecha:
          (data[FIELD_NAME__pago_item_model__Fecha] as Timestamp?)?.toDate() ??
              DateTime.now(),
      medio: data[FIELD_NAME__pago_item_model__Medio] ?? '',
      monto: data[FIELD_NAME__pago_item_model__Monto] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__pago_item_model__Fecha: fecha,
      FIELD_NAME__pago_item_model__Medio: medio,
      FIELD_NAME__pago_item_model__Monto: monto,
    };
  }
}
