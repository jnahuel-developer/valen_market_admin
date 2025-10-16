/// ---------------------------------------------------------------------------
/// CLIENTE_FICHA_PROVIDER
///
/// 🔹 Rol general:
/// Administra los datos del cliente asociado a la ficha en curso.
/// Representa una capa intermedia entre la UI y el modelo [ClienteFichaModel].
///
/// 🔹 Forma de uso:
///   - Este provider es de uso interno dentro de [FichaEnCursoProvider].
///   - No debe ser accedido directamente por los Widgets.
///   - Su responsabilidad es mantener un único cliente activo.
///
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]: usa sus métodos públicos para actualizar el cliente.
///   - [ClienteFichaModel]: modelo de datos del cliente.
///
/// 🔹 Lógica principal:
///   - Permite establecer un cliente mediante `setCliente()`.
///   - Provee acceso a través del getter `cliente`.
///   - Permite limpiar el estado (reiniciar los datos del cliente).
///
/// 🔹 Métodos disponibles:
///   • `ClienteFichaModel get cliente` → Obtiene el cliente actual.
///   • `void setCliente(ClienteFichaModel cliente)` → Define un nuevo cliente.
///   • `void limpiarCliente()` → Restablece los valores vacíos.
///
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/cliente_ficha_model.dart';

class ClienteFichaProvider extends ChangeNotifier {
  // Estructura interna en formato Map
  Map<String, dynamic> _cliente = {
    FIELD_NAME__cliente_ficha_model__UID: '',
    FIELD_NAME__cliente_ficha_model__Nombre: '',
    FIELD_NAME__cliente_ficha_model__Apellido: '',
    FIELD_NAME__cliente_ficha_model__Zona: '',
    FIELD_NAME__cliente_ficha_model__Direccion: '',
    FIELD_NAME__cliente_ficha_model__Telefono: '',
  };

  // Devuelve el cliente actual como Map (solo lectura)
  Map<String, dynamic> obtenerCliente() => Map<String, dynamic>.from(_cliente);

  // Reemplaza completamente el cliente en memoria
  void actualizarCliente(Map<String, dynamic> nuevoCliente) {
    final model = ClienteFichaModel.fromMap(nuevoCliente);
    _cliente = model.toMap();
    notifyListeners();
  }

  // Limpia el estado del cliente
  void limpiarCliente() {
    _cliente = {
      FIELD_NAME__cliente_ficha_model__UID: '',
      FIELD_NAME__cliente_ficha_model__Nombre: '',
      FIELD_NAME__cliente_ficha_model__Apellido: '',
      FIELD_NAME__cliente_ficha_model__Zona: '',
      FIELD_NAME__cliente_ficha_model__Direccion: '',
      FIELD_NAME__cliente_ficha_model__Telefono: '',
    };
    notifyListeners();
  }

  // Crea una copia del cliente actual (útil para duplicados o comparaciones)
  Map<String, dynamic> copiarCliente() => Map<String, dynamic>.from(_cliente);
}
