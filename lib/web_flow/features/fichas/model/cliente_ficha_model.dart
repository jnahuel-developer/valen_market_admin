import 'package:valen_market_admin/constants/fieldNames.dart';

class ClienteFichaModel {
  final String uid;
  final String nombre;
  final String apellido;
  final String zona;
  final String direccion;
  final String telefono;

  ClienteFichaModel({
    required this.uid,
    required this.nombre,
    required this.apellido,
    required this.zona,
    required this.direccion,
    required this.telefono,
  });

  // Crea una instancia desde un Map.
  factory ClienteFichaModel.fromMap(Map<String, dynamic> data) {
    return ClienteFichaModel(
      uid: data[FIELD_NAME__cliente_ficha_model__UID] ?? '',
      nombre: data[FIELD_NAME__cliente_ficha_model__Nombre] ?? '',
      apellido: data[FIELD_NAME__cliente_ficha_model__Apellido] ?? '',
      zona: data[FIELD_NAME__cliente_ficha_model__Zona] ?? '',
      direccion: data[FIELD_NAME__cliente_ficha_model__Direccion] ?? '',
      telefono: data[FIELD_NAME__cliente_ficha_model__Telefono] ?? '',
    );
  }

  // Devuelve la representación Map del modelo.
  Map<String, dynamic> toMap() {
    return {
      FIELD_NAME__cliente_ficha_model__UID: uid,
      FIELD_NAME__cliente_ficha_model__Nombre: nombre,
      FIELD_NAME__cliente_ficha_model__Apellido: apellido,
      FIELD_NAME__cliente_ficha_model__Zona: zona,
      FIELD_NAME__cliente_ficha_model__Direccion: direccion,
      FIELD_NAME__cliente_ficha_model__Telefono: telefono,
    };
  }

  // Crea una copia modificada del cliente.
  ClienteFichaModel copyWith(Map<String, dynamic> data) {
    return ClienteFichaModel(
      uid: data[FIELD_NAME__cliente_ficha_model__UID] ?? uid,
      nombre: data[FIELD_NAME__cliente_ficha_model__Nombre] ?? nombre,
      apellido: data[FIELD_NAME__cliente_ficha_model__Apellido] ?? apellido,
      zona: data[FIELD_NAME__cliente_ficha_model__Zona] ?? zona,
      direccion: data[FIELD_NAME__cliente_ficha_model__Direccion] ?? direccion,
      telefono: data[FIELD_NAME__cliente_ficha_model__Telefono] ?? telefono,
    );
  }

  static ClienteFichaModel clienteVacio() => ClienteFichaModel(
        uid: '',
        nombre: '',
        apellido: '',
        zona: '',
        direccion: '',
        telefono: '',
      );
}
