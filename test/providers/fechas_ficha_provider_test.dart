import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/fechas_ficha_provider.dart';

void main() {
  group('\n ** FechasFichaProvider - Tests unitarios **\n', () {
    late FechasFichaProvider provider;

    setUp(() {
      provider = FechasFichaProvider();
      debugPrint(
          '\n ***** Nuevo test iniciado — Se crea una instancia vacia del Provider ***** ');
    });

    test('\n1) Creacion inicial - Fechas vacias', () {
      final fechas = provider.obtenerFechas();
      debugPrint('Estado inicial de las fechas: $fechas');

      expect(fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion], '');
      expect(fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta], '');
      expect(fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso], '');
      debugPrint('Fechas iniciales correctamente vacias.');
      debugPrint('\n**************************************************');
    });

    test('\n2) Actualizacion completa - Cargar fechas', () {
      final nuevasFechas = {
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '2025-01-10',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '2025-02-15',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '2025-03-01',
      };

      provider.actualizarFechas(nuevasFechas);
      final fechas = provider.obtenerFechas();

      debugPrint('Fechas actualizadas: $fechas');
      expect(fechas, equals(nuevasFechas));
      debugPrint('Actualizacion completa realizada correctamente.');
      debugPrint('\n**************************************************');
    });

    test('\n3) Copia de fechas - Mantener mismos datos', () {
      final datosOriginales = {
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '2024-12-10',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '2025-01-05',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '2025-02-01',
      };

      provider.actualizarFechas(datosOriginales);
      final copia = provider.copiarFechas();

      debugPrint('Fechas originales: $datosOriginales');
      debugPrint('Fechas copiadas:  $copia');

      expect(copia, equals(datosOriginales));
      expect(!identical(copia, datosOriginales), true,
          reason: 'Debe ser una copia independiente.');
      debugPrint(
          'Copia creada correctamente, con independencia de la original.');
      debugPrint('\n**************************************************');
    });

    test('\n4) Modificacion parcial - Solo una fecha actualizada', () {
      final originales = {
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '2025-01-01',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '2025-01-10',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '2025-01-20',
      };

      provider.actualizarFechas(originales);

      final modificadas = Map<String, dynamic>.from(originales);
      modificadas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta] = '2025-01-15';

      provider.actualizarFechas(modificadas);
      final fechas = provider.obtenerFechas();

      debugPrint('Fechas despues de modificacion parcial: $fechas');

      expect(
          fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta], '2025-01-15');
      expect(fechas[FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion],
          '2025-01-01');
      debugPrint('Modificacion parcial aplicada correctamente.');
      debugPrint('\n**************************************************');
    });

    test('\n5) Limpieza - Fechas restablecidas a valores vacios', () {
      final previas = {
        FIELD_NAME__fecha_ficha_model__Fecha_De_Creacion: '2024-12-01',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Venta: '2024-12-10',
        FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso: '2024-12-20',
      };

      provider.actualizarFechas(previas);
      debugPrint('Fechas antes de limpiar: ${provider.obtenerFechas()}');

      provider.limpiarFechas();
      final fechasLimpias = provider.obtenerFechas();

      debugPrint('Fechas despues de limpiar: $fechasLimpias');
      expect(fechasLimpias.values.every((v) => v == ''), true);
      debugPrint('Fechas restablecidas correctamente a estado vacio.');
      debugPrint('\n**************************************************');
    });
  });
}
