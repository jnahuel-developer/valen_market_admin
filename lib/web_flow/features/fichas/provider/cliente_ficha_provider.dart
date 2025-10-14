import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/cliente_ficha_model.dart';

class ClienteFichaProvider extends ChangeNotifier {
  // Constructor nulo
  ClienteFichaModel _cliente = ClienteFichaModel(
    uid: '',
    nombre: '',
    apellido: '',
    zona: '',
    direccion: '',
    telefono: '',
  );

  // Getter total
  ClienteFichaModel get cliente => _cliente;

  // Setter total
  void setCliente(ClienteFichaModel cliente) {
    _cliente = cliente;
    notifyListeners();
  }

  // Método para borrar los datos en memoria
  void limpiarCliente() {
    _cliente = ClienteFichaModel(
      uid: '',
      nombre: '',
      apellido: '',
      zona: '',
      direccion: '',
      telefono: '',
    );
    notifyListeners();
  }
}
