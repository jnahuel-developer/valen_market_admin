import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:valen_market_admin/main_dev.dart' as app;
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CRUD Clientes - Firebase', () {
    String? idCliente;

    setUpAll(() async {
      // Inicia la app para asegurar que Firebase esté inicializado.
      app.main();
      await Future.delayed(const Duration(seconds: 5));
    });

    testWidgets('Agregar cliente', (tester) async {
      await ClientesServiciosFirebase.agregarClienteABDD(
        nombre: 'juan',
        apellido: 'perez',
        direccion: 'calle falsa 123',
        telefono: '123456789',
      );
      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      final agregado = clientes.firstWhere(
        (c) => c['Nombre'] == 'juan',
        orElse: () => {},
      );
      expect(agregado.isNotEmpty, true);
      idCliente = agregado['id'];
    });

/*
    testWidgets('Modificar cliente', (tester) async {
      expect(idCliente, isNotNull);
      await ClientesServiciosFirebase.actualizarClientePorId(
        idCliente!,
        {
          'Nombre': 'juan modificado',
          'Apellido': 'perez modificado',
          'Dirección': 'calle modificada',
          'Teléfono': '987654321',
        },
      );
      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      final modificado = clientes.firstWhere(
        (c) => c['Nombre'] == 'juan modificado',
        orElse: () => {},
      );
      expect(modificado.isNotEmpty, true);
    });
*/

    testWidgets('Eliminar cliente', (tester) async {
      expect(idCliente, isNotNull);
      await ClientesServiciosFirebase.eliminarClientePorId(idCliente!);
      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      final existe = clientes.any((c) => c['id'] == idCliente);
      expect(existe, false);
    });
  });
}
