import 'package:flutter/foundation.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pagos_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pago_item_model.dart';

class PagosFichaProvider extends ChangeNotifier {
  Map<String, dynamic> _pagos = PagosFichaModel.pagosVacios().toMap();

  /// Obtener copia del estado actual
  Map<String, dynamic> obtenerPagos() => Map<String, dynamic>.from(_pagos);

  /// Actualizar los datos globales del bloque de pagos
  void actualizarPagos(Map<String, dynamic> nuevosDatos) {
    final modelExistente = PagosFichaModel.fromMap(_pagos);
    final nuevoModelo = PagosFichaModel.fromMap({
      ...modelExistente.toMap(),
      ...nuevosDatos,
    });
    _pagos = nuevoModelo.toMap();
    notifyListeners();
  }

  /// Agregar un nuevo pago al historial
  void agregarPago(Map<String, dynamic> nuevoPago) {
    final pagosModel = PagosFichaModel.fromMap(_pagos);
    final nuevoItem = PagoItemModel.fromMap(nuevoPago);

    final listaActualizada =
        List<PagoItemModel>.from(pagosModel.pagosRealizados)..add(nuevoItem);

    final actualizado = PagosFichaModel(
      cantidadDeCuotas: pagosModel.cantidadDeCuotas,
      cuotasPagas: pagosModel.cuotasPagas + 1,
      importeTotal: pagosModel.importeTotal,
      importeCuota: pagosModel.importeCuota,
      importeSaldado: pagosModel.importeSaldado + nuevoItem.monto,
      restante: pagosModel.importeTotal -
          (pagosModel.importeSaldado + nuevoItem.monto),
      saldado: (pagosModel.importeSaldado + nuevoItem.monto) >=
          pagosModel.importeTotal,
      pagosRealizados: listaActualizada,
    );

    _pagos = actualizado.toMap();
    notifyListeners();
  }

  /// Limpiar todo el bloque de pagos
  void limpiarPagos() {
    _pagos = PagosFichaModel.pagosVacios().toMap();
    notifyListeners();
  }

  /// Copiar pagos
  Map<String, dynamic> copiarPagos() => Map<String, dynamic>.from(_pagos);
}
