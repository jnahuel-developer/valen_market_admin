import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/producto_ficha_provider.dart';

void main() {
  group('\n ** ProductosFichaProvider - Tests unitarios **\n', () {
    late ProductosFichaProvider provider;

    setUp(() {
      provider = ProductosFichaProvider();
      debugPrint(
          '\n ***** Nuevo test iniciado — Se crea una instancia vacía del Provider ***** ');
    });

    test('\n1) Creación inicial - Lista vacía', () {
      final productos = provider.obtenerProductos();
      debugPrint('Estado inicial de los productos: $productos');
      expect(productos.isEmpty, true);
      debugPrint('Lista de productos inicial correctamente vacía.');
      debugPrint('\n**************************************************');
    });

    test('\n2) Agregar productos - Dos productos cargados', () {
      final p1 = {
        FIELD_NAME__producto_ficha_model__ID: 'EXs51qPRfvggQ0Jftt6f',
        FIELD_NAME__producto_ficha_model__Nombre: 'Agujereadora',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 18000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 1500,
        FIELD_NAME__producto_ficha_model__Unidades: 2,
      };

      final p2 = {
        FIELD_NAME__producto_ficha_model__ID: 'MROSzBJf0bJHnTbin1ZU',
        FIELD_NAME__producto_ficha_model__Nombre: 'Reloj inteligente',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 45000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 3750,
        FIELD_NAME__producto_ficha_model__Unidades: 1,
      };

      provider.agregarProducto(p1);
      provider.agregarProducto(p2);

      final productos = provider.obtenerProductos();
      debugPrint('Productos cargados: $productos');
      expect(productos.length, 2);
      debugPrint('Carga de productos realizada correctamente.');
      debugPrint('\n**************************************************');
    });

    test('\n3) Actualizar producto existente - Cambio de unidades', () {
      final p1 = {
        FIELD_NAME__producto_ficha_model__ID: 'EXs51qPRfvggQ0Jftt6f',
        FIELD_NAME__producto_ficha_model__Nombre: 'Agujereadora',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 18000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 1500,
        FIELD_NAME__producto_ficha_model__Unidades: 2,
      };

      provider.agregarProducto(p1);

      final actualizacion = {
        FIELD_NAME__producto_ficha_model__Unidades: 3,
      };

      provider.actualizarProducto('EXs51qPRfvggQ0Jftt6f', actualizacion);

      final productos = provider.obtenerProductos();
      debugPrint('Productos después de la actualización: $productos');
      expect(productos.first[FIELD_NAME__producto_ficha_model__Unidades], 3);
      debugPrint('Actualización parcial aplicada correctamente.');
      debugPrint('\n**************************************************');
    });

    test('\n4) Eliminar producto - Quitar por UID', () {
      final p = {
        FIELD_NAME__producto_ficha_model__ID: 'DEL001',
        FIELD_NAME__producto_ficha_model__Nombre: 'Secador de pelo',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 25000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 2000,
        FIELD_NAME__producto_ficha_model__Unidades: 1,
      };

      provider.agregarProducto(p);
      debugPrint('Antes de eliminar: ${provider.obtenerProductos()}');

      provider.eliminarProducto('DEL001');
      final productos = provider.obtenerProductos();

      debugPrint('Después de eliminar: $productos');
      expect(
          productos.any(
              (item) => item[FIELD_NAME__producto_ficha_model__ID] == 'DEL001'),
          false);
      debugPrint('Producto eliminado correctamente.');
      debugPrint('\n**************************************************');
    });

    test('\n5) Limpieza completa - Lista vacía nuevamente', () {
      final p = {
        FIELD_NAME__producto_ficha_model__ID: 'A001',
        FIELD_NAME__producto_ficha_model__Nombre: 'Batidora',
        FIELD_NAME__producto_ficha_model__Precio_Unitario: 12000,
        FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: 1000,
        FIELD_NAME__producto_ficha_model__Unidades: 1,
      };

      provider.agregarProducto(p);
      debugPrint('Antes de limpiar: ${provider.obtenerProductos()}');

      provider.limpiarProductos();
      final productosLimpios = provider.obtenerProductos();

      debugPrint('Después de limpiar: $productosLimpios');
      expect(productosLimpios.isEmpty, true);
      debugPrint('Lista de productos restablecida correctamente.');
      debugPrint('\n**************************************************');
    });
  });
}
