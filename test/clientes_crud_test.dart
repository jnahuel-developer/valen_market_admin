import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/main_dev.dart' as app;
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';

void main() {
  group('CRUD Clientes - Firebase', () {
    // Inicia la app para asegurar que Firebase esté inicializado.
    setUpAll(() async {
      app.main();
      await Future.delayed(const Duration(seconds: 5));
    });

    test('Test CRUD completo de ClientesServiciosFirebase', () async {
      // 1) Eliminar todos los clientes
      await ClientesServiciosFirebase.eliminarTodosLosClientes();

      // 2) Obtener la lista completa de clientes y debe estar vacía
      final clientesIniciales =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      expect(clientesIniciales.isEmpty, true);

      // 3) Agregar un registro nuevo
      const nombre = 'juan';
      const apellido = 'perez';
      const direccionOriginal = 'calle falsa 123';
      const telefonoOriginal = '555-1234';

      await ClientesServiciosFirebase.agregarClienteABDD(
        nombre: nombre,
        apellido: apellido,
        direccion: direccionOriginal,
        telefono: telefonoOriginal,
      );

      // 4) Buscar el cliente por nombre y apellido -> debe devolver un ID válido
      final id = await ClientesServiciosFirebase.obtenerIdPorNombreYApellido(
        nombre: nombre,
        apellido: apellido,
      );
      expect(id, isNotNull);

      // 5) Actualizar el registro con nueva dirección y teléfono
      const nuevaDireccion = 'avenida siempre viva 742';
      const nuevoTelefono = '555-5678';

      await ClientesServiciosFirebase.actualizarClientePorId(
        id!,
        nombre: nombre,
        apellido: apellido,
        direccion: nuevaDireccion,
        telefono: nuevoTelefono,
      );

      // 6) Leer el registro actualizado y verificar dirección y teléfono
      final clienteActualizado =
          await ClientesServiciosFirebase.obtenerClientePorId(id);
      expect(clienteActualizado, isNotNull);
      expect(clienteActualizado!['Dirección'], nuevaDireccion);
      expect(clienteActualizado['Teléfono'], nuevoTelefono);

      // 7) Eliminar el registro por ID
      await ClientesServiciosFirebase.eliminarClientePorId(id);

      // 8) Leer todos los clientes y debe estar vacío nuevamente
      final clientesFinales =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      expect(clientesFinales.isEmpty, true);
    });
  });
}
