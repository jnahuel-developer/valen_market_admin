import 'package:cloud_firestore/cloud_firestore.dart';

class FichasServiciosFirebase {
  final CollectionReference _fichasCollection =
      FirebaseFirestore.instance.collection('BDD_Fichas');

  /* ---------------------------------------------------------------------------------------- */
  //                            MÉTODOS PARA AGREGAR FICHAS                                   */
  /* ---------------------------------------------------------------------------------------- */

  /// Agrega una nueva ficha asociada a un cliente con sus productos seleccionados.
  Future<void> agregarFicha({
    required String uidCliente,
    required List<Map<String, dynamic>>
        productos, // Cada map contiene los datos de cada producto
    required DateTime fechaDeVenta,
    required String frecuenciaDeAviso,
    required DateTime proximoAviso,
  }) async {
    try {
      // Construimos el mapa de productos con los campos esperados
      Map<String, dynamic> productosMap = {};
      for (int i = 0; i < productos.length; i++) {
        final producto = productos[i];
        productosMap['UID_Producto_$i'] = producto['uidProducto'];
        productosMap['Unidades_Producto_$i'] = producto['unidades'];
        productosMap['Precio_Producto_$i'] = producto['precioUnitario'];
        productosMap['Cantidad_de_cuotas_Producto_$i'] =
            producto['cantidadDeCuotas'];
        productosMap['Precio_de_las_cuotas_Producto_$i'] =
            producto['precioDeLasCuotas'];
        productosMap['Saldado_Producto_$i'] = producto['saldado'];
        productosMap['Restante_Producto_$i'] = producto['restante'];
      }

      // Documento principal de la ficha
      final fichaData = {
        'UID_Cliente': uidCliente,
        'Cantidad_de_Productos': productos.length,
        'Fecha_de_Venta': Timestamp.fromDate(fechaDeVenta),
        'Frecuencia_de_aviso': frecuenciaDeAviso,
        'Proximo_aviso': Timestamp.fromDate(proximoAviso),
        ...productosMap,
        'FechaDeCreacion': FieldValue.serverTimestamp(),
      };

      await _fichasCollection.add(fichaData);
    } catch (e) {
      throw Exception('Error al agregar la ficha: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                    MÉTODOS PARA LEER, ACTUALIZAR Y ELIMINAR FICHAS                      */
  /* ---------------------------------------------------------------------------------------- */

  /// Obtiene todas las fichas registradas
  Future<List<Map<String, dynamic>>> obtenerTodasLasFichas() async {
    try {
      final querySnapshot = await _fichasCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener las fichas: $e');
    }
  }

  /// Obtiene una ficha específica por su ID
  Future<Map<String, dynamic>?> obtenerFichaPorId(String fichaId) async {
    try {
      final docSnapshot = await _fichasCollection.doc(fichaId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        data['id'] = docSnapshot.id;
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener la ficha por ID: $e');
    }
  }

  /// Actualiza una ficha existente
  Future<void> actualizarFicha({
    required String fichaId,
    required Map<String, dynamic> nuevosDatos,
  }) async {
    try {
      await _fichasCollection.doc(fichaId).update(nuevosDatos);
    } catch (e) {
      throw Exception('Error al actualizar la ficha: $e');
    }
  }

  /// Elimina una ficha por su ID
  Future<void> eliminarFicha(String fichaId) async {
    try {
      await _fichasCollection.doc(fichaId).delete();
    } catch (e) {
      throw Exception('Error al eliminar la ficha: $e');
    }
  }
}
