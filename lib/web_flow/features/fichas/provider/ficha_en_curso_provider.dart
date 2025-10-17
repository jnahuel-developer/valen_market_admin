import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/cliente_ficha_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/fechas_ficha_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/pagos_ficha_provider.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/producto_ficha_provider.dart';

final fichaEnCursoProvider =
    ChangeNotifierProvider<FichaEnCursoProvider>((ref) {
  return FichaEnCursoProvider();
});

class FichaEnCursoProvider extends ChangeNotifier {
  final ClienteFichaProvider _cliente = ClienteFichaProvider();
  final FechasFichaProvider _fechas = FechasFichaProvider();
  final ProductosFichaProvider _productos = ProductosFichaProvider();
  final PagosFichaProvider _pagos = PagosFichaProvider();

  String? _idFichaActual;
  bool _hayFichaValida = false;

  // Exponer si hay ficha cargada
  bool get hayFichaValida => _hayFichaValida;
  String? get idFichaActual => _idFichaActual;

  // ---------- Lecturas de secciones ----------
  Map<String, dynamic> obtenerCliente() => _cliente.obtenerCliente();
  Map<String, dynamic> obtenerFechas() => _fechas.obtenerFechas();
  List<Map<String, dynamic>> obtenerProductos() =>
      _productos.obtenerProductos();
  Map<String, dynamic> obtenerPagos() => _pagos.obtenerPagos();

  // ---------- Inicializaciones ----------

  /// Inicializa una ficha completamente vacía y carga listas base (clientes + catálogo).
  Future<void> inicializarFichaLimpia() async {
    try {
      _idFichaActual = null;
      _hayFichaValida = false;

      _cliente.limpiarCliente();
      _fechas.limpiarFechas();
      _productos.limpiarProductos();
      _pagos.limpiarPagos();

      notifyListeners();

      // Cargar listas desde servicios (delegados)
      final clientes = await FichasServiciosFirebase.obtenerClientes();
      final productosCatalogo =
          await FichasServiciosFirebase.obtenerProductosCatalogo();

      // Exponer las listas para la UI sería responsabilidad de este provider o de otro provider
      // por simplicidad puedes almacenarlas internamente si lo deseas:
      _clientesCache = clientes;
      _catalogoCache = productosCatalogo;

      if (kDebugMode) {
        print(
            'FichaEnCursoProvider: inicializarFichaLimpia -> clientes: ${clientes.length}, catalogo: ${productosCatalogo.length}');
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Inicializa solo clientes y fechas (para pantalla de búsqueda)
  Future<void> inicializarClientesYFechas() async {
    try {
      _cliente.limpiarCliente();
      _fechas.limpiarFechas();
      notifyListeners();

      _clientesCache = await FichasServiciosFirebase.obtenerClientes();

      if (kDebugMode) {
        print(
            'FichaEnCursoProvider: inicializarClientesYFechas -> clientes: ${_clientesCache.length}');
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Inicializa el provider desde un Map de ficha (obtenido desde Firestore)
  Future<void> inicializarDesdeFichaExistente(
      Map<String, dynamic> fichaMap) async {
    try {
      _idFichaActual =
          fichaMap[FIELD_NAME__ficha_model__ID_De_Ficha]?.toString();
      _hayFichaValida = _idFichaActual != null && _idFichaActual!.isNotEmpty;

      final clienteMap = (fichaMap[FIELD_NAME__ficha_model__Cliente]
              as Map<String, dynamic>?) ??
          {};
      final fechasMap = (fichaMap[FIELD_NAME__ficha_model__Fechas]
              as Map<String, dynamic>?) ??
          {};
      final productosList =
          (fichaMap[FIELD_NAME__ficha_model__Productos] as List<dynamic>?) ??
              [];
      final pagosMap =
          (fichaMap[FIELD_NAME__ficha_model__Pagos] as Map<String, dynamic>?) ??
              {};

      _cliente.actualizarCliente(clienteMap);
      _fechas.actualizarFechas(fechasMap);
      _productos.limpiarProductos();
      for (final p in productosList) {
        if (p is Map<String, dynamic>) {
          _productos.agregarProducto(p);
        }
      }
      _pagos.actualizarPagos(pagosMap);

      if (kDebugMode) {
        print('FichaEnCursoProvider: ficha cargada ID=$_idFichaActual');
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ---------- Mutadores (desde UI) ----------

  void actualizarCliente(Map<String, dynamic> nuevoCliente) {
    _cliente.actualizarCliente(nuevoCliente);
    notifyListeners();
  }

  void actualizarFechas(Map<String, dynamic> nuevasFechas) {
    _fechas.actualizarFechas(nuevasFechas);
    notifyListeners();
  }

  /// Cuando se agrega un producto desde UI, el producto debe traer el campo ID del catálogo.
  /// El provider sólo delega al subprovider; la lógica de incrementar/decrementar (0->1 agregar, 1->0 eliminar)
  /// la controla el FichaEnCursoProvider o la UI según tu diseño. Aquí agregamos producto directamente.
  void agregarProducto(Map<String, dynamic> producto) {
    // Asegurar que tenga ID (FIELD_NAME__producto_ficha_model__ID)
    final id = producto[FIELD_NAME__producto_ficha_model__ID]?.toString() ?? '';
    if (id.isEmpty) {
      throw Exception('Producto sin ID no puede ser agregado');
    }

    _productos.agregarProducto(producto);
    notifyListeners();
  }

  void actualizarProducto(String id, Map<String, dynamic> datosActualizados) {
    _productos.actualizarProducto(id, datosActualizados);
    notifyListeners();
  }

  void eliminarProducto(String id) {
    _productos.eliminarProducto(id);
    notifyListeners();
  }

  /// Actualiza datos globales del bloque de pagos (por ejemplo: importeTotal, cantidadDeCuotas)
  void actualizarPagos(Map<String, dynamic> pagosGlobales) {
    _pagos.actualizarPagos(pagosGlobales);
    notifyListeners();
  }

  /// Registra un pago: actualiza el subprovider de pagos y persiste en Firebase si existe ID.
  Future<void> registrarPago(Map<String, dynamic> pagoItem) async {
    try {
      // 1) actualizar local
      _pagos.agregarPago(pagoItem);
      notifyListeners();

      // 2) persistir en Firebase si la ficha ya tiene ID
      if (_idFichaActual != null && _idFichaActual!.isNotEmpty) {
        await FichasServiciosFirebase.registrarPagoEnFicha(
            _idFichaActual!, pagoItem);
      } else {
        // Si no existe id, lanzar error o decidir guardar la ficha primero
        throw Exception(
            'No hay ficha persistida: registrar pago requiere guardar la ficha primero.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ---------- Persistencia completa ----------

  /// Construye el Map unificado de la ficha
  Map<String, dynamic> obtenerFichaCompleta() {
    return {
      FIELD_NAME__ficha_model__ID_De_Ficha: _idFichaActual,
      FIELD_NAME__ficha_model__Cliente: _cliente.obtenerCliente(),
      FIELD_NAME__ficha_model__Fechas: _fechas.obtenerFechas(),
      FIELD_NAME__ficha_model__Productos: _productos.obtenerProductos(),
      FIELD_NAME__ficha_model__Pagos: _pagos.obtenerPagos(),
    };
  }

  /// Guarda la ficha en Firebase (crea si no hay ID, actualiza si ya existe)
  Future<void> guardarFichaEnFirebase() async {
    try {
      final fichaMap = obtenerFichaCompleta();

      if (_hayFichaValida &&
          _idFichaActual != null &&
          _idFichaActual!.isNotEmpty) {
        await FichasServiciosFirebase.actualizarFicha(
            _idFichaActual!, fichaMap);
      } else {
        final nuevoId = await FichasServiciosFirebase.crearFicha(fichaMap);
        _idFichaActual = nuevoId;
        _hayFichaValida = true;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Limpia todo el estado
  void limpiarFicha() {
    _idFichaActual = null;
    _hayFichaValida = false;
    _cliente.limpiarCliente();
    _fechas.limpiarFechas();
    _productos.limpiarProductos();
    _pagos.limpiarPagos();
    notifyListeners();
  }

  // ---------- Caches opcionales para UI ----------
  List<Map<String, dynamic>> _clientesCache = [];
  List<Map<String, dynamic>> _catalogoCache = [];

  List<Map<String, dynamic>> get clientesCache =>
      List.unmodifiable(_clientesCache);
  List<Map<String, dynamic>> get catalogoCache =>
      List.unmodifiable(_catalogoCache);
}
