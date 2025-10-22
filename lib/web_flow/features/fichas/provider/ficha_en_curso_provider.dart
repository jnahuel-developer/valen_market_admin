import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/textos.dart';
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

      // Se setea la fecha de creación al iniciar una ficha nueva
      final hoy = DateTime.now();
      _fechas.actualizarFechas({
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion:
            DateTime(hoy.year, hoy.month, hoy.day),
      });

      notifyListeners();

      // Cargar listas desde servicios (delegados)
      final clientes = await FichasServiciosFirebase.obtenerClientes();
      final productosCatalogo =
          await FichasServiciosFirebase.obtenerProductosCatalogo();

      // Exponer las listas para la UI sería responsabilidad de este provider o de otro provider
      // por simplicidad puedes almacenarlas internamente si lo deseas:
      _clientesCache = clientes;
      _catalogoCache = productosCatalogo;

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

  /// Indica si la ficha tiene datos mínimos para guardarse (cliente y productos)
  bool esFichaValidaParaGuardar() {
    final cliente = _cliente.obtenerCliente();
    final productos = _productos.obtenerProductos();

    final clienteTieneID =
        cliente[FIELD_NAME__cliente_ficha_model__ID]?.toString().isNotEmpty ??
            false;
    final hayProductos = productos.isNotEmpty;

    return clienteTieneID && hayProductos;
  }

  /// Guarda la ficha en Firebase (crea si no hay ID, actualiza si ya existe)
  Future<void> guardarFichaEnFirebase() async {
    try {
      // --- Paso 1: sincronizar bloque de pagos con los productos actuales ---
      final productos = _productos.obtenerProductos();

      if (productos.isNotEmpty) {
        // Determinar la cantidad de cuotas mayor entre los productos
        final cantidadMaxCuotas = productos.fold<int>(
          0,
          (max, p) => (p[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ?? 0) > max
              ? p[FIELD_NAME__catalogo__Cantidad_De_Cuotas]
              : max,
        );

        // Recalcular precio de las cuotas y totales
        double importeCuotaTotal = 0;
        double importeTotal = 0;

        for (final producto in productos) {
          final unidades =
              (producto[FIELD_NAME__producto_ficha_model__Unidades] ?? 0)
                  .toDouble();
          final precioUnitario =
              (producto[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0)
                  .toDouble();

          // Si este producto tiene menos cuotas, se recalcula su precio de cuota
          double precioCuotaProducto =
              producto[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas]
                      ?.toDouble() ??
                  0;

          final cuotasProducto =
              (producto[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ?? 0).toInt();

          if (cuotasProducto < cantidadMaxCuotas && cantidadMaxCuotas > 0) {
            // Recalcular precio de cuota proporcional
            precioCuotaProducto =
                (precioUnitario / cantidadMaxCuotas).ceilToDouble();

            // Actualizamos el producto con estos nuevos valores
            producto[FIELD_NAME__catalogo__Cantidad_De_Cuotas] =
                cantidadMaxCuotas;
            producto[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] =
                precioCuotaProducto;
          }

          importeCuotaTotal += precioCuotaProducto * unidades;
          importeTotal += precioUnitario * unidades;
        }

        // Actualizar el bloque de pagos en base a los cálculos
        _pagos.actualizarPagos({
          FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas: cantidadMaxCuotas,
          FIELD_NAME__pago_ficha_model__Importe_Cuota: importeCuotaTotal,
          FIELD_NAME__pago_ficha_model__Importe_Total: importeTotal,
          FIELD_NAME__pago_ficha_model__Restante: importeTotal,
          FIELD_NAME__pago_ficha_model__Importe_Saldado: 0,
          FIELD_NAME__pago_ficha_model__Saldado: false,
          FIELD_NAME__pago_ficha_model__Cuotas_Pagas: 0,
        });
      }

      // --- Paso 2: construir el mapa completo y persistir ---
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
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca fichas en Firebase según el criterio de búsqueda actual.
  /// El criterio se corresponde con los textos del widget PopupResultadosBusqueda.
  Future<List<Map<String, dynamic>>> buscarFichasPorCriterio(
      String criterio) async {
    try {
      String campo = '';
      dynamic valor;

      final clienteActual = _cliente.obtenerCliente();
      final fechasActuales = _fechas.obtenerFechas();

      switch (criterio) {
        case TEXTO__resultados_widget__criterio__cliente_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__ID';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__ID];
          break;

        case TEXTO__resultados_widget__criterio__nombre_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Nombre';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Nombre];
          break;

        case TEXTO__resultados_widget__criterio__apellido_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Apellido';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Apellido];
          break;

        case TEXTO__resultados_widget__criterio__zona_seleccionada:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Zona';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Zona];
          break;

        case TEXTO__resultados_widget__criterio__fecha_de_venta:
          campo = 'Fechas.$FIELD_NAME__fecha_ficha_model__Fecha_De_Venta';
          valor = fechasActuales[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta];
          break;

        case TEXTO__resultados_widget__criterio__fecha_de_aviso:
          campo =
              'Fechas.$FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso';
          valor = fechasActuales[
              FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso];
          break;

        default:
          return [];
      }

      if (valor == null || (valor is String && valor.isEmpty)) {
        return [];
      }

      final fichas =
          await FichasServiciosFirebase.buscarFichasPorParametro(campo, valor);

      return fichas;
    } catch (e) {
      throw Exception('Error al buscar fichas por criterio: $e');
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
