// --------------------------------------------------------------------------------------------
// CAMPOS EN LA COLECCIÓN DE CLIENTES
// --------------------------------------------------------------------------------------------

// Datos de la colección del cliente
const String FIELD_NAME__clientes__Nombre_De_La_Coleccion = 'BDD_Clientes';
const String FIELD_NAME__clientes__ID_Del_Cliente = 'ID';
const String FIELD_NAME__clientes__Nombre_Del_Cliente = 'Nombre';
const String FIELD_NAME__clientes__Apellido_Del_Cliente = 'Apellido';
const String FIELD_NAME__clientes__Zona_Del_Cliente = 'Zona';
const String FIELD_NAME__clientes__Direccion_Del_Cliente = 'Dirección';
const String FIELD_NAME__clientes__Telefono_Del_Cliente = 'Teléfono';
const String FIELD_NAME__clientes__Nombre_Compuesto_Del_Cliente =
    'NombreCompleto';

// --------------------------------------------------------------------------------------------
// CAMPOS EN LA COLECCIÓN DE CONFIGURACIÓN
// --------------------------------------------------------------------------------------------

// Datos del número de la última ficha asignada
const String FIELD_NAME__config__Nombre_De_La_Coleccion = 'config';
const String FIELD_NAME__config__Nombre_Del_Documento = 'fichas';
const String FIELD_NAME__config__Ultimo_Numero_De_Ficha = 'UltimoNroDeFicha';

// --------------------------------------------------------------------------------------------
// CAMPOS EN LA COLECCIÓN DE CATÁLOGO
// --------------------------------------------------------------------------------------------

const String FIELD_NAME__catalogo__Nombre_De_La_Coleccion = 'BDD_Catalogo';

// Datos de la colección del cliente
const String FIELD_NAME__catalogo__ID_Del_Producto = 'ID';
const String FIELD_NAME__catalogo__Nombre_Del_Producto = 'NombreDelProducto';
const String FIELD_NAME__catalogo__Descripcion_Corta = 'DescripcionCorta';
const String FIELD_NAME__catalogoDescripcionCorta__Descripcion_Larga =
    'DescripcionLarga';
const String FIELD_NAME__catalogo__Precio_Unitario = 'Precio';
const String FIELD_NAME__catalogo__Cantidad_De_Cuotas = 'CantidadDeCuotas';
const String FIELD_NAME__catalogo__Precio_De_Las_Cuotas = 'PrecioDeLasCuotas';
const String FIELD_NAME__catalogo__Stock = 'Stock';
const String FIELD_NAME__catalogo__Link_De_La_Foto = 'LinkDeLaFoto';
const String FIELD_NAME__catalogo__Fecha_De_Creacion = 'FechaDeCreacion';

// --------------------------------------------------------------------------------------------
// CAMPOS EN LA COLECCIÓN DE FICHAS
// --------------------------------------------------------------------------------------------

const String FIELD_NAME__ficha__Nombre_De_La_Coleccion = 'BDD_Fichas';

// Datos de la ficha o nombre de las colecciones
const String FIELD_NAME__ficha_model__ID_De_Ficha = 'ID';
const String FIELD_NAME__ficha_model__Numero_De_Ficha = 'NumeroDeFicha';
const String FIELD_NAME__ficha_model__Productos = 'Productos';
const String FIELD_NAME__ficha_model__Cantidad_De_Productos =
    'CantidadDeProductos';
const String FIELD_NAME__ficha_model__Cliente = 'Cliente';
const String FIELD_NAME__ficha_model__Fechas = 'Fechas';
const String FIELD_NAME__ficha_model__Pagos = 'Pagos';

// Datos de la colección del cliente
const String FIELD_NAME__cliente_ficha_model__ID =
    FIELD_NAME__clientes__ID_Del_Cliente;
const String FIELD_NAME__cliente_ficha_model__Nombre =
    FIELD_NAME__clientes__Nombre_Del_Cliente;
const String FIELD_NAME__cliente_ficha_model__Apellido =
    FIELD_NAME__clientes__Apellido_Del_Cliente;
const String FIELD_NAME__cliente_ficha_model__Zona =
    FIELD_NAME__clientes__Zona_Del_Cliente;
const String FIELD_NAME__cliente_ficha_model__Direccion =
    FIELD_NAME__clientes__Direccion_Del_Cliente;
const String FIELD_NAME__cliente_ficha_model__Telefono =
    FIELD_NAME__clientes__Telefono_Del_Cliente;

// Datos de la colección de fechas
const String FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion =
    'FechaDeCreacion';
const String FIELD_NAME__fecha_ficha_model__Fecha_De_Venta = 'FechaDeVenta';
const String FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso =
    'FechaDeProximoAviso';

// Datos del ítem de pago
const String FIELD_NAME__pago_item_model__Fecha = 'Fecha';
const String FIELD_NAME__pago_item_model__Medio = 'Medio';
const String FIELD_NAME__pago_item_model__Monto = 'Monto';

// Datos de la colección de pago
const String FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas =
    'CantidadDeCuotas';
const String FIELD_NAME__pago_ficha_model__Cuotas_Pagas = 'CuotasPagas';
const String FIELD_NAME__pago_ficha_model__Restante = 'Restante';
const String FIELD_NAME__pago_ficha_model__Saldado = 'Saldado';
const String FIELD_NAME__pago_ficha_model__Importe_Saldado = 'ImporteSaldado';
const String FIELD_NAME__pago_ficha_model__Importe_Cuota = 'ImporteCuota';
const String FIELD_NAME__pago_ficha_model__Importe_Total = 'ImporteTotal';
const String FIELD_NAME__pago_ficha_model__Pagos_Realizados = 'PagosRealizados';

// Datos de la colección de productos
const String FIELD_NAME__producto_ficha_model__ID = 'ID';
const String FIELD_NAME__producto_ficha_model__Nombre =
    FIELD_NAME__catalogo__Nombre_Del_Producto;
const String FIELD_NAME__producto_ficha_model__Precio_Unitario =
    FIELD_NAME__catalogo__Precio_Unitario;
const String FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas =
    FIELD_NAME__catalogo__Precio_De_Las_Cuotas;
const String FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas =
    FIELD_NAME__catalogo__Cantidad_De_Cuotas;
const String FIELD_NAME__producto_ficha_model__Unidades = 'Unidades';

const String FIELD_NAME__producto_ficha_model__Stock =
    FIELD_NAME__catalogo__Stock;

const String FIELD_NAME__producto_ficha_model__Link_De_La_Foto =
    FIELD_NAME__catalogo__Link_De_La_Foto;
