import 'package:valen_market_admin/constants/fieldNames.dart';

class PagoItemModel {
  final DateTime fecha;
  final String medio;
  final num monto;

  PagoItemModel({
    required this.fecha,
    required this.medio,
    required this.monto,
  });

  factory PagoItemModel.fromMap(Map<String, dynamic> data) {
    final rawFecha = data[FIELD_NAME__pago_item_model__Fecha];
    DateTime parsedFecha;

    if (rawFecha is DateTime) {
      parsedFecha = DateTime(rawFecha.year, rawFecha.month, rawFecha.day);
    } else if (rawFecha is String && rawFecha.isNotEmpty) {
      parsedFecha = DateTime.parse(rawFecha);
    } else {
      parsedFecha = DateTime.now();
    }

    // Normalizamos la fecha a medianoche
    parsedFecha =
        DateTime(parsedFecha.year, parsedFecha.month, parsedFecha.day);

    return PagoItemModel(
      fecha: parsedFecha,
      medio: data[FIELD_NAME__pago_item_model__Medio] ?? '',
      monto: data[FIELD_NAME__pago_item_model__Monto] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__pago_item_model__Fecha: fecha.toIso8601String(),
      FIELD_NAME__pago_item_model__Medio: medio,
      FIELD_NAME__pago_item_model__Monto: monto,
    };
  }

  static PagoItemModel pagoVacio() => PagoItemModel(
        fecha: DateTime.now(),
        medio: '',
        monto: 0,
      );
}
