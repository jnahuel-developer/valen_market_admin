import 'package:cloud_firestore/cloud_firestore.dart';

class ClientesServiciosFirebase {
  static final CollectionReference _clientesRef =
      FirebaseFirestore.instance.collection('BDD_Clientes');

  /// Agrega un nuevo cliente a la base de datos.
  static Future<void> agregarClienteABDD({
    required String nombre,
    required String apellido,
    required String direccion,
    required String telefono,
  }) async {
    try {
      await _clientesRef.add({
        'Nombre': nombre.trim().toLowerCase(),
        'Apellido': apellido.trim().toLowerCase(),
        'Dirección': direccion.trim().toLowerCase(),
        'Teléfono': telefono.trim().toLowerCase(),
        'CantidadDeProductosComprados': 0,
      });
    } catch (e) {
      throw Exception('Error al agregar cliente: $e');
    }
  }

  /// Obtiene todos los clientes de la base de datos como una lista de mapas.
  static Future<List<Map<String, dynamic>>> obtenerTodosLosClientes() async {
    try {
      final snapshot = await _clientesRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los clientes: $e');
    }
  }

  /// Obtiene todos los nombres de los clientes desde la base de datos.
  static Future<List<String>> obtenerNombresDeClientes() async {
    try {
      final snapshot = await _clientesRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>?)
          .where((data) => data != null && data.containsKey('Nombre'))
          .map((data) => (data!['Nombre'] as String).trim())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener nombres de clientes: $e');
    }
  }

  /// Obtiene un cliente según su nombre (primera coincidencia exacta, insensible a mayúsculas).
  static Future<Map<String, dynamic>?> obtenerClientePorNombre(
      String nombre) async {
    try {
      final snapshot =
          await _clientesRef.where('Nombre', isEqualTo: nombre).get();

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey('Nombre') &&
            data.containsKey('Apellido') &&
            data.containsKey('Dirección') &&
            data.containsKey('Teléfono')) {
          return data;
        }
      }

      return null; // No se encontró un cliente válido
    } catch (e) {
      throw Exception('Error al obtener el cliente: $e');
    }
  }
}
