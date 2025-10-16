/// ---------------------------------------------------------------------------
/// FICHA_EN_CURSO_PROVIDER
///
/// 🔹 Rol general:
/// Gestiona el estado global de la ficha actualmente en edición o creación
/// dentro del flujo web. Centraliza la interacción entre la UI, los modelos
/// de ficha (`FichaModel`) y el servicio de Firebase (`FichasServiciosFirebase`).
///
/// 🔹 Forma de uso:
/// Este provider debe utilizarse a través de `ref.watch(fichaEnCursoProvider)`
/// o `ref.read(fichaEnCursoProvider.notifier)` dentro de widgets `ConsumerWidget`
/// o `ConsumerStatefulWidget`.
///
/// - Nunca acceder directamente a los subproviders internos.
/// - Toda modificación (cliente, fechas, productos, pagos) debe pasar por los
///   métodos públicos de `FichaEnCursoProvider`.
///
/// 🔹 Interactúa con:
///   - [ClienteFichaProvider]: gestiona la información del cliente.
///   - [FechasFichaProvider]: controla fechas de creación, venta y próximo aviso.
///   - [ProductoFichaProvider]: maneja la lista de productos dentro de la ficha.
///   - [PagosFichaProvider]: registra y actualiza los pagos realizados.
///   - [FichasServiciosFirebase]: sincroniza con la base de datos Firestore.
///
/// 🔹 Lógica principal:
///   - Permite crear, actualizar o eliminar fichas en Firebase.
///   - Mantiene la ficha en curso en memoria mientras se edita.
///   - Expone métodos de conveniencia para acceder a datos específicos.
///   - Gestiona coherencia interna entre subproviders (cliente, fechas, pagos, etc.).
///
/// 🔹 Estados:
///   - `estaVacia`: no hay cliente ni productos cargados.
///   - `esValida`: lista para guardarse (cliente válido + productos cargados).
///
/// ---------------------------------------------------------------------------
///
/// 🔸 INTERFACES Y MÉTODOS DISPONIBLES
/// ---------------------------------------------------------------------------
///
/// ▶️ CLIENTE
/// - `void actualizarCliente(Map<String, dynamic> clienteMap)`
///   Carga o modifica los datos del cliente actual.
///
/// ▶️ FECHAS
/// - `void actualizarFechas(Map<String, dynamic> fechasMap)`
///   Establece las fechas de la ficha (creación, venta, aviso).
///
/// ▶️ PAGOS
/// - `void registrarPago(Map<String, dynamic> pagoMap)`
///   Agrega un nuevo pago a la lista interna de pagos.
///
/// ▶️ IDENTIFICADORES
/// - `void setId(String? id)`
///   Define el ID de la ficha actual (usado para actualización en Firebase).
///
/// - `void setNumeroDeFicha(int nuevoNumero)`
///   Establece el número correlativo de ficha.
///
/// ▶️ PRODUCTOS
/// - `void modificarCantidadDeProducto({required String uidProducto, required bool incrementar, required Map<String, dynamic> datosCatalogo})`
///   Incrementa o decrementa la cantidad de unidades de un producto, agregándolo o quitándolo según corresponda.
///
/// - `void actualizarValoresDelProducto({...})`
///   Permite modificar precio unitario, cuotas o importe de cuotas de un producto ya existente.
///
/// - `void actualizarProductos(List<Map<String, dynamic>> productosMap)`
///   Reemplaza la lista completa de productos (por ejemplo, al cargar una ficha guardada).
///
/// ▶️ CONSTRUCCIÓN Y CARGA DE FICHAS
/// - `FichaModel construirFichaCompleta()`
///   Construye un objeto `FichaModel` a partir del estado actual del provider.
///
/// - `void cargarDesdeFichaModel(FichaModel ficha)`
///   Carga el estado interno desde un modelo ya existente.
///
/// - `void cargarDesdeMap(Map<String, dynamic> data)`
///   Restaura el estado a partir de un mapa (por ejemplo, obtenido de Firebase).
///
/// ▶️ VALIDACIÓN Y ESTADO
/// - `bool get esValida`
///   Retorna `true` si la ficha tiene cliente y productos cargados.
///
/// - `bool get estaVacia`
///   Retorna `true` si no hay cliente ni productos cargados.
///
/// ▶️ LIMPIEZA
/// - `void limpiarFicha()`
///   Reinicia completamente el estado de la ficha en curso.
///
/// ▶️ SINCRONIZACIÓN CON FIREBASE
/// - `Future<void> guardarFicha()`
///   Crea una nueva ficha en Firebase (solo si no tiene ID asignado).
///
/// - `Future<void> actualizarFichaMedianteID()`
///   Actualiza una ficha existente en Firebase.
///
/// - `Future<void> eliminarFichaMedianteID()`
///   Elimina una ficha en Firebase y limpia el estado local.
///
/// - `Future<void> cargarFichaMedianteID()`
///   Descarga y carga una ficha existente desde Firebase.
///
/// ▶️ CONSULTAS POR FILTROS (Firebase)
/// - `Future<List<FichaModel>> obtenerFichasMedianteID()`
/// - `Future<List<FichaModel>> obtenerFichasMedianteNombre()`
/// - `Future<List<FichaModel>> obtenerFichasMedianteApellido()`
/// - `Future<List<FichaModel>> obtenerFichasMedianteZona()`
/// - `Future<List<FichaModel>> obtenerFichasMedianteFechaVenta()`
/// - `Future<List<FichaModel>> obtenerFichasMedianteFechaAviso()`
///
/// ▶️ GETTERS DE ACCESO SIMPLIFICADO (para UI)
/// - `String? get uidCliente`
/// - `String? get nombreCliente`
/// - `String? get apellidoCliente`
/// - `String? get zonaCliente`
/// - `String? get direccionCliente`
/// - `String? get telefonoCliente`
/// - `DateTime? get fechaDeVenta`
/// - `DateTime? get proximoAviso`
/// - `List<ProductoFichaModel> get productos`
/// - `PagosFichaModel get pagos`
///
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/producto_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pagos_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/cliente_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/cliente_ficha_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/fechas_ficha_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/producto_ficha_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/pagos_ficha_provider.dart';

class FichaEnCursoProvider extends ChangeNotifier {
  // Subproviders internos (no deben ser accedidos directamente fuera de este módulo)
  final ClienteFichaProvider _clienteProvider = ClienteFichaProvider();
  final FechasFichaProvider _fechasProvider = FechasFichaProvider();
  final ProductoFichaProvider _productoProvider = ProductoFichaProvider();
  final PagosFichaProvider _pagosProvider = PagosFichaProvider();

  final FichasServiciosFirebase _firebaseService = FichasServiciosFirebase();

  String? _id; // ID del documento en Firestore
  int _numeroDeFicha = 0;

  // Getters
  String? get id => _id;
  int get numeroDeFicha => _numeroDeFicha;

  // ------------------------------------------------------------------------------------
  // MÉTODOS DE ACTUALIZACIÓN
  // ------------------------------------------------------------------------------------

  void actualizarCliente(Map<String, dynamic> clienteMap) {
    _clienteProvider.setCliente(ClienteFichaModel.fromMap(clienteMap));
    notifyListeners();
  }

  void actualizarFechas(Map<String, dynamic> fechasMap) {
    final fechas = FechasFichaModel.fromMap(fechasMap);

    // Normalizamos las fechas sin modificar las propiedades finales
    final fechaVentaNormalizada = (fechas.venta != null)
        ? DateTime(fechas.venta!.year, fechas.venta!.month, fechas.venta!.day)
        : null;

    final proximoAvisoNormalizado = (fechas.proximoAviso != null)
        ? DateTime(fechas.proximoAviso!.year, fechas.proximoAviso!.month,
            fechas.proximoAviso!.day)
        : null;

    final fechasNormalizadas = FechasFichaModel(
      fechaDeCreacion: DateTime(
        fechas.fechaDeCreacion.year,
        fechas.fechaDeCreacion.month,
        fechas.fechaDeCreacion.day,
      ),
      venta: fechaVentaNormalizada,
      proximoAviso: proximoAvisoNormalizado,
    );

    _fechasProvider.setFechas(fechasNormalizadas);
    notifyListeners();
  }

  void registrarPago(Map<String, dynamic> pagoMap) {
    _pagosProvider.registrarPagoDesdeMapa(pagoMap);
    notifyListeners();
  }

  void setId(String? id) {
    _id = id;
    notifyListeners();
  }

  void setNumeroDeFicha(int nuevoNumero) {
    _numeroDeFicha = nuevoNumero;
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // 🔹 Incrementar o decrementar unidades de un producto
  // ---------------------------------------------------------------------
  void modificarCantidadDeProducto({
    required String uidProducto,
    required bool incrementar,
    required Map<String, dynamic> datosCatalogo,
  }) {
    final existente = _productoProvider.productos.firstWhere(
      (p) => p.uid == uidProducto,
    );

    int nuevaCantidad = (existente.unidades ?? 0) + (incrementar ? 1 : -1);
    if (nuevaCantidad < 0) nuevaCantidad = 0;

    if (nuevaCantidad == 0) {
      _productoProvider.eliminarProductoPorUID(uidProducto);
    } else if (existente.uid.isEmpty) {
      // Producto nuevo desde catálogo
      final nuevoProducto = ProductoFichaModel.fromMap({
        FIELD_NAME__producto_ficha_model__UID:
            datosCatalogo[FIELD_NAME__producto_ficha_model__UID],
        FIELD_NAME__producto_ficha_model__Nombre:
            datosCatalogo[FIELD_NAME__catalogo__Nombre_Del_Producto],
        FIELD_NAME__producto_ficha_model__Unidades: nuevaCantidad,
        FIELD_NAME__producto_ficha_model__Precio_Unitario:
            (datosCatalogo[FIELD_NAME__catalogo__Precio] ?? 0).toDouble(),
        FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas:
            datosCatalogo[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ?? 1,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas:
            ((datosCatalogo[FIELD_NAME__catalogo__Precio] ?? 0).toDouble() /
                (datosCatalogo[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ?? 1)),
      });
      _productoProvider.agregarProducto(nuevoProducto);
    } else {
      _productoProvider.actualizarCantidadDeProducto(
          uidProducto, nuevaCantidad);
    }

    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // 🔹 Actualizar valores financieros del producto
  // ---------------------------------------------------------------------
  void actualizarValoresDelProducto({
    required String uidProducto,
    required double nuevoPrecioUnitario,
    required int nuevaCantidadDeCuotas,
    required double nuevoImporteDeLasCuotas,
  }) {
    _productoProvider.actualizarValoresDelProducto(
      uidProducto: uidProducto,
      nuevoPrecioUnitario: nuevoPrecioUnitario,
      nuevaCantidadDeCuotas: nuevaCantidadDeCuotas,
      nuevoImporteDeLasCuotas: nuevoImporteDeLasCuotas,
    );
    notifyListeners();
  }

  // ---------------------------------------------------------------------
  // 🔹 Actualizar lista completa (ya existente)
  // ---------------------------------------------------------------------
  void actualizarProductos(List<Map<String, dynamic>> productosMap) {
    _productoProvider.limpiarProductos();
    for (final p in productosMap) {
      _productoProvider.agregarProducto(ProductoFichaModel.fromMap(p));
    }
    notifyListeners();
  }

  // ------------------------------------------------------------------------------------
  // MÉTODOS DE CONSTRUCCIÓN Y CARGA COMPLETA
  // ------------------------------------------------------------------------------------

  FichaModel construirFichaCompleta() {
    return FichaModel(
      id: _id,
      numeroDeFicha: _numeroDeFicha,
      cantidadDeProductos: _productoProvider.productos.length,
      cliente: _clienteProvider.cliente,
      fechas: _fechasProvider.fechas,
      pagos: _pagosProvider.pagos,
      productos: _productoProvider.productos,
    );
  }

  void cargarDesdeFichaModel(FichaModel ficha) {
    _id = ficha.id;
    _numeroDeFicha = ficha.numeroDeFicha;
    _clienteProvider.setCliente(ficha.cliente);
    _fechasProvider.setFechas(ficha.fechas);
    _pagosProvider.setPagos(ficha.pagos);

    _productoProvider.limpiarProductos();
    for (var p in ficha.productos) {
      _productoProvider.agregarProducto(p);
    }

    notifyListeners();
  }

  void cargarDesdeMap(Map<String, dynamic> data) {
    _id = data[FIELD_NAME__ficha_model__ID_De_Ficha];
    _numeroDeFicha = data[FIELD_NAME__ficha_model__Numero_De_Ficha] ?? 0;

    _clienteProvider.setCliente(ClienteFichaModel.fromMap(
        data[FIELD_NAME__ficha_model__Cliente] ?? {}));

    _fechasProvider.setFechas(
        FechasFichaModel.fromMap(data[FIELD_NAME__ficha_model__Fechas] ?? {}));

    _pagosProvider.setPagos(
        PagosFichaModel.fromMap(data[FIELD_NAME__ficha_model__Pagos] ?? {}));

    final productosMap = data[FIELD_NAME__ficha_model__Productos];
    if (productosMap is Map<String, dynamic>) {
      _productoProvider.limpiarProductos();
      productosMap.forEach((key, value) {
        _productoProvider.agregarProducto(ProductoFichaModel.fromMap(value));
      });
    }

    notifyListeners();
  }

  // ------------------------------------------------------------------------------------
  // VALIDACIÓN Y ESTADO
  // ------------------------------------------------------------------------------------

  bool get esValida {
    return _clienteProvider.cliente.uid.isNotEmpty &&
        _productoProvider.productos.isNotEmpty;
  }

  bool get estaVacia {
    return _clienteProvider.cliente.uid.isEmpty &&
        _productoProvider.productos.isEmpty;
  }

  // ------------------------------------------------------------------------------------
  // LIMPIEZA
  // ------------------------------------------------------------------------------------

  void limpiarFicha() {
    _clienteProvider.limpiarCliente();
    _fechasProvider.limpiarFechas();
    _productoProvider.limpiarProductos();
    _pagosProvider.limpiarPagos();
    _id = null;
    _numeroDeFicha = 0;
    notifyListeners();
  }

  // ------------------------------------------------------------------------------------
  // SINCRONIZACIÓN CON FIREBASE
  // ------------------------------------------------------------------------------------

  Future<void> guardarFicha() async {
    if (_id != null) {
      throw Exception(
          'La ficha ya tiene un ID asignado. Use actualizarFichaMedianteID() en su lugar.');
    }

    final nuevaFicha = construirFichaCompleta();
    final nuevoId = await _firebaseService.CrearFichaEnFirebase(nuevaFicha);
    _id = nuevoId;
    notifyListeners();
  }

  Future<void> actualizarFichaMedianteID() async {
    if (_id == null) {
      throw Exception('No hay ID asignado. No se puede actualizar.');
    }
    final ficha = construirFichaCompleta();
    await _firebaseService.ActualizarFichaEnFirebase(_id!, ficha);
  }

  Future<void> eliminarFichaMedianteID() async {
    if (_id == null) return;
    await _firebaseService.EliminarFichaEnFirebase(_id!);
    limpiarFicha();
  }

  Future<void> cargarFichaMedianteID() async {
    if (_id == null) throw Exception('No hay ID asignado.');

    final ficha =
        await _firebaseService.CargarFichaDesdeFirebaseMedianteIDCliente(_id!);

    if (ficha == null) {
      throw Exception(
          'No se encontró ninguna ficha con el ID $_id en Firebase.');
    }

    cargarDesdeFichaModel(ficha);
  }

  // Métodos de obtención por filtros
  Future<List<FichaModel>> obtenerFichasMedianteID() async {
    return await _firebaseService.ObtenerFichasDesdeFirebaseMedianteIDCliente(
        _clienteProvider.cliente.uid);
  }

  Future<List<FichaModel>> obtenerFichasMedianteNombre() async {
    return await _firebaseService
        .ObtenerFichasDesdeFirebaseMedianteNombreCliente(
            _clienteProvider.cliente.nombre);
  }

  Future<List<FichaModel>> obtenerFichasMedianteApellido() async {
    return await _firebaseService
        .ObtenerFichasDesdeFirebaseMedianteApellidoCliente(
            _clienteProvider.cliente.apellido);
  }

  Future<List<FichaModel>> obtenerFichasMedianteZona() async {
    return await _firebaseService.ObtenerFichasDesdeFirebaseMedianteZonaCliente(
        _clienteProvider.cliente.zona);
  }

  Future<List<FichaModel>> obtenerFichasMedianteFechaVenta() async {
    final fecha = _fechasProvider.fechas.venta;
    if (fecha == null) return [];
    return await _firebaseService.ObtenerFichasDesdeFirebaseMedianteFechaVenta(
        DateTime(fecha.year, fecha.month, fecha.day));
  }

  Future<List<FichaModel>> obtenerFichasMedianteFechaAviso() async {
    final fecha = _fechasProvider.fechas.proximoAviso;
    if (fecha == null) return [];
    return await _firebaseService.ObtenerFichasDesdeFirebaseMedianteFechaAviso(
        DateTime(fecha.year, fecha.month, fecha.day));
  }

  // ------------------------------------------------------------------------------------
  // GETTERS DE ACCESO SIMPLIFICADO (para UI)
  // ------------------------------------------------------------------------------------

  String? get uidCliente => _clienteProvider.cliente.uid;
  String? get nombreCliente => _clienteProvider.cliente.nombre;
  String? get apellidoCliente => _clienteProvider.cliente.apellido;
  String? get zonaCliente => _clienteProvider.cliente.zona;
  String? get direccionCliente => _clienteProvider.cliente.direccion;
  String? get telefonoCliente => _clienteProvider.cliente.telefono;
  DateTime? get fechaDeVenta => _fechasProvider.fechas.venta;
  DateTime? get proximoAviso => _fechasProvider.fechas.proximoAviso;
  List<ProductoFichaModel> get productos => _productoProvider.productos;
  PagosFichaModel get pagos => _pagosProvider.pagos;
}

final fichaEnCursoProvider =
    ChangeNotifierProvider<FichaEnCursoProvider>((ref) {
  return FichaEnCursoProvider();
});
