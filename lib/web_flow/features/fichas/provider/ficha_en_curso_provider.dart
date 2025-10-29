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

  // ---------- Caches opcionales para UI ----------
  List<Map<String, dynamic>> _clientesCache = [];
  List<Map<String, dynamic>> _catalogoCache = [];

  List<Map<String, dynamic>> get clientesCache =>
      List.unmodifiable(_clientesCache);
  List<Map<String, dynamic>> get catalogoCache =>
      List.unmodifiable(_catalogoCache);

  /* -------------------------------------------------------------------- */
  /* Function: inicializarFichaLimpia                                     */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: All the controls on the tab will be reset, and the full */
  /*  list of clients and products will be loaded.                        */
  /* -------------------------------------------------------------------- */
  Future<void> inicializarFichaLimpia() async {
    try {
      // Se borran las variables internas para indicar que no hay cargada una ficha válida
      _idFichaActual = null;
      _hayFichaValida = false;

      // Se resetean los distintos sub providers que componen la ficha en curso
      _cliente.limpiarCliente();
      _fechas.limpiarFechas();
      _productos.limpiarProductos();
      _pagos.limpiarPagos();

      // Se toma la fecha actual apra la creación de la ficha
      final hoy = DateTime.now();

      // Se setea la fecha de creación al iniciar una ficha nueva
      _fechas.actualizarFechas({
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion:
            DateTime(hoy.year, hoy.month, hoy.day),
      });

      // Se carga la lista completa de clientes
      final clientes = await FichasServiciosFirebase.obtenerClientes();

      // Se carga la lista completa de productos
      final productosCatalogo =
          await FichasServiciosFirebase.obtenerProductosCatalogo();

      // Se cargan las listas en cache, para evitar el uso innecesario de consultas a Firebase
      _clientesCache = clientes;
      _catalogoCache = productosCatalogo;

      // Se emite la señal para que se actualicen los diversos controles afectados
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: inicializarDesdeFichaExistente                             */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Initialize the provider from a profile Map              */
  /* -------------------------------------------------------------------- */
  Future<void> inicializarDesdeFichaExistente(
      Map<String, dynamic> fichaMap) async {
    try {
      // Se obtiene el ID de la ficha pasada como parámetro
      _idFichaActual =
          fichaMap[FIELD_NAME__ficha_model__ID_De_Ficha]?.toString();

      // Se actualiza la variable en memoria para indicar si la ficha en curso es válida o no
      _hayFichaValida = _idFichaActual != null && _idFichaActual!.isNotEmpty;

      // Se carga el Map de datos del cliente
      final clienteMap = (fichaMap[FIELD_NAME__ficha_model__Cliente]
              as Map<String, dynamic>?) ??
          {};

      // Se carga el Map de datos de las fechas
      final fechasMap = (fichaMap[FIELD_NAME__ficha_model__Fechas]
              as Map<String, dynamic>?) ??
          {};

      // Se carga el Map de datos de la lista de productos
      final productosList =
          (fichaMap[FIELD_NAME__ficha_model__Productos] as List<dynamic>?) ??
              [];

      // Se carga el Map de datos de los pagos
      final pagosMap =
          (fichaMap[FIELD_NAME__ficha_model__Pagos] as Map<String, dynamic>?) ??
              {};

      // Se actualizan los datos del cliente en memoria
      _cliente.actualizarCliente(clienteMap);

      // Se actualizan los datos de las fechas en memoria
      _fechas.actualizarFechas(fechasMap);

      // Se limpia la lista de productos
      _productos.limpiarProductos();

      // Se actualizan los datos de los productos en memoria
      for (final p in productosList) {
        if (p is Map<String, dynamic>) {
          _productos.agregarProducto(p);
        }
      }

      // Se actualizan los datos de los pagos en memoria
      _pagos.actualizarPagos(pagosMap);

      // Se emite la señal para que se actualicen los diversos controles afectados
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarCacheClientes                                    */
  /* -------------------------------------------------------------------- */
  /* Description: Updates the local cache of clients from Firebase.       */
  /* -------------------------------------------------------------------- */
  Future<void> actualizarCacheClientes() async {
    try {
      final clientes = await FichasServiciosFirebase.obtenerClientes();
      _clientesCache = clientes;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarCacheProductos                                   */
  /* -------------------------------------------------------------------- */
  /* Description: Updates the local cache of products from Firebase.      */
  /* -------------------------------------------------------------------- */
  Future<void> actualizarCacheProductos() async {
    try {
      final productos =
          await FichasServiciosFirebase.obtenerProductosCatalogo();
      _catalogoCache = productos;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarCliente                                          */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  void actualizarCliente(Map<String, dynamic> nuevoCliente) {
    // Se actualizan los datos según el Map recibido
    _cliente.actualizarCliente(nuevoCliente);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarFechas                                           */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  void actualizarFechas(Map<String, dynamic> nuevasFechas) {
    // Se actualizan los datos según el Map recibido
    _fechas.actualizarFechas(nuevasFechas);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: obtenerProductoPorId                                       */
  /* -------------------------------------------------------------------- */
  /* Input: String idProducto                                             */
  /* Output: Map<String, dynamic>?                                        */
  /* -------------------------------------------------------------------- */
  /* Description: Returns the product map from the current ficha          */
  /*              corresponding to the provided product ID.               */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic>? obtenerProductoPorId(String idProducto) {
    // Se obtiene la lista completa de productos de la ficha en curso
    final productos = _productos.obtenerProductos();

    // Se busca el producto que coincida con el ID recibido
    final productoEncontrado = productos.firstWhere(
      (p) =>
          p[FIELD_NAME__producto_ficha_model__ID]?.toString() ==
          idProducto.toString(),
      orElse: () => {},
    );

    // Si no se encuentra el producto, se devuelve null
    if (productoEncontrado.isEmpty) return null;

    // Se devuelve una copia del producto encontrado para evitar mutaciones externas
    return Map<String, dynamic>.from(productoEncontrado);
  }

  /* -------------------------------------------------------------------- */
  /* Function: agregarProducto                                            */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  void agregarProducto(Map<String, dynamic> producto) {
    // Se toma el ID del producto para agregar
    final id = producto[FIELD_NAME__producto_ficha_model__ID]?.toString() ?? '';

    // Se verifica que no sea nulo
    if (id.isEmpty) {
      // Se indica error que genera la excepción
      throw Exception('Producto sin ID no puede ser agregado');
    }

    // Se actualizan los datos según el Map recibido
    _productos.agregarProducto(producto);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarProducto                                         */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  void actualizarProducto(String id, Map<String, dynamic> datosActualizados) {
    // Se actualizan los datos según el ID y Map recibidos
    _productos.actualizarProducto(id, datosActualizados);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: eliminarProducto                                           */
  /* -------------------------------------------------------------------- */
  /* Input: Product ID                                                    */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The product is deleted according to the provided ID     */
  /* -------------------------------------------------------------------- */
  void eliminarProducto(String id) {
    // Se elimina el producto según el ID suministrado
    _productos.eliminarProducto(id);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: actualizarPagos                                            */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  void actualizarPagos(Map<String, dynamic> pagosGlobales) {
    // Se actualizan los datos según el Map recibido
    _pagos.actualizarPagos(pagosGlobales);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: registrarPago                                              */
  /* -------------------------------------------------------------------- */
  /* Input: Map                                                           */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: The data is updated according to the received Map.      */
  /* -------------------------------------------------------------------- */
  Future<void> registrarPago(Map<String, dynamic> pagoItem) async {
    // Se valida que se hayan suministrado datos válidos
    if (pagoItem.isEmpty) return;

    // Se agrega el nuevo Map a memoria
    _pagos.agregarPago(pagoItem);

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }

  /* -------------------------------------------------------------------- */
  /* Function: obtenerFichaCompleta                                       */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: Map                                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Returns the complete Map of the record                  */
  /*  non-empty list of products.                                         */
  /* -------------------------------------------------------------------- */
  Map<String, dynamic> obtenerFichaCompleta() {
    return {
      FIELD_NAME__ficha_model__ID_De_Ficha: _idFichaActual,
      FIELD_NAME__ficha_model__Cliente: _cliente.obtenerCliente(),
      FIELD_NAME__ficha_model__Fechas: _fechas.obtenerFechas(),
      FIELD_NAME__ficha_model__Productos: _productos.obtenerProductos(),
      FIELD_NAME__ficha_model__Pagos: _pagos.obtenerPagos(),
    };
  }

  /* -------------------------------------------------------------------- */
  /* Function: esFichaValidaParaGuardar                                   */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: Bool                                                         */
  /* -------------------------------------------------------------------- */
  /* Description: It is verified that there is both a customer ID and a   */
  /*  non-empty list of products.                                         */
  /* -------------------------------------------------------------------- */
  bool esFichaValidaParaGuardar() {
    // Se obtienen los datos del cliente cargado
    final cliente = _cliente.obtenerCliente();

    // Se obtienen los datos de los productos cargados
    final productos = _productos.obtenerProductos();

    // Se verifica que exista el parámetro del ID del cliente
    final clienteTieneID =
        cliente[FIELD_NAME__cliente_ficha_model__ID]?.toString().isNotEmpty ??
            false;

    // Se verifica que la lista no esté vacía
    final hayProductos = productos.isNotEmpty;

    // Se devuelve la combinación de ambas verificaciones
    return clienteTieneID && hayProductos;
  }

  /* -------------------------------------------------------------------- */
  /* Function: guardarFichaEnFirebase                                     */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: First, it is verified if there is more than one product */
  /*  in the list, in order to update the installment amounts for each    */
  /*  product, unifying the number of installments for all products in    */
  /*  the record. Then, the financial data of the record is updated.      */
  /*  Finally, if the record already exists, the discounts are updated in */
  /*  Firebase. If it does not exist, it is created.                      */
  /*  non-empty list of products.                                         */
  /* -------------------------------------------------------------------- */
  Future<void> guardarFichaEnFirebase() async {
    try {
      // Se obtiene la lista de productos en la ficha
      final productos = _productos.obtenerProductos();

      // Se verifica que haya más de 1 producto en la lista. Sino, no tiene sentido procesarla
      if (productos.length > 1) {
        // Se toma el mayor valor de cuotas
        final cantidadMaxCuotas = productos.fold<int>(
            0,
            (max, p) =>
                p[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] > max
                    ? p[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas]
                    : max);

        // Variables para recalcular los montos
        double importeCuotaTotal = 0;
        double importeTotal = 0;

        // Se recorre la lista actualizando cada producto
        for (final producto in productos) {
          // Se toman las unidades del producto en la lista
          final unidades =
              producto[FIELD_NAME__producto_ficha_model__Unidades].toDouble();

          // Se toman el precio unitario del producto en la lista
          final precioUnitario =
              producto[FIELD_NAME__producto_ficha_model__Precio_Unitario]
                  .toDouble();

          // Se toma el precio de la cuota del producto en la lista
          double precioCuotaProducto =
              producto[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas]
                  .toDouble();

          // Se toma la cantidad de cuotas del producto en la lista
          final cuotasProducto =
              producto[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas]
                  .toInt();

          // Se verifica si la cantidad de cuotas del producto es menor a la máxima
          if (cuotasProducto < cantidadMaxCuotas) {
            // Se recalcula el precio de cuota proporcionalmente
            precioCuotaProducto =
                (precioUnitario / cantidadMaxCuotas).ceilToDouble();

            // Se actualiza la cantidad de cuotas del producto
            producto[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] =
                cantidadMaxCuotas;
            // Se actualiza el precio unitario de la cuota del producto
            producto[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] =
                precioCuotaProducto;
          }

          // Se actualizan el total de la ficha y el total de las cuotas
          importeCuotaTotal += precioCuotaProducto * unidades;
          importeTotal += precioUnitario * unidades;
        }

        // Se actualizan los datos financieros de la ficha
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

      // Se obtiene el Map completo de la ficha para usar les métodos de Firebase
      final fichaMap = obtenerFichaCompleta();

      // Se verifica si existe una ficha válida, con lo que sólo habría que actualizala
      if (_hayFichaValida &&
          _idFichaActual != null &&
          _idFichaActual!.isNotEmpty) {
        // Se pasa el Map completo de la ficha para actualizarla en Firebase
        await FichasServiciosFirebase.actualizarFicha(
            _idFichaActual!, fichaMap);
      }
      // Caso contrario, se debe crear una nueva ficha
      else {
        // Se pasa el Map completo de la ficha para crearla en Firebase
        final nuevoId = await FichasServiciosFirebase.crearFicha(fichaMap);

        // Se actualizan las variables internas para indicar que existe una ficha válida
        _idFichaActual = nuevoId;
        _hayFichaValida = true;
      }

      // Se emite la señal para que se actualicen los diversos controles afectados
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: buscarFichasPorCriterio                                    */
  /* -------------------------------------------------------------------- */
  /* Input: selected criterion                                            */
  /* Output: list of records                                              */
  /* -------------------------------------------------------------------- */
  /* Description: Returns the list of records filtered according to the   */
  /*  selected criterion.                                                 */
  /* -------------------------------------------------------------------- */
  Future<List<Map<String, dynamic>>> buscarFichasPorCriterio(
      String criterio) async {
    try {
      String campo = '';
      dynamic valor;

      // Se obtienen los datos del cliente cargado en la ficha
      final clienteActual = _cliente.obtenerCliente();

      // Se obtienen los datos de las fechas cargadas en la ficha
      final fechasActuales = _fechas.obtenerFechas();

      // Se cargan el campo y valor segun el criterio seleccionado para obtener la lista
      switch (criterio) {
        // Se deben buscar las fichas por el ID del cliente cargado
        case TEXTO__resultados_widget__criterio__cliente_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__ID';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__ID];
          break;

        // Se deben buscar las fichas por el nombre del cliente cargado
        case TEXTO__resultados_widget__criterio__nombre_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Nombre';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Nombre];
          break;

        // Se deben buscar las fichas por el apellido del cliente cargado
        case TEXTO__resultados_widget__criterio__apellido_seleccionado:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Apellido';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Apellido];
          break;

        // Se deben buscar las fichas por la zona del cliente cargado
        case TEXTO__resultados_widget__criterio__zona_seleccionada:
          campo = 'Cliente.$FIELD_NAME__cliente_ficha_model__Zona';
          valor = clienteActual[FIELD_NAME__cliente_ficha_model__Zona];
          break;

        // Se deben buscar las fichas por la fecha de venta cargada
        case TEXTO__resultados_widget__criterio__fecha_de_venta:
          campo = 'Fechas.$FIELD_NAME__fecha_ficha_model__Fecha_De_Venta';
          valor = fechasActuales[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta];
          break;

        // Se deben buscar las fichas por la fecha de próximo aviso cargada
        case TEXTO__resultados_widget__criterio__fecha_de_aviso:
          campo =
              'Fechas.$FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso';
          valor = fechasActuales[
              FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso];
          break;

        // Si no se usó un criterio válido, se devuelve una lista vacía
        default:
          return [];
      }

      // Se verifica que se haya cargado un valor válido
      if (valor == null || (valor is String && valor.isEmpty)) {
        // Se devuelve una lista nula si no se cargo un valor válido
        return [];
      }

      // Se leen los registros según el criterio y valor seleccionado
      final fichas =
          await FichasServiciosFirebase.buscarFichasPorParametro(campo, valor);

      // Se devuelve la lista obtenida desde Firebase
      return fichas;
    } catch (e) {
      throw Exception('Error al buscar fichas por criterio: $e');
    }
  }

  /* -------------------------------------------------------------------- */
  /* Function: limpiarFicha                                               */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Clears the current record                               */
  /* -------------------------------------------------------------------- */
  void limpiarFicha() {
    _idFichaActual = null;
    _hayFichaValida = false;
    _cliente.limpiarCliente();
    _fechas.limpiarFechas();
    _productos.limpiarProductos();
    _pagos.limpiarPagos();

    // Se emite la señal para que se actualicen los diversos controles afectados
    notifyListeners();
  }
}
