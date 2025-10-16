import 'package:valen_market_admin/constants/fieldNames.dart';

class FechasFichaModel {
  final String fechaDeCreacion;
  final String fechaDeVenta;
  final String fechaDeProximoAviso;

  FechasFichaModel({
    required this.fechaDeCreacion,
    required this.fechaDeVenta,
    required this.fechaDeProximoAviso,
  });

  // Normaliza un objeto (DateTime, String o Timestamp) al formato YYYY-MM-DD
  static String _normalizarFecha(dynamic valor) {
    if (valor == null || valor == '') return '';
    if (valor is DateTime) {
      final normalizada = DateTime(valor.year, valor.month, valor.day);
      return normalizada.toIso8601String().split('T').first;
    }
    if (valor is String) {
      try {
        final dt = DateTime.parse(valor);
        final normalizada = DateTime(dt.year, dt.month, dt.day);
        return normalizada.toIso8601String().split('T').first;
      } catch (_) {
        return '';
      }
    }
    // Caso especial: si llega como Timestamp de Firebase
    if (valor is Map && valor.containsKey('_seconds')) {
      final ts = DateTime.fromMillisecondsSinceEpoch(valor['_seconds'] * 1000);
      return DateTime(ts.year, ts.month, ts.day)
          .toIso8601String()
          .split('T')
          .first;
    }
    return '';
  }

  factory FechasFichaModel.fromMap(Map<String, dynamic> data) {
    return FechasFichaModel(
      fechaDeCreacion: _normalizarFecha(
          data[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion]),
      fechaDeVenta:
          _normalizarFecha(data[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta]),
      fechaDeProximoAviso: _normalizarFecha(
          data[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: fechaDeCreacion,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: fechaDeVenta,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso:
          fechaDeProximoAviso,
    };
  }

  FechasFichaModel copyWith(Map<String, dynamic> data) {
    return FechasFichaModel(
      fechaDeCreacion: data[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion] ??
          fechaDeCreacion,
      fechaDeVenta:
          data[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta] ?? fechaDeVenta,
      fechaDeProximoAviso:
          data[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso] ??
              fechaDeProximoAviso,
    );
  }

  static FechasFichaModel fechasVacias() => FechasFichaModel(
        fechaDeCreacion: '',
        fechaDeVenta: '',
        fechaDeProximoAviso: '',
      );
}
