import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/cliente_ficha_model.dart';

class ClienteFichaProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------- */
  /* Estructura interna en formato Map                                    */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> _cliente = {
    FIELD_NAME__cliente_ficha_model__ID: '',
    FIELD_NAME__cliente_ficha_model__Nombre: '',
    FIELD_NAME__cliente_ficha_model__Apellido: '',
    FIELD_NAME__cliente_ficha_model__Zona: '',
    FIELD_NAME__cliente_ficha_model__Direccion: '',
    FIELD_NAME__cliente_ficha_model__Telefono: '',
  };

  /* -------------------------------------------------------------------- */
  /* Function: obtenerCliente                                             */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: Map                                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Generate a map of the data loaded in memory             */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> obtenerCliente() => Map<String, dynamic>.from(_cliente);

  /* -------------------------------------------------------------------- */
  /* Function: actualizarCliente                                          */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Only replace the data that has been provided in the Map */
  /* -------------------------------------------------------------------- */
  void actualizarCliente(Map<String, dynamic> nuevoCliente) {
    // Se verifica que no se haya sumistrado un Map vacío
    if (nuevoCliente.isEmpty) return;

    // Se contruye un modelo con los datos suministrados
    final model = ClienteFichaModel.fromMap(nuevoCliente);

    // Se obtiene un modelo de cliente en base a los datos suministrados
    final cliente = model.toMap();

    // Se actualizan sólo los campos proporcionados. Los demás se mantienen
    _cliente = {
      FIELD_NAME__cliente_ficha_model__ID:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__ID)
              ? cliente[FIELD_NAME__cliente_ficha_model__ID]
              : _cliente[FIELD_NAME__cliente_ficha_model__ID],
      FIELD_NAME__cliente_ficha_model__Nombre:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__Nombre)
              ? cliente[FIELD_NAME__cliente_ficha_model__Nombre]
              : _cliente[FIELD_NAME__cliente_ficha_model__Nombre],
      FIELD_NAME__cliente_ficha_model__Apellido:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__Apellido)
              ? cliente[FIELD_NAME__cliente_ficha_model__Apellido]
              : _cliente[FIELD_NAME__cliente_ficha_model__Apellido],
      FIELD_NAME__cliente_ficha_model__Zona:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__Zona)
              ? cliente[FIELD_NAME__cliente_ficha_model__Zona]
              : _cliente[FIELD_NAME__cliente_ficha_model__Zona],
      FIELD_NAME__cliente_ficha_model__Direccion:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__Direccion)
              ? cliente[FIELD_NAME__cliente_ficha_model__Direccion]
              : _cliente[FIELD_NAME__cliente_ficha_model__Direccion],
      FIELD_NAME__cliente_ficha_model__Telefono:
          nuevoCliente.containsKey(FIELD_NAME__cliente_ficha_model__Telefono)
              ? cliente[FIELD_NAME__cliente_ficha_model__Telefono]
              : _cliente[FIELD_NAME__cliente_ficha_model__Telefono],
    };

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: limpiarCliente                                             */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Delete the Map loaded in memory                         */
  /* -------------------------------------------------------------------- */
  void limpiarCliente() {
    // Se borra el Map en memoria
    _cliente = {
      FIELD_NAME__cliente_ficha_model__ID: '',
      FIELD_NAME__cliente_ficha_model__Nombre: '',
      FIELD_NAME__cliente_ficha_model__Apellido: '',
      FIELD_NAME__cliente_ficha_model__Zona: '',
      FIELD_NAME__cliente_ficha_model__Direccion: '',
      FIELD_NAME__cliente_ficha_model__Telefono: '',
    };

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }
}
