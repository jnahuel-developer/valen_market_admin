// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/pagos_ficha_provider.dart';

void main() {
  group('\n ** PagosFichaProvider - Tests unitarios **\n', () {
    late PagosFichaProvider provider;

    setUp(() {
      provider = PagosFichaProvider();
      print(
          '\n ***** Nuevo test iniciado — Se crea una instancia vacía del Provider ***** ');
    });

    test('\n1) Creación inicial - Bloque vacío', () {
      final pagos = provider.obtenerPagos();
      print('Estado inicial: $pagos');
      expect(pagos[FIELD_NAME__pago_ficha_model__Importe_Total], 0);
      expect(
          (pagos[FIELD_NAME__pago_ficha_model__Pagos_Realizados] as List)
              .isEmpty,
          true);
      print('Bloque de pagos inicial correctamente vacío.');
      print('\n**************************************************');
    });

    test('\n2) Actualizar datos globales del bloque', () {
      final nuevosDatos = {
        FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas: 12,
        FIELD_NAME__pago_ficha_model__Importe_Total: 81000,
        FIELD_NAME__pago_ficha_model__Importe_Cuota: 6750,
      };
      provider.actualizarPagos(nuevosDatos);
      final pagos = provider.obtenerPagos();
      print('Bloque actualizado: $pagos');
      expect(pagos[FIELD_NAME__pago_ficha_model__Importe_Total], 81000);
      expect(pagos[FIELD_NAME__pago_ficha_model__Importe_Cuota], 6750);
      print('Datos globales actualizados correctamente.');
      print('\n**************************************************');
    });

    test('\n3) Agregar pagos individuales', () {
      provider.actualizarPagos({
        FIELD_NAME__pago_ficha_model__Importe_Total: 81000,
        FIELD_NAME__pago_ficha_model__Importe_Saldado: 0,
        FIELD_NAME__pago_ficha_model__Restante: 81000,
        FIELD_NAME__pago_ficha_model__Importe_Cuota: 6750,
        FIELD_NAME__pago_ficha_model__Cantidad_De_Cuotas: 12,
      });

      final pago1 = {
        FIELD_NAME__pago_item_model__Fecha: '2025-10-05T00:00:00-03:00',
        FIELD_NAME__pago_item_model__Medio: 'Efectivo',
        FIELD_NAME__pago_item_model__Monto: 6750,
      };

      final pago2 = {
        FIELD_NAME__pago_item_model__Fecha: '2025-11-05T00:00:00-03:00',
        FIELD_NAME__pago_item_model__Medio: 'Transferencia',
        FIELD_NAME__pago_item_model__Monto: 10000,
      };

      provider.agregarPago(pago1);
      provider.agregarPago(pago2);
      final pagos = provider.obtenerPagos();
      print('Pagos luego de agregar dos: $pagos');
      expect(
          (pagos[FIELD_NAME__pago_ficha_model__Pagos_Realizados] as List)
              .length,
          2);
      print('Pago agregado correctamente.');
      print('\n**************************************************');
    });

    test('\n4) Copiar bloque actual', () {
      final copia = provider.copiarPagos();
      print('Bloque copiado: $copia');
      expect(copia.isNotEmpty, true);
      expect(!identical(copia, provider.obtenerPagos()), true);
      print('Copia realizada correctamente.');
      print('\n**************************************************');
    });

    test('\n5) Limpieza completa', () {
      provider.limpiarPagos();
      final limpio = provider.obtenerPagos();
      print('Estado después de limpiar: $limpio');
      expect(
          (limpio[FIELD_NAME__pago_ficha_model__Pagos_Realizados] as List)
              .isEmpty,
          true);
      print('Bloque de pagos restablecido correctamente.');
      print('\n**************************************************');
    });
  });
}
