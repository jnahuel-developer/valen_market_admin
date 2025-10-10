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
/*
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
        'NroDeFicha': nroFicha,
        'UID_Cliente': uidCliente,
        'Nombre': nombreCliente,
        'Apellido': apellidoCliente,
        'Zona': zonaCliente,
        'Cantidad_de_Productos': productos.length,
        'FechaDeVenta': Timestamp.fromDate(fechaDeVenta),
        'Frecuencia_de_aviso': frecuenciaDeAviso,
        'ProximoAviso': Timestamp.fromDate(proximoAviso),
        ...productosMap,
        'FechaDeCreacion': FieldValue.serverTimestamp(),
      };

      await _fichasCollection.add(fichaData);
*/
      // --- Estructuramos los productos como una lista de mapas ---
      final List<Map<String, dynamic>> productosList = productos.map((p) {
        return {
          'UID': p['uidProducto'],
          'Nombre': p['nombreProducto'] ?? '',
          'Unidades': p['unidades'],
          'PrecioUnitario': p['precioUnitario'],
          'CantidadDeCuotas': p['cantidadDeCuotas'],
          'PrecioDeLasCuotas': p['precioDeLasCuotas'],
          'Saldado': p['saldado'],
          'Restante': p['restante'],
          'CuotasPagas': p['cuotasPagas'] ?? 0,
          'TotalSaldado': p['totalSaldado'] ?? 0.0,
        };
      }).toList();

      // --- Documento estructurado en secciones ---
      final fichaDataNuevoFormato = {
        'NroDeFicha': nroFicha,
        'Cliente': {
          'UID': uidCliente,
          'Nombre': nombreCliente,
          'Apellido': apellidoCliente,
          'Zona': zonaCliente,
        },
        'Fechas': {
          'Venta': Timestamp.fromDate(fechaDeVenta),
          'ProximoAviso': Timestamp.fromDate(proximoAviso),
        },
        'Productos': productosList,
        'CantidadDeProductos': productosList.length,
        'FrecuenciaDeAviso': frecuenciaDeAviso,
        'FechaDeCreacion': FieldValue.serverTimestamp(),
      };

      await _fichasCollection.add(fichaDataNuevoFormato);
    } catch (e) {
      throw Exception('Error al agregar la ficha: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                                MÉTODOS PARA LEER FICHAS                                  */
  /* ---------------------------------------------------------------------------------------- */
/*
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
        fichaData['ID'] = doc.id;
        fichaData['Nombre'] = clienteData['Nombre'] ?? '';
        fichaData['Apellido'] = clienteData['Apellido'] ?? '';
        fichaData['Zona'] = clienteData['Zona'] ?? '';
        fichaData['direccion'] = clienteData['Direccion'] ?? '';
        fichaData['telefono'] = clienteData['Telefono'] ?? '';

        fichaData['FechaDeVenta'] = (fichaData['FechaDeVenta'] is Timestamp)
            ? (fichaData['FechaDeVenta'] as Timestamp).toDate()
            : null;

        fichaData['ProximoAviso'] = (fichaData['ProximoAviso'] is Timestamp)
            ? (fichaData['ProximoAviso'] as Timestamp).toDate()
            : null;

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

  Future<List<Map<String, dynamic>>> buscarFichasPorNombre(
      String nombre) async {
    try {
      final snapshot = await _fichasCollection
          .where('Nombre', isEqualTo: nombre.toLowerCase())
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por nombre: $e');
    }
  }

  Future<List<Map<String, dynamic>>> buscarFichasPorApellido(
      String apellido) async {
    try {
      final snapshot = await _fichasCollection
          .where('Apellido', isEqualTo: apellido.toLowerCase())
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por apellido: $e');
    }
  }

  Future<List<Map<String, dynamic>>> buscarFichasPorZona(String zona) async {
    try {
      final snapshot =
          await _fichasCollection.where('Zona', isEqualTo: zona).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por zona: $e');
    }
  }
*/

  /// Se buscan fichas asociadas al UID de un cliente y se devuelven junto con los datos del cliente.
  Future<List<Map<String, dynamic>>> buscarFichasPorClienteId(
      String uidCliente) async {
    try {
      final fichasSnapshot = await _fichasCollection
          .where('Cliente.UID', isEqualTo: uidCliente)
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
        final cliente = fichaData['Cliente'] ?? {};
        final fechas = fichaData['Fechas'] ?? {};

        fichaData['ID'] = doc.id;
        fichaData['Nombre'] = cliente['Nombre'] ?? clienteData['Nombre'] ?? '';
        fichaData['Apellido'] =
            cliente['Apellido'] ?? clienteData['Apellido'] ?? '';
        fichaData['Zona'] = cliente['Zona'] ?? clienteData['Zona'] ?? '';

        fichaData['FechaDeVenta'] = (fechas['Venta'] is Timestamp)
            ? (fechas['Venta'] as Timestamp).toDate()
            : null;

        fichaData['ProximoAviso'] = (fechas['ProximoAviso'] is Timestamp)
            ? (fechas['ProximoAviso'] as Timestamp).toDate()
            : null;

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

  /// Se buscan fichas en las que el nombre del cliente coincida con el valor indicado.
  Future<List<Map<String, dynamic>>> buscarFichasPorNombre(
      String nombre) async {
    try {
      final snapshot = await _fichasCollection
          .where('Cliente.Nombre', isEqualTo: nombre)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por nombre: $e');
    }
  }

  /// Se buscan fichas en las que el apellido del cliente coincida con el valor indicado.
  Future<List<Map<String, dynamic>>> buscarFichasPorApellido(
      String apellido) async {
    try {
      final snapshot = await _fichasCollection
          .where('Cliente.Apellido', isEqualTo: apellido)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por apellido: $e');
    }
  }

  /// Se buscan fichas en las que la zona del cliente coincida con el valor indicado.
  Future<List<Map<String, dynamic>>> buscarFichasPorZona(String zona) async {
    try {
      final snapshot =
          await _fichasCollection.where('Cliente.Zona', isEqualTo: zona).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar fichas por zona: $e');
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
        ultimoNumero = snapshot.data()?['UltimoNroDeFicha'] ?? 0;
      }

      // Actualizamos en config
      await configDoc
          .set({'UltimoNroDeFicha': ultimoNumero + 1}, SetOptions(merge: true));

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
        data['ID'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener las fichas: $e');
    }
  }
/*
  /// Obtiene una ficha específica por su ID
  Future<Map<String, dynamic>?> obtenerFichaPorId(String fichaId) async {
    try {
      final docSnapshot = await _fichasCollection.doc(fichaId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        data['ID'] = docSnapshot.id;

        if (data['FechaDeVenta'] is Timestamp) {
          data['FechaDeVenta'] = (data['FechaDeVenta'] as Timestamp).toDate();
        }

        if (data['ProximoAviso'] is Timestamp) {
          data['ProximoAviso'] = (data['ProximoAviso'] as Timestamp).toDate();
        }

        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener la ficha por ID: $e');
    }
  }
*/

  /// Se obtiene una ficha específica a partir de su ID.
  Future<Map<String, dynamic>?> obtenerFichaPorId(String fichaId) async {
    try {
      final docSnapshot = await _fichasCollection.doc(fichaId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      data['ID'] = docSnapshot.id;

      // Se extraen las secciones del documento
      final cliente = data['Cliente'] ?? {};
      final fechas = data['Fechas'] ?? {};
      final productos = data['Productos'] ?? [];

      // Se asignan los valores con nombres coherentes
      data['UID_Cliente'] = cliente['UID'];
      data['Nombre'] = cliente['Nombre'];
      data['Apellido'] = cliente['Apellido'];
      data['Zona'] = cliente['Zona'];

      // Se convierten las fechas en objetos DateTime
      data['FechaDeVenta'] = (fechas['Venta'] is Timestamp)
          ? (fechas['Venta'] as Timestamp).toDate()
          : null;

      data['ProximoAviso'] = (fechas['ProximoAviso'] is Timestamp)
          ? (fechas['ProximoAviso'] as Timestamp).toDate()
          : null;

      // Se garantiza que la lista de productos sea devuelta correctamente
      data['Productos'] = List<Map<String, dynamic>>.from(productos);

      return data;
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

  /* ---------------------------------------------------------------------------------------- */
  //                            MÉTODOS PARA AGREGAR PAGOS                                    */
  /* ---------------------------------------------------------------------------------------- */

  Future<void> registrarPagoFicha({
    required String fichaId,
    required double monto,
    required DateTime fechaPago,
  }) async {
    try {
      final fichaRef = _fichasCollection.doc(fichaId);
      final ficha = await fichaRef.get();
      if (!ficha.exists) throw Exception('Ficha no encontrada');

      final data = ficha.data() as Map<String, dynamic>;
      final pagosPrevios = List<Map<String, dynamic>>.from(data['Pagos'] ?? []);
      pagosPrevios.add({
        'FechaPago': Timestamp.fromDate(fechaPago),
        'Monto': monto,
      });

      final double nuevoTotalSaldado = (data['TotalSaldado'] ?? 0) + monto;
      final double nuevoRestante =
          ((data['TotalFicha'] ?? 0) - nuevoTotalSaldado)
              .clamp(0, double.infinity);

      await fichaRef.update({
        'Pagos': pagosPrevios,
        'TotalSaldado': nuevoTotalSaldado,
        'Restante': nuevoRestante,
        'UltimoPago': Timestamp.fromDate(fechaPago),
      });
    } catch (e) {
      throw Exception('Error al registrar el pago: $e');
    }
  }
}
