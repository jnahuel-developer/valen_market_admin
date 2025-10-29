import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';

class ClientesServiciosFirebase {
  static final CollectionReference _clientesRef = FirebaseFirestore.instance
      .collection(FIELD_NAME__clientes__Nombre_De_La_Coleccion);

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
        FIELD_NAME__clientes__Nombre_Del_Cliente: nombre.trim().toLowerCase(),
        FIELD_NAME__clientes__Apellido_Del_Cliente:
            apellido.trim().toLowerCase(),
        FIELD_NAME__clientes__Zona_Del_Cliente: 'Norte',
        FIELD_NAME__clientes__Direccion_Del_Cliente:
            direccion.trim().toLowerCase(),
        FIELD_NAME__clientes__Telefono_Del_Cliente:
            telefono.trim().toLowerCase(),
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
        data[FIELD_NAME__clientes__ID_Del_Cliente] =
            doc.id; // Aseguramos incluir el ID de Firebase
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
            data.containsKey(FIELD_NAME__clientes__Nombre_Del_Cliente) &&
            data.containsKey(FIELD_NAME__clientes__Apellido_Del_Cliente);
      }).map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final nombre =
            (data[FIELD_NAME__clientes__Nombre_Del_Cliente] as String).trim();
        final apellido =
            (data[FIELD_NAME__clientes__Apellido_Del_Cliente] as String).trim();
        return {
          FIELD_NAME__clientes__ID_Del_Cliente: doc.id,
          FIELD_NAME__clientes__Nombre_Compuesto_Del_Cliente:
              '$nombre $apellido',
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
          data.containsKey(FIELD_NAME__clientes__Nombre_Del_Cliente) &&
          data.containsKey(FIELD_NAME__clientes__Apellido_Del_Cliente) &&
          data.containsKey(FIELD_NAME__clientes__Zona_Del_Cliente) &&
          data.containsKey(FIELD_NAME__cliente_ficha_model__Direccion) &&
          data.containsKey(FIELD_NAME__clientes__Telefono_Del_Cliente)) {
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
      final snapshot = await _clientesRef
          .where(FIELD_NAME__clientes__Nombre_Del_Cliente, isEqualTo: nombre)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null &&
            data.containsKey(FIELD_NAME__clientes__Nombre_Del_Cliente) &&
            data.containsKey(FIELD_NAME__clientes__Apellido_Del_Cliente) &&
            data.containsKey(FIELD_NAME__clientes__Zona_Del_Cliente) &&
            data.containsKey(FIELD_NAME__cliente_ficha_model__Direccion) &&
            data.containsKey(FIELD_NAME__clientes__Telefono_Del_Cliente)) {
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
          .where(FIELD_NAME__clientes__Nombre_Del_Cliente,
              isEqualTo: nombre.trim().toLowerCase())
          .where(FIELD_NAME__clientes__Apellido_Del_Cliente,
              isEqualTo: apellido.trim().toLowerCase())
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
        FIELD_NAME__clientes__Nombre_Del_Cliente: nombre,
        FIELD_NAME__clientes__Apellido_Del_Cliente: apellido,
        FIELD_NAME__clientes__Zona_Del_Cliente: 'Sur',
        FIELD_NAME__cliente_ficha_model__Direccion: direccion,
        FIELD_NAME__clientes__Telefono_Del_Cliente: telefono,
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
