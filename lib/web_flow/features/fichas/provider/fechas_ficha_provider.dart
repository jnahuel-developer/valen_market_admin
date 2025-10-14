import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';

class FechasFichaProvider extends ChangeNotifier {
  // Constructor nulo
  FechasFichaModel _fechas = FechasFichaModel(
    fechaDeCreacion: DateTime.now(),
    venta: null,
    proximoAviso: null,
  );

  // Getter total
  FechasFichaModel get fechas => _fechas;

  // Setter total
  void setFechas(FechasFichaModel fechas) {
    _fechas = fechas;
    notifyListeners();
  }

  // Método para borrar los datos en memoria
  void limpiarFechas() {
    _fechas = FechasFichaModel(
      fechaDeCreacion: DateTime.now(),
      venta: null,
      proximoAviso: null,
    );
    notifyListeners();
  }
}
