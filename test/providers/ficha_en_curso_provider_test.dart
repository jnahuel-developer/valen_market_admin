import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/cliente_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/pago_item_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/producto_ficha_model.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/fechas_ficha_model.dart';

void main() {
  group('📦 FichaEnCursoProvider - pruebas de lógica interna', () {
    late FichaEnCursoProvider fichaProvider;

    setUp(() {
      fichaProvider = FichaEnCursoProvider();
    });

    test('Inicializa correctamente los subproviders', () {
      expect(fichaProvider.cliente.cliente.uid, '');
      expect(fichaProvider.pagos.pagos.pagos, isEmpty);
      expect(fichaProvider.productos.productos, isEmpty);
      expect(fichaProvider.fechas.fechas.fechaDeCreacion, isNotNull);
    });

    test('Permite asignar un cliente y recuperarlo', () {
      final cliente = ClienteFichaModel(
        uid: '123',
        nombre: 'Juan',
        apellido: 'Pérez',
        zona: 'Centro',
        direccion: 'Calle Falsa 123',
        telefono: '555-1234',
      );

      fichaProvider.actualizarCliente(cliente);

      expect(fichaProvider.cliente.cliente.nombre, 'Juan');
      expect(fichaProvider.cliente.cliente.apellido, 'Pérez');
    });

    test('Permite agregar productos a la ficha', () {
      final producto1 = ProductoFichaModel(
        uid: 'p1',
        nombre: 'Yerba Mate',
        cantidad: 2,
        precioUnitario: 1200,
      );

      final producto2 = ProductoFichaModel(
        uid: 'p2',
        nombre: 'Azúcar',
        cantidad: 1,
        precioUnitario: 800,
      );

      fichaProvider.agregarProducto(producto1);
      fichaProvider.agregarProducto(producto2);

      expect(fichaProvider.productos.productos.length, 2);
      expect(fichaProvider.productos.productos.first.nombre, 'Yerba Mate');
    });

    test('Calcula totales correctamente al agregar productos', () {
      fichaProvider.agregarProducto(ProductoFichaModel(
        uid: 'x',
        nombre: 'Yerba',
        cantidad: 2,
        precioUnitario: 1000,
      ));

      fichaProvider.recalcularTotales();

      expect(fichaProvider.totalGeneral, 2000);
    });

    test('Registra pagos y recalcula el saldo', () {
      fichaProvider.totalGeneral = 3000;

      fichaProvider.pagos.agregarPago(
        PagoItemModel(
          idPago: 'p1',
          monto: 1000,
          fecha: DateTime.now(),
          metodo: 'Efectivo',
        ),
      );

      fichaProvider.pagos.agregarPago(
        PagoItemModel(
          idPago: 'p2',
          monto: 2000,
          fecha: DateTime.now(),
          metodo: 'Tarjeta',
        ),
      );

      expect(fichaProvider.pagos.pagos.importeSaldado, 3000);
      expect(fichaProvider.pagos.pagos.restante, 0);
      expect(fichaProvider.pagos.pagos.saldado, isTrue);
    });

    test('Permite actualizar las fechas de la ficha', () {
      final nuevasFechas = FechasFichaModel(
        fechaDeCreacion: DateTime(2024, 1, 1),
        venta: DateTime(2024, 2, 1),
        proximoAviso: DateTime(2024, 3, 1),
      );

      fichaProvider.actualizarFechas(nuevasFechas);

      expect(fichaProvider.fechas.fechas.venta, DateTime(2024, 2, 1));
    });

    test('Permite limpiar completamente la ficha en curso', () {
      fichaProvider.limpiarFicha();

      expect(fichaProvider.cliente.cliente.nombre, '');
      expect(fichaProvider.productos.productos, isEmpty);
      expect(fichaProvider.pagos.pagos.pagos, isEmpty);
    });
  });
}
