// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/cliente_ficha_provider.dart';

void main() {
  group('\n ** ClienteFichaProvider - Tests unitarios **\n', () {
    late ClienteFichaProvider provider;

    setUp(() {
      provider = ClienteFichaProvider();
      print(
          '\n ***** Nuevo test iniciado — Se crea una instancia vacía del Provider ***** ');
    });

    test('\n1) Creación inicial - Cliente vacío', () {
      final cliente = provider.obtenerCliente();
      print('Estado inicial del cliente: $cliente');

      expect(cliente[FIELD_NAME__cliente_ficha_model__UID], '');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Nombre], '');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Apellido], '');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Zona], '');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Direccion], '');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Telefono], '');
      print('Cliente inicial correctamente vacío.');
      print('\n**************************************************');
    });

    test('\n2) Actualización completa - Cargar datos de un cliente', () {
      final nuevoCliente = {
        FIELD_NAME__cliente_ficha_model__UID: '12345',
        FIELD_NAME__cliente_ficha_model__Nombre: 'Juan',
        FIELD_NAME__cliente_ficha_model__Apellido: 'Pérez',
        FIELD_NAME__cliente_ficha_model__Zona: 'Centro',
        FIELD_NAME__cliente_ficha_model__Direccion: 'Calle Falsa 123',
        FIELD_NAME__cliente_ficha_model__Telefono: '555-1234',
      };

      provider.actualizarCliente(nuevoCliente);
      final cliente = provider.obtenerCliente();

      print('Cliente actualizado: $cliente');

      expect(cliente, equals(nuevoCliente));
      print('Actualización completa realizada correctamente.');
      print('\n**************************************************');
    });

    test('\n3) Copia de cliente - Mantener mismos datos', () {
      final datosOriginales = {
        FIELD_NAME__cliente_ficha_model__UID: 'ABC123',
        FIELD_NAME__cliente_ficha_model__Nombre: 'María',
        FIELD_NAME__cliente_ficha_model__Apellido: 'Gómez',
        FIELD_NAME__cliente_ficha_model__Zona: 'Norte',
        FIELD_NAME__cliente_ficha_model__Direccion: 'Av. Siempre Viva 742',
        FIELD_NAME__cliente_ficha_model__Telefono: '555-9876',
      };

      provider.actualizarCliente(datosOriginales);
      final copia = provider.copiarCliente();

      print('Cliente original: $datosOriginales');
      print('Cliente copiado:  $copia');

      expect(copia, equals(datosOriginales));
      expect(!identical(copia, datosOriginales), true,
          reason: 'Debe ser una copia, no la misma referencia.');
      print('Copia creada correctamente, con independencia de la original.');
      print('\n**************************************************');
    });

    test('\n4) Modificación parcial - Solo un campo actualizado', () {
      final original = {
        FIELD_NAME__cliente_ficha_model__UID: '555',
        FIELD_NAME__cliente_ficha_model__Nombre: 'Laura',
        FIELD_NAME__cliente_ficha_model__Apellido: 'Méndez',
        FIELD_NAME__cliente_ficha_model__Zona: 'Oeste',
        FIELD_NAME__cliente_ficha_model__Direccion: 'Ruta 8 Km 45',
        FIELD_NAME__cliente_ficha_model__Telefono: '111-2222',
      };

      provider.actualizarCliente(original);

      final modificado = Map<String, dynamic>.from(original);
      modificado[FIELD_NAME__cliente_ficha_model__Direccion] = 'Ruta 8 Km 50';

      provider.actualizarCliente(modificado);
      final cliente = provider.obtenerCliente();

      print('Cliente después de modificación parcial: $cliente');

      expect(
          cliente[FIELD_NAME__cliente_ficha_model__Direccion], 'Ruta 8 Km 50');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Nombre], 'Laura');
      expect(cliente[FIELD_NAME__cliente_ficha_model__Apellido], 'Méndez');
      print('Modificación parcial aplicada correctamente.');
      print('\n**************************************************');
    });

    test('\n5) Limpieza - Cliente restablecido a valores vacíos', () {
      final datosPrevios = {
        FIELD_NAME__cliente_ficha_model__UID: 'XYZ999',
        FIELD_NAME__cliente_ficha_model__Nombre: 'Carlos',
        FIELD_NAME__cliente_ficha_model__Apellido: 'Rojas',
        FIELD_NAME__cliente_ficha_model__Zona: 'Sur',
        FIELD_NAME__cliente_ficha_model__Direccion: 'Callejón sin salida',
        FIELD_NAME__cliente_ficha_model__Telefono: '333-4444',
      };

      provider.actualizarCliente(datosPrevios);
      print('Cliente antes de limpiar: ${provider.obtenerCliente()}');

      provider.limpiarCliente();
      final clienteLimpio = provider.obtenerCliente();

      print('Cliente después de limpiar: $clienteLimpio');

      expect(clienteLimpio.values.every((v) => v == ''), true);
      print('Cliente restablecido correctamente a estado vacío.');
      print('\n**************************************************');
    });
  });
}
