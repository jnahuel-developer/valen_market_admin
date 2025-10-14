// Se definió el servicio de fichas para interactuar con Firestore.
// Se usaron las constantes de fieldNames.dart y los modelos definidos.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_model.dart';

class FichasServiciosFirebase {
  final CollectionReference _fichasCollection =
      FirebaseFirestore.instance.collection('BDD_Fichas');

  final DocumentReference _configFichasDoc =
      FirebaseFirestore.instance.collection('config').doc('fichas');

  /* ---------------------------------------------------------------------------------------- */
  //                                CREAR / GUARDAR FICHA                                      //
  /* ---------------------------------------------------------------------------------------- */

  /// Se creó una nueva ficha en Firestore.
  /// Se devolverá el ID del documento creado.
  /// Se validará que la ficha no tenga ya un ID (no debe existir previo).
  Future<String> CrearFichaEnFirebase(FichaModel ficha) async {
    try {
      // Se obtuvo el siguiente número de ficha.
      final numeroDeFicha = await obtenerYSiguienteNumeroFicha();

      // Se construye el mapa de la ficha a partir del modelo.
      final Map<String, dynamic> data = ficha.toMap();

      // Se aseguró el número de ficha
      data[FIELD_NAME__ficha_model__Numero_De_Ficha] = numeroDeFicha;

      // Se forzó timestamp de creación en el nodo de fechas
      final fechasMap = Map<String, dynamic>.from(
          data[FIELD_NAME__ficha_model__Fechas] ?? {});
      fechasMap[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion] =
          FieldValue.serverTimestamp();
      data[FIELD_NAME__ficha_model__Fechas] = fechasMap;

      // Se creó el documento en Firestore y se devolvió su ID.
      final docRef = await _fichasCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Error en CrearFichaEnFirebase: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                                ACTUALIZAR FICHA                                          //
  /* ---------------------------------------------------------------------------------------- */

  /// Se actualizó la ficha existente identificada por [fichaId] con los datos en [ficha].
  Future<void> ActualizarFichaEnFirebase(
      String fichaId, FichaModel ficha) async {
    try {
      // Se verificó que exista el documento antes de actualizar.
      final docRef = _fichasCollection.doc(fichaId);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        throw Exception('No existe ficha con ID: $fichaId');
      }

      // Se construyó el mapa de actualización desde el modelo.
      final Map<String, dynamic> data = ficha.toMap();

      // Si en las fechas hay un campo FechaDeCreacion con tipo DateTime, se debe mantener el valor
      // existente en servidor; por eso si viene DateTime se convierte a Timestamp.
      if (data[FIELD_NAME__ficha_model__Fechas] != null) {
        final fechasRaw =
            Map<String, dynamic>.from(data[FIELD_NAME__ficha_model__Fechas]);
        if (fechasRaw[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion]
            is DateTime) {
          fechasRaw[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion] =
              Timestamp.fromDate(
                  fechasRaw[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion]
                      as DateTime);
        }
        data[FIELD_NAME__ficha_model__Fechas] = fechasRaw;
      }

      // Se actualizó el documento.
      await docRef.update(data);
    } catch (e) {
      throw Exception('Error en ActualizarFichaEnFirebase: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                                ELIMINAR FICHA                                            //
  /* ---------------------------------------------------------------------------------------- */

  /// Se eliminó el documento de la ficha identificado por [fichaId].
  Future<void> EliminarFichaEnFirebase(String fichaId) async {
    try {
      final docRef = _fichasCollection.doc(fichaId);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        throw Exception('No existe ficha con ID: $fichaId');
      }
      await docRef.delete();
    } catch (e) {
      throw Exception('Error en EliminarFichaEnFirebase: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                                CARGAR / OBTENER FICHAS                                   //
  /* ---------------------------------------------------------------------------------------- */

  /// Se cargó la ficha identificada por [fichaId] y se devolvió como FichaModel.
  /// Si no existe, se devolverá null.
  Future<FichaModel?> CargarFichaDesdeFirebaseMedianteIDCliente(
      String fichaId) async {
    try {
      final docRef = _fichasCollection.doc(fichaId);
      final snapshot = await docRef.get();
      if (!snapshot.exists) return null;

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.data() as Map);
      // Se añadió el ID en el mapa para que fromMap lo tome si corresponde.
      data[FIELD_NAME__ficha_model__ID_De_Ficha] = snapshot.id;

      final ficha = FichaModel.fromMap(data);
      return ficha;
    } catch (e) {
      throw Exception('Error en CargarFichaDesdeFirebaseMedianteIDCliente: $e');
    }
  }

  /// Se obtuvieron todas las fichas que pertenecen al cliente con UID [uidCliente].
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteIDCliente(
      String uidCliente) async {
    try {
      final snapshot = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Cliente.$FIELD_NAME__cliente_ficha_model__UID',
            isEqualTo: uidCliente,
          )
          .get();

      final List<FichaModel> resultados = snapshot.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteIDCliente: $e');
    }
  }

  /// Se obtuvieron fichas filtradas por el nombre del cliente.
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteNombreCliente(
      String nombre) async {
    try {
      final snapshot = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Cliente.$FIELD_NAME__cliente_ficha_model__Nombre',
            isEqualTo: nombre,
          )
          .get();

      final resultados = snapshot.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteNombreCliente: $e');
    }
  }

  /// Se obtuvieron fichas filtradas por el apellido del cliente.
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteApellidoCliente(
      String apellido) async {
    try {
      final snapshot = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Cliente.$FIELD_NAME__cliente_ficha_model__Apellido',
            isEqualTo: apellido,
          )
          .get();

      final resultados = snapshot.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteApellidoCliente: $e');
    }
  }

  /// Se obtuvieron fichas filtradas por la zona del cliente.
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteZonaCliente(
      String zona) async {
    try {
      final snapshot = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Cliente.$FIELD_NAME__cliente_ficha_model__Zona',
            isEqualTo: zona,
          )
          .get();

      final resultados = snapshot.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteZonaCliente: $e');
    }
  }

  /// Se obtuvieron fichas filtradas por la fecha de venta (día, mes, año).
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteFechaVenta(
      DateTime fechaVenta) async {
    try {
      // Se normaliza la fecha al día sin horas.
      final inicioDelDia = Timestamp.fromDate(
          DateTime(fechaVenta.year, fechaVenta.month, fechaVenta.day, 0, 0, 0));
      final finDelDia = Timestamp.fromDate(DateTime(
          fechaVenta.year, fechaVenta.month, fechaVenta.day, 23, 59, 59, 999));

      final query = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Fechas.$FIELD_NAME__fecha_ficha_model__Venta',
            isGreaterThanOrEqualTo: inicioDelDia,
            isLessThanOrEqualTo: finDelDia,
          )
          .get();

      final resultados = query.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteFechaVenta: $e');
    }
  }

  /// Se obtuvieron fichas filtradas por la fecha de próximo aviso (día, mes, año).
  Future<List<FichaModel>> ObtenerFichasDesdeFirebaseMedianteFechaAviso(
      DateTime fechaAviso) async {
    try {
      // Se normaliza la fecha al día sin horas.
      final inicioDelDia = Timestamp.fromDate(
          DateTime(fechaAviso.year, fechaAviso.month, fechaAviso.day, 0, 0, 0));
      final finDelDia = Timestamp.fromDate(DateTime(
          fechaAviso.year, fechaAviso.month, fechaAviso.day, 23, 59, 59, 999));

      final query = await _fichasCollection
          .where(
            '$FIELD_NAME__ficha_model__Fechas.$FIELD_NAME__fecha_ficha_model__Proximo_Aviso',
            isGreaterThanOrEqualTo: inicioDelDia,
            isLessThanOrEqualTo: finDelDia,
          )
          .get();

      final resultados = query.docs.map((doc) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(doc.data() as Map);
        data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
        return FichaModel.fromMap(data);
      }).toList();

      return resultados;
    } catch (e) {
      throw Exception(
          'Error en ObtenerFichasDesdeFirebaseMedianteFechaAviso: $e');
    }
  }

  /* ---------------------------------------------------------------------------------------- */
  //                                NÚMERO CONSECUTIVO DE FICHA                                //
  /* ---------------------------------------------------------------------------------------- */

  /// Se leyó y se incrementó en 1 el campo "UltimoNroDeFicha" del doc "config/fichas".
  /// Se devuelve el número recién asignado.
  Future<int> obtenerYSiguienteNumeroFicha() async {
    try {
      final snapshot = await _configFichasDoc.get();
      int ultimo = 0;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        ultimo = data['UltimoNroDeFicha'] ?? 0;
      }

      final siguiente = ultimo + 1;
      await _configFichasDoc
          .set({'UltimoNroDeFicha': siguiente}, SetOptions(merge: true));

      return siguiente;
    } catch (e) {
      throw Exception('Error en obtenerYSiguienteNumeroFicha: $e');
    }
  }
}
