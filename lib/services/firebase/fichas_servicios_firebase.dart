import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

class FichasServiciosFirebase {
  final CollectionReference _fichasCollection =
      FirebaseFirestore.instance.collection('BDD_Fichas');

  /* ---------------------------------------------------------------------------------------- */
  //                            MÉTODOS PARA AGREGAR FICHAS                                   */
  /* ---------------------------------------------------------------------------------------- */

  /// Agrega una nueva ficha asociada a un cliente con sus productos seleccionados.
  Future<void> agregarFicha({
    required String uidCliente,
    required String nombreCliente,
    required String apellidoCliente,
    required String zonaCliente,
    required List<Map<String, dynamic>> productos,
    required DateTime fechaDeVenta,
    required String frecuenciaDeAviso,
    required DateTime proximoAviso,
  }) async {
    try {
      final nroFicha = await obtenerYSiguienteNumeroFicha();

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

      final fichaData = {
        'Nro_de_ficha': nroFicha,
        'UID_Cliente': uidCliente,
        'Nombre': nombreCliente,
        'Apellido': apellidoCliente,
        'Zona': zonaCliente,
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
  //                                MÉTODOS PARA LEER FICHAS                                  */
  /* ---------------------------------------------------------------------------------------- */

  /// Busca fichas por el UID del cliente y devuelve cada ficha combinada con los datos del cliente.
  Future<List<Map<String, dynamic>>> buscarFichasPorClienteId(
      String uidCliente) async {
    try {
      final fichasSnapshot = await _fichasCollection
          .where('UID_Cliente', isEqualTo: uidCliente)
          .get();

      if (fichasSnapshot.docs.isEmpty) {
        return [];
      }

      final clienteData =
          await ClientesServiciosFirebase.obtenerClientePorId(uidCliente);

      if (clienteData == null) {
        throw Exception('No se encontró el cliente con UID: $uidCliente');
      }

      final resultados = fichasSnapshot.docs.map((doc) {
        final fichaData = doc.data() as Map<String, dynamic>;
        fichaData['id'] = doc.id;
        fichaData['nombre'] = clienteData['Nombre'] ?? '';
        fichaData['apellido'] = clienteData['Apellido'] ?? '';
        fichaData['zona'] = clienteData['Zona'] ?? '';
        fichaData['direccion'] = clienteData['Direccion'] ?? '';
        fichaData['telefono'] = clienteData['Telefono'] ?? '';
        fichaData['Nro_de_cuotas_pagadas'] =
            fichaData['Nro_de_cuotas_pagadas'] ?? 0;
        fichaData['Restante'] = fichaData['Restante'] ?? 0;
        return fichaData;
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception('Error al buscar fichas por cliente ID: $e');
    }
  }

  // Se obtiene el numero de la ultima ficha registrada para continuarlo
  Future<int> obtenerYSiguienteNumeroFicha() async {
    final configDoc =
        FirebaseFirestore.instance.collection('config').doc('fichas');

    try {
      final snapshot = await configDoc.get();
      int ultimoNumero = 0;

      if (snapshot.exists) {
        ultimoNumero = snapshot.data()?['Ultimo_Nro_de_ficha'] ?? 0;
      }

      // Actualizamos en config
      await configDoc.set(
          {'Ultimo_Nro_de_ficha': ultimoNumero + 1}, SetOptions(merge: true));

      return ultimoNumero;
    } catch (e) {
      throw Exception('Error al obtener e incrementar el número de ficha: $e');
    }
  }

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

  /* ---------------------------------------------------------------------------------------- */
  //                                MÉTODOS PARA ACTUALIZAR FICHAS                            */
  /* ---------------------------------------------------------------------------------------- */

  /// Actualiza una ficha existente
  Future<void> actualizarFichaPorID({
    required String fichaId,
    required Map<String, dynamic> nuevosDatos,
  }) async {
    try {
      await _fichasCollection.doc(fichaId).update(nuevosDatos);
    } catch (e) {
      throw Exception('Error al actualizar la ficha: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                               MÉTODOS PARA ELIMINAR FICHAS                               */
  /* ---------------------------------------------------------------------------------------- */

  /// Elimina una ficha por su ID
  Future<void> eliminarFichaPorID(String fichaId) async {
    try {
      await _fichasCollection.doc(fichaId).delete();
    } catch (e) {
      throw Exception('Error al eliminar la ficha: $e');
    }
  }
}
