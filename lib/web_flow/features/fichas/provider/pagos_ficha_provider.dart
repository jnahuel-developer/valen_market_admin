import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pago_item_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pagos_ficha_model.dart';

class PagosFichaProvider extends ChangeNotifier {
  // Constructor nulo
  PagosFichaModel _pagos = PagosFichaModel(
    cantidadDeCuotas: 0,
    cuotasPagas: 0,
    restante: 0,
    saldado: false,
    importeSaldado: 0,
    importeCuota: 0,
    importeTotal: 0,
    pagos: [],
  );

  // Getter total
  PagosFichaModel get pagos => _pagos;

  // Setter total
  void setPagos(PagosFichaModel nuevosPagos) {
    _pagos = nuevosPagos;
    notifyListeners();
  }

  // Método para agregar un pago a la lista y actualizar los campos que dependan de esto
  void agregarPago(PagoItemModel nuevoPago) {
    final pagosActualizados = List<PagoItemModel>.from(_pagos.pagos)
      ..add(nuevoPago);

    _pagos = PagosFichaModel(
      cantidadDeCuotas: _pagos.cantidadDeCuotas,
      cuotasPagas: _pagos.cuotasPagas + 1,
      restante: _pagos.restante - nuevoPago.monto,
      saldado: (_pagos.restante - nuevoPago.monto) <= 0,
      importeSaldado: _pagos.importeSaldado + nuevoPago.monto,
      importeCuota: _pagos.importeCuota,
      importeTotal: _pagos.importeTotal,
      pagos: pagosActualizados,
    );

    notifyListeners();
  }

  //  Registrar pago directamente desde un mapa (por Provider o Firebase)
  void registrarPagoDesdeMapa(Map<String, dynamic> pagoMap) {
    final nuevoPago = PagoItemModel.fromMap(pagoMap);
    agregarPago(nuevoPago);
  }

  // Método para borrar los datos en memoria
  void limpiarPagos() {
    _pagos = PagosFichaModel(
      cantidadDeCuotas: 0,
      cuotasPagas: 0,
      restante: 0,
      saldado: false,
      importeSaldado: 0,
      importeCuota: 0,
      importeTotal: 0,
      pagos: [],
    );
    notifyListeners();
  }
}
