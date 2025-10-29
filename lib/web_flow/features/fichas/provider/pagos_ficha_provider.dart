import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pagos_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pago_item_model.dart';

class PagosFichaProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------- */
  /* Estructura interna en formato Map                                    */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> _pagos = PagosFichaModel.pagosVacios().toMap();

  /* -------------------------------------------------------------------- */
  /* Function: obtenerPagos                                               */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: Map                                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Generate a map of the data loaded in memory             */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> obtenerPagos() => Map<String, dynamic>.from(_pagos);

  /* -------------------------------------------------------------------- */
  /* Function: actualizarPagos                                            */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Only replace the data that has been provided in the Map */
  /* -------------------------------------------------------------------- */
  void actualizarPagos(Map<String, dynamic> nuevosDatos) {
    // Se verifica que no se haya sumistrado un Map vacío
    if (nuevosDatos.isEmpty) return;

    // Se obtiene el modelo del Map cargado en memoria
    final modelExistente = PagosFichaModel.fromMap(_pagos);

    // Se genera un nuevo modelo con los datos suministrados
    final nuevoModelo = PagosFichaModel.fromMap({
      ...modelExistente.toMap(),
      ...nuevosDatos,
    });

    // Se actualiza el Map en memoria
    _pagos = nuevoModelo.toMap();

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: agregarPago                                                */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Add a new payment to the history                        */
  /* -------------------------------------------------------------------- */
  void agregarPago(Map<String, dynamic> nuevosDatos) {
    // Se verifica que no se haya sumistrado un Map vacío
    if (nuevosDatos.isEmpty) return;

    // Se obtiene el modelo del Map cargado en memoria
    final modelExistente = PagosFichaModel.fromMap(_pagos);

    // Se genera un modelo en base al Map suministrado
    final nuevoItem = PagoItemModel.fromMap(nuevosDatos);

    // Se agrega el pago a la lista de pagos realizados
    final listaActualizada =
        List<PagoItemModel>.from(modelExistente.pagosRealizados)
          ..add(nuevoItem);

    // Se actualizan los datos totales del pago en la ficha
    final actualizado = PagosFichaModel(
      cantidadDeCuotas: modelExistente.cantidadDeCuotas,
      cuotasPagas: modelExistente.cuotasPagas + 1,
      importeTotal: modelExistente.importeTotal,
      importeCuota: modelExistente.importeCuota,
      importeSaldado: modelExistente.importeSaldado + nuevoItem.monto,
      restante: modelExistente.importeTotal -
          (modelExistente.importeSaldado + nuevoItem.monto),
      saldado: (modelExistente.importeSaldado + nuevoItem.monto) >=
          modelExistente.importeTotal,
      pagosRealizados: listaActualizada,
    );

    // Se actualiza el Map en memoria con los nuevos datos
    _pagos = actualizado.toMap();

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: limpiarPagos                                               */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Delete the Map loaded in memory                         */
  /* -------------------------------------------------------------------- */
  void limpiarPagos() {
    _pagos = PagosFichaModel.pagosVacios().toMap();

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }
}
