/// ---------------------------------------------------------------------------
/// FECHAS_FICHA_PROVIDER
///
/// 🔹 Rol general:
/// Administra y normaliza las fechas asociadas a la ficha (creación, venta,
/// y próximo aviso). Encapsula un modelo [FechasFichaModel].
///
/// 🔹 Forma de uso:
///   - Se utiliza exclusivamente dentro de [FichaEnCursoProvider].
///   - No debe ser accedido directamente por los Widgets.
///
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]: mediante los métodos `actualizarFechas()` y `cargarDesdeMap()`.
///   - [FechasFichaModel]: modelo que define las tres fechas.
///
/// 🔹 Lógica principal:
///   - Permite asignar un nuevo modelo de fechas mediante `setFechas()`.
///   - Permite reiniciar el estado mediante `limpiarFechas()`.
///
/// 🔹 Métodos disponibles:
///   • `FechasFichaModel get fechas` → Obtiene las fechas actuales.
///   • `void setFechas(FechasFichaModel fechas)` → Reemplaza el modelo completo.
///   • `void limpiarFechas()` → Reinicia las fechas (mantiene la de creación actual).
///
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';

class FechasFichaProvider extends ChangeNotifier {
  Map<String, dynamic> _fechas = {
    FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '',
    FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '',
    FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '',
  };

  // Devuelve una copia del estado actual
  Map<String, dynamic> obtenerFechas() => Map<String, dynamic>.from(_fechas);

  // Reemplaza todas las fechas
  void actualizarFechas(Map<String, dynamic> nuevasFechas) {
    final model = FechasFichaModel.fromMap(nuevasFechas);
    _fechas = model.toMap();
    notifyListeners();
  }

  // Limpia las fechas (todas vacías)
  void limpiarFechas() {
    _fechas = {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '',
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '',
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '',
    };
    notifyListeners();
  }

  // Devuelve una copia independiente del estado actual
  Map<String, dynamic> copiarFechas() => Map<String, dynamic>.from(_fechas);
}
