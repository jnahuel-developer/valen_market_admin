import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';

class FechasFichaProvider extends ChangeNotifier {
  Map<String, dynamic> _fechas = {
    FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: null,
    FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: null,
    FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: null,
  };

  // --- 🔹 Función auxiliar: convierte cualquier valor a DateTime? ---
  DateTime? _parseFecha(dynamic valor) {
    if (valor == null) return null;

    // Caso 1: ya es DateTime
    if (valor is DateTime) return valor;

    // Caso 2: es String (ISO o formato Firebase)
    if (valor is String && valor.isNotEmpty) {
      try {
        return DateTime.parse(valor);
      } catch (_) {
        return null;
      }
    }

    // Caso 3: viene como Timestamp (Firebase nativo en web)
    if (valor is Map && valor.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(valor['_seconds'] * 1000);
    }

    return null;
  }

  // --- 🔹 Devuelve una copia del estado actual ---
  Map<String, dynamic> obtenerFechas() {
    return {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion:
          _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion],
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta:
          _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta],
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso:
          _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso],
    };
  }

  // --- 🔹 Reemplaza todas las fechas, convirtiendo valores entrantes ---
  void actualizarFechas(Map<String, dynamic> nuevasFechas) {
    if (nuevasFechas.isEmpty) return;

    final model = FechasFichaModel.fromMap(nuevasFechas);
    final map = model.toMap();

    _fechas = {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: nuevasFechas
              .containsKey(FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion)
          ? _parseFecha(map[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion])
          : _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion],
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: nuevasFechas
              .containsKey(FIELD_NAME__fecha_ficha_model__Fecha_De_Venta)
          ? _parseFecha(map[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta])
          : _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta],
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso:
          nuevasFechas.containsKey(
                  FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso)
              ? _parseFecha(
                  map[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso])
              : _fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso],
    };

    notifyListeners();
  }

  // --- 🔹 Limpia las fechas (todas nulas) ---
  void limpiarFechas() {
    _fechas = {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: null,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: null,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: null,
    };
    notifyListeners();
  }

  // --- 🔹 Devuelve copia independiente del estado actual ---
  Map<String, dynamic> copiarFechas() => Map<String, dynamic>.from(_fechas);
}
