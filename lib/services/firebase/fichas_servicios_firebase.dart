import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/services/firebase/catalogo_servicios_firebase.dart';

class FichasServiciosFirebase {
  static final CollectionReference _fichasColl = FirebaseFirestore.instance
      .collection(FIELD_NAME__ficha__Nombre_De_La_Coleccion);

  static final DocumentReference _configFichasDoc = FirebaseFirestore.instance
      .collection(FIELD_NAME__config__Nombre_De_La_Coleccion)
      .doc(FIELD_NAME__config__Nombre_Del_Documento);

  // --------------------------
  // Delegados a otros servicios
  // --------------------------

  /// Devuelve todos los clientes (usando ClientesServiciosFirebase).
  static Future<List<Map<String, dynamic>>> obtenerClientes() async {
    return await ClientesServiciosFirebase.obtenerTodosLosClientes();
  }

  /// Devuelve todos los productos del catálogo (delegando).
  static Future<List<Map<String, dynamic>>> obtenerProductosCatalogo() async {
    final catalogo = CatalogoServiciosFirebase();
    return await catalogo.obtenerTodosLosProductos();
  }

  // --------------------------
  // CRUD Fichas
  // --------------------------

  /// Crea una ficha nueva en Firestore.
  /// Devuelve el ID del documento recién creado.
  static Future<String> crearFicha(Map<String, dynamic> fichaMap) async {
    try {
      // 1) Obtener siguiente numero
      final siguiente = await obtenerYSiguienteNumeroFicha();
      fichaMap = Map<String, dynamic>.from(fichaMap);
      fichaMap[FIELD_NAME__ficha_model__Numero_De_Ficha] = siguiente;

      // 2) Añadir documento (sin ID aún)
      final docRef = await _fichasColl.add(fichaMap);

      // 3) Guardar el ID dentro del documento bajo el campo establecido
      await docRef.set({FIELD_NAME__ficha_model__ID_De_Ficha: docRef.id},
          SetOptions(merge: true));

      return docRef.id;
    } catch (e) {
      throw Exception('Error en crearFicha: $e');
    }
  }

  /// Actualiza la ficha existente (merge: false por compatibilidad con estructura completa).
  static Future<void> actualizarFicha(
      String id, Map<String, dynamic> fichaMap) async {
    try {
      await _fichasColl.doc(id).update(fichaMap);
    } catch (e) {
      throw Exception('Error en actualizarFicha: $e');
    }
  }

  /// Obtiene ficha por ID (agrega campo ID al Map devuelto).
  static Future<Map<String, dynamic>?> obtenerFichaPorID(String id) async {
    try {
      final doc = await _fichasColl.doc(id).get();
      if (!doc.exists) return null;
      final data =
          Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
      data[FIELD_NAME__ficha_model__ID_De_Ficha] = doc.id;
      return data;
    } catch (e) {
      throw Exception('Error en obtenerFichaPorID: $e');
    }
  }

  /// Busca fichas por un campo y valor exacto.
  /// Nota: 'campo' debe ser uno de los fieldNames o rutas como 'Cliente.Nombre', etc.
  static Future<List<Map<String, dynamic>>> buscarFichasPorParametro(
      String campo, dynamic valor) async {
    try {
      final querySnapshot =
          await _fichasColl.where(campo, isEqualTo: valor).get();
      return querySnapshot.docs.map((d) {
        final m = Map<String, dynamic>.from(d.data() as Map<String, dynamic>);
        m[FIELD_NAME__ficha_model__ID_De_Ficha] = d.id;
        return m;
      }).toList();
    } catch (e) {
      throw Exception('Error en buscarFichasPorParametro: $e');
    }
  }

  // --------------------------
  // Números consecutivos
  // --------------------------

  /// Lee y actualiza (incrementa) el último número de ficha en config/fichas
  static Future<int> obtenerYSiguienteNumeroFicha() async {
    try {
      final snapshot = await _configFichasDoc.get();
      int ultimo = 0;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        ultimo = (data[FIELD_NAME__config__Ultimo_Numero_De_Ficha] ?? 0) as int;
      }
      final siguiente = ultimo + 1;
      await _configFichasDoc.set(
          {FIELD_NAME__config__Ultimo_Numero_De_Ficha: siguiente},
          SetOptions(merge: true));
      return siguiente;
    } catch (e) {
      throw Exception('Error en obtenerYSiguienteNumeroFicha: $e');
    }
  }

  // --------------------------
  // Registrar pago (transaccional)
  // --------------------------

  /// Agrega un pago a la ficha, recalcula importes y actualiza en Firestore
  /// Usa una transacción para evitar condiciones de carrera.
  static Future<void> registrarPagoEnFicha(
      String idFicha, Map<String, dynamic> pagoItemMap) async {
    final fichaRef = _fichasColl.doc(idFicha);

    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final docSnap = await tx.get(fichaRef);
        if (!docSnap.exists) {
          throw Exception('Ficha no encontrada: $idFicha');
        }

        final data =
            Map<String, dynamic>.from(docSnap.data() as Map<String, dynamic>);

        // Obtener bloque de pagos actual (o valores por defecto)
        final pagosMap =
            (data[FIELD_NAME__ficha_model__Pagos] as Map<String, dynamic>?) ??
                <String, dynamic>{};
        final List<dynamic> pagosRealizados = List<dynamic>.from(
            pagosMap[FIELD_NAME__pago_ficha_model__Pagos_Realizados] ?? []);

        // Agregar nuevo pago (guardamos la fecha como iso string)
        final pagoToStore = Map<String, dynamic>.from(pagoItemMap);
        // Normalizar fecha si viene DateTime
        if (pagoToStore[FIELD_NAME__pago_item_model__Fecha] is DateTime) {
          pagoToStore[FIELD_NAME__pago_item_model__Fecha] =
              (pagoToStore[FIELD_NAME__pago_item_model__Fecha] as DateTime)
                  .toIso8601String();
        }

        pagosRealizados.add(pagoToStore);

        // Recalcular importes
        final num importeTotal =
            (pagosMap[FIELD_NAME__pago_ficha_model__Importe_Total] ?? 0) as num;

        // Sumatorio de montos (más robusto que sumar incremental)
        num sumaPagos = 0;
        for (final p in pagosRealizados) {
          final pm = p as Map<String, dynamic>;
          sumaPagos += (pm[FIELD_NAME__pago_item_model__Monto] ?? 0) as num;
        }

        final num restante = importeTotal - sumaPagos;
        final bool saldado = sumaPagos >= importeTotal;
        // para mantener coherencia usamos la longitud del arreglo para 'CuotasPagas' si es lo que representas
        final int cuotasPagasRecalculado = pagosRealizados.length;

        // Construir nuevo bloque Pagos
        final nuevoBloquePagos = Map<String, dynamic>.from(pagosMap);
        nuevoBloquePagos[FIELD_NAME__pago_ficha_model__Importe_Saldado] =
            sumaPagos;
        nuevoBloquePagos[FIELD_NAME__pago_ficha_model__Restante] = restante;
        nuevoBloquePagos[FIELD_NAME__pago_ficha_model__Saldado] = saldado;
        nuevoBloquePagos[FIELD_NAME__pago_ficha_model__Cuotas_Pagas] =
            cuotasPagasRecalculado;
        nuevoBloquePagos[FIELD_NAME__pago_ficha_model__Pagos_Realizados] =
            pagosRealizados;

        // Actualizar doc (merge del campo Pagos)
        tx.update(fichaRef, {FIELD_NAME__ficha_model__Pagos: nuevoBloquePagos});
      });
    } catch (e) {
      throw Exception('Error en registrarPagoEnFicha: $e');
    }
  }
}
