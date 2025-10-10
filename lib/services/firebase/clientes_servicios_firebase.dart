import 'package:cloud_firestore/cloud_firestore.dart';

class ClientesServiciosFirebase {
  static final CollectionReference _clientesRef =
      FirebaseFirestore.instance.collection('BDD_Clientes');

  /* ---------------------------------------------------------------------------------------- */
  //                            METODOS PARA AGREGAR REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

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
        'Zona': 'Norte',
        'Dirección': direccion.trim().toLowerCase(),
        'Teléfono': telefono.trim().toLowerCase(),
        'CantidadDeProductosComprados': 0,
      });
    } catch (e) {
      throw Exception('Error al agregar cliente: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                               METODOS PARA LEER REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene todos los clientes de la base de datos como una lista de mapas.
  static Future<List<Map<String, dynamic>>> obtenerTodosLosClientes() async {
    try {
      final snapshot = await _clientesRef.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id; // Aseguramos incluir el ID de Firebase
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener los clientes: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene todos los nombres de los clientes como combinaciones Nombre + Apellido con su ID.
  static Future<List<Map<String, dynamic>>>
      obtenerNombresCompletosConId() async {
    try {
      final snapshot = await _clientesRef.get();

      return snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data != null &&
            data.containsKey('Nombre') &&
            data.containsKey('Apellido');
      }).map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final nombre = (data['Nombre'] as String).trim();
        final apellido = (data['Apellido'] as String).trim();
        return {
          'ID': doc.id,
          'nombreCompleto': '$nombre $apellido',
        };
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener nombres completos: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene un cliente por ID del documento.
  static Future<Map<String, dynamic>?> obtenerClientePorId(String id) async {
    try {
      final doc = await _clientesRef.doc(id).get();
      final data = doc.data() as Map<String, dynamic>?;

      if (data != null &&
          data.containsKey('Nombre') &&
          data.containsKey('Apellido') &&
          data.containsKey('Zona') &&
          data.containsKey('Dirección') &&
          data.containsKey('Teléfono')) {
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener cliente por ID: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */

  /// Mantiene método anterior por si se requiere búsqueda por nombre exacto
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
            data.containsKey('Zona') &&
            data.containsKey('Dirección') &&
            data.containsKey('Teléfono')) {
          return data;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error al obtener el cliente: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */

  static Future<String?> obtenerIdPorNombreYApellido({
    required String nombre,
    required String apellido,
  }) async {
    try {
      final snapshot = await _clientesRef
          .where('Nombre', isEqualTo: nombre.trim().toLowerCase())
          .where('Apellido', isEqualTo: apellido.trim().toLowerCase())
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener ID por nombre y apellido: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                              METODOS PARA EDITAR REGISTROS                               */
  /* ---------------------------------------------------------------------------------------- */

  static Future<void> actualizarClientePorId(
    String id, {
    required String nombre,
    required String apellido,
    required String direccion,
    required String telefono,
  }) async {
    try {
      await _clientesRef.doc(id).update({
        'Nombre': nombre,
        'Apellido': apellido,
        'Zona': 'Sur',
        'Dirección': direccion,
        'Teléfono': telefono,
      });
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                           METODOS PARA ELIMINAR REGISTROS                                */
  /* ---------------------------------------------------------------------------------------- */

  static Future<void> eliminarClientePorId(String id) async {
    try {
      await _clientesRef.doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar cliente: $e');
    }
  }

  /// Elimina todos los clientes de la base de datos.
  static Future<void> eliminarTodosLosClientes() async {
    try {
      final snapshot = await _clientesRef.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Error al eliminar todos los clientes: $e');
    }
  }
}
