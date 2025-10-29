import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';

class FechasFichaProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------- */
  /* Estructura interna en formato Map                                    */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> _fechas = {
    FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: null,
    FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: null,
    FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: null,
  };

  /* -------------------------------------------------------------------- */
  /* Function: obtenerFechas                                              */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: Map                                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Generate a map of the data loaded in memory             */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> obtenerFechas() => Map<String, dynamic>.from(_fechas);

  /* -------------------------------------------------------------------- */
  /* Function: actualizarFechas                                           */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Only replace the data that has been provided in the Map */
  /* -------------------------------------------------------------------- */
  void actualizarFechas(Map<String, dynamic> nuevasFechas) {
    // Se verifica que no se haya sumistrado un Map vacío
    if (nuevasFechas.isEmpty) return;

    // Se contruye un modelo con los datos suministrados
    final model = FechasFichaModel.fromMap(nuevasFechas);

    // Se obtiene un modelo de fechas en base a los datos suministrados
    final map = model.toMap();

    // Se actualizan sólo los campos proporcionados. Los demás se mantienen
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

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: limpiarFechas                                              */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Delete the Map loaded in memory                         */
  /* -------------------------------------------------------------------- */
  void limpiarFechas() {
    // Se borra el Map en memoria
    _fechas = {
      FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: null,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: null,
      FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: null,
    };

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: _parseFecha                                                */
  /* -------------------------------------------------------------------- */
  /* Input: A date in any type of format                                  */
  /* Output: The date in DateTime format, or null if it didn't have a     */
  /*  supported format                                                    */
  /* -------------------------------------------------------------------- */
  /* Description: Convert the received date to DateTime format.           */
  /*  It supports DateTime, String, or Timestamp format                   */
  /* -------------------------------------------------------------------- */
  DateTime? _parseFecha(dynamic valor) {
    // Se verifica que no se haya suministrado un dato nulo
    if (valor == null) return null;

    // Si el formato del dato ya es DateTime, simplemente se lo retorna
    if (valor is DateTime) return valor;

    // Si es un String no nulo, se lo convierte (puede venir así desde Firebase)
    if (valor is String && valor.isNotEmpty) {
      try {
        // Se retorna el valor convertido a DateTime desde un String
        return DateTime.parse(valor);
      } catch (_) {
        return null;
      }
    }

    // Si es un Timestamp no nulo, se lo convierte (puede venir así desde Firebase Web Nativo)
    if (valor is Map && valor.containsKey('_seconds')) {
      // Se retorna el valor convertido a DateTime desde un Timestamp
      return DateTime.fromMillisecondsSinceEpoch(valor['_seconds'] * 1000);
    }

    // En cualquier otro caso, simplemente se retorna un dato nulo por ser un formato no admitido
    return null;
  }
}
