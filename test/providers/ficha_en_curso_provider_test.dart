import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

void main() {
  late FichaEnCursoProvider provider;

  setUp(() {
    provider = FichaEnCursoProvider();
    debugPrint(
        '\n🧩 --- Nuevo test: Se inicializa un FichaEnCursoProvider limpio ---');
  });

  tearDown(() {
    provider.limpiarFicha();
  });

  group('1) Inicialización y estructura básica', () {
    test('Debe iniciar con una ficha vacía', () {
      final ficha = provider.obtenerFichaCompleta();
      debugPrint('Ficha inicial: $ficha');

      expect(ficha[FIELD_NAME__ficha_model__Cliente], isNotNull);
      expect(ficha[FIELD_NAME__ficha_model__Fechas], isNotNull);
      expect(ficha[FIELD_NAME__ficha_model__Productos], isList);
      expect(ficha[FIELD_NAME__ficha_model__Pagos], isNotNull);
      debugPrint('\n**************************************************');
    });

    test('Limpiar ficha debe reiniciar todos los subproviders', () {
      provider.limpiarFicha();
      final ficha = provider.obtenerFichaCompleta();
      expect(ficha[FIELD_NAME__ficha_model__Productos], isEmpty);
      debugPrint('\n**************************************************');
    });
  });

  group('2) Carga de cliente', () {
    test('Debe poder cargar un cliente completo desde un Map', () {
      final clienteMap = {
        FIELD_NAME__cliente_ficha_model__ID: '75298AzAX4UeaGCvm0Wl',
        FIELD_NAME__cliente_ficha_model__Nombre: 'Fabian',
        FIELD_NAME__cliente_ficha_model__Apellido: 'Gertie',
        FIELD_NAME__cliente_ficha_model__Zona: 'Norte',
        FIELD_NAME__cliente_ficha_model__Direccion: 'Calle falsa 123',
        FIELD_NAME__cliente_ficha_model__Telefono: '1122334455',
      };

      provider.actualizarCliente(clienteMap);
      final ficha = provider.obtenerFichaCompleta();

      debugPrint('Cliente cargado en ficha: $ficha');

      expect(
        ficha[FIELD_NAME__ficha_model__Cliente]
            [FIELD_NAME__cliente_ficha_model__Nombre],
        equals('Fabian'),
      );

      debugPrint('\n**************************************************');
    });
  });

  group('3) Carga de fechas', () {
    test('Debe actualizar las fechas correctamente', () {
      final fechas = {
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '2025-10-10',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '2025-09-28',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '2025-10-24',
      };

      provider.actualizarFechas(fechas);
      final ficha = provider.obtenerFichaCompleta();

      debugPrint('Fechas cargadas en ficha: $ficha');

      expect(
        ficha[FIELD_NAME__ficha_model__Fechas]
            [FIELD_NAME__fecha_ficha_model__Fecha_De_Venta],
        equals('2025-09-28'),
      );

      debugPrint('\n**************************************************');
    });
  });

  group('4) Manejo de productos', () {
    test('Debe agregar un producto a la lista', () {
      final producto = {
        FIELD_NAME__producto_ficha_model__ID: 'EXs51qPRfvggQ0Jftt6f',
        FIELD_NAME__producto_ficha_model__Nombre: 'Agujereadora',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 18000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 1500,
        FIELD_NAME__producto_ficha_model__Unidades: 2,
      };

      provider.agregarProducto(producto);
      final ficha = provider.obtenerFichaCompleta();
      final productos = ficha[FIELD_NAME__ficha_model__Productos] as List;

      debugPrint('Productos en ficha: $ficha');

      expect(productos.length, 1);
      expect(productos.first[FIELD_NAME__producto_ficha_model__Nombre],
          equals('Agujereadora'));

      debugPrint('\n**************************************************');
    });

    test('Debe modificar y eliminar un producto', () {
      final producto = {
        FIELD_NAME__producto_ficha_model__ID: 'MROSzBJf0bJHnTbin1ZU',
        FIELD_NAME__producto_ficha_model__Nombre: 'Reloj inteligente',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 45000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 3750,
        FIELD_NAME__producto_ficha_model__Unidades: 1,
      };

      // Agregar producto inicial
      provider.agregarProducto(producto);
      var ficha = provider.obtenerFichaCompleta();
      debugPrint('Productos agregados: $ficha');

      // Actualizar unidades del mismo producto
      provider.actualizarProducto(
        'MROSzBJf0bJHnTbin1ZU',
        {
          ...producto,
          FIELD_NAME__producto_ficha_model__Unidades: 23,
        },
      );

      ficha = provider.obtenerFichaCompleta();
      debugPrint('Productos modificados: $ficha');

      // Validar modificación
      final productosModificados =
          ficha[FIELD_NAME__ficha_model__Productos] as List;
      expect(
          productosModificados
              .first[FIELD_NAME__producto_ficha_model__Unidades],
          equals(23));

      // Eliminar producto por ID
      provider.eliminarProducto('MROSzBJf0bJHnTbin1ZU');
      final productosEliminados = provider
          .obtenerFichaCompleta()[FIELD_NAME__ficha_model__Productos] as List;

      debugPrint(
          'Productos después de eliminar: ${provider.obtenerFichaCompleta()}');

      expect(productosEliminados, isEmpty);

      debugPrint('\n**************************************************');
    });
  });

  group('5) Manejo de pagos', () {
    test('Debe registrar un pago y recalcular los datos financieros', () async {
      var ficha = provider.obtenerFichaCompleta();
      provider.limpiarFicha();

      final pago = {
        FIELD_NAME__pago_item_model__Fecha: '2025-10-14',
        FIELD_NAME__pago_item_model__Medio: 'Transferencia',
        FIELD_NAME__pago_item_model__Monto: 10000,
      };

      await provider.registrarPago(pago);

      ficha = provider.obtenerFichaCompleta();
      final pagos = ficha[FIELD_NAME__ficha_model__Pagos]
          [FIELD_NAME__pago_ficha_model__Pagos_Realizados] as List;

      debugPrint('Pagos realizados: $ficha');

      expect(pagos.length, 1);
      expect(pagos.first[FIELD_NAME__pago_item_model__Monto], equals(10000));

      debugPrint('\n**************************************************');
    });
  });

  group('6) Ficha completa', () {
    test('Debe generar un Map completo coherente', () {
      final ficha = provider.obtenerFichaCompleta();
      debugPrint('Ficha final completa: $ficha');

      expect(ficha.containsKey(FIELD_NAME__ficha_model__Cliente), isTrue);
      expect(ficha.containsKey(FIELD_NAME__ficha_model__Fechas), isTrue);
      expect(ficha.containsKey(FIELD_NAME__ficha_model__Productos), isTrue);
      expect(ficha.containsKey(FIELD_NAME__ficha_model__Pagos), isTrue);

      debugPrint('\n**************************************************');
    });
  });
}
