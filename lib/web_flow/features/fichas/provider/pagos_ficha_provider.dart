/// ---------------------------------------------------------------------------
/// PAGOS_FICHA_PROVIDER
///
/// 🔹 Rol general:
/// Administra el registro y control de pagos realizados en una ficha.
/// Calcula automáticamente los valores dependientes: restante, cuotas pagas,
/// importe saldado y estado “saldado”.
///
/// 🔹 Forma de uso:
///   - Solo se accede desde [FichaEnCursoProvider].
///   - No debe ser accedido directamente por los Widgets.
///
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]: a través de `registrarPago()` y `actualizarFichaMedianteID()`.
///   - [PagosFichaModel] y [PagoItemModel]: modelos de estructura de pagos.
///
/// 🔹 Lógica principal:
///   - Registra nuevos pagos, recalculando automáticamente totales.
///   - Admite registro desde objetos (`agregarPago()`) o mapas (`registrarPagoDesdeMapa()`).
///   - Permite limpiar completamente el historial de pagos.
///
/// 🔹 Métodos disponibles:
///   • `PagosFichaModel get pagos`
///   • `void setPagos(PagosFichaModel nuevosPagos)`
///   • `void agregarPago(PagoItemModel nuevoPago)`
///   • `void registrarPagoDesdeMapa(Map<String, dynamic> pagoMap)`
///   • `void limpiarPagos()`
///
/// ---------------------------------------------------------------------------
library;

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
