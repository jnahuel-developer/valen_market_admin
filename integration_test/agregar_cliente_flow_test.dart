import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/main_dev.dart' as app;
import 'package:valen_market_admin/constants/keys.dart';

void main() {
  testWidgets('Flujo de agregar cliente completo', (tester) async {
    // Se inicia la app
    app.main();

    // Se genera una demora inicial para esperar que se inicialice el servicio de Firebase
    await tester.pump(const Duration(seconds: 2));

    /* -------------------------------------------- */
    /*              PANTALLA DE HOME                */
    /* -------------------------------------------- */

    // Se inician los widgets
    await tester.pumpAndSettle();

    // Se imprime el árbol para depuración
    // debugDumpApp();

    // Se verifica que se este en la pantalla de Home, buscando un widget clave
    expect(find.byKey(KEY__home_screen__boton__clientes), findsOneWidget);

    // Se presiona botón "Clientes" para pasar al menú de opciones del cliente
    await tester.tap(find.byKey(KEY__home_screen__boton__clientes));

    /* -------------------------------------------- */
    /*             PANTALLA DE CLIENTES             */
    /* -------------------------------------------- */

    await tester.pumpAndSettle();

    expect(find.byKey(KEY__clientes_screen__boton__agregar_cliente),
        findsOneWidget);

    await tester.tap(find.byKey(KEY__clientes_screen__boton__agregar_cliente));

    /* -------------------------------------------- */
    /*        PANTALLA DE AGREGAR CLIENTES          */
    /* -------------------------------------------- */

    await tester.pumpAndSettle();

    expect(find.byKey(KEY__agregar_clientes_screen__boton__agregar_cliente),
        findsOneWidget);

    // Se rellenan los ingresos con datos de un nuevo cliente
    await tester.enterText(
        find.byKey(KEY__agregar_clientes_screen__ingreso_datos__nombre),
        'juan');
    await tester.enterText(
        find.byKey(KEY__agregar_clientes_screen__ingreso_datos__apellido),
        'perez');
    await tester.enterText(
        find.byKey(KEY__agregar_clientes_screen__ingreso_datos__direccion),
        'falsa 123');
    await tester.enterText(
        find.byKey(KEY__agregar_clientes_screen__ingreso_datos__telefono),
        '123456789');

    await tester.pump(const Duration(milliseconds: 500));

    final buttonFinder =
        find.byKey(KEY__agregar_clientes_screen__boton__agregar_cliente);

    // Intenta hacer scroll hacia arriba hasta que el botón aparezca
    const maxScrolls = 10;
    var scrolls = 0;
    while (scrolls < maxScrolls && tester.any(buttonFinder) == false) {
      await tester.drag(
        find.byKey(KEY__agregar_clientes_screen__scrollview__principal),
        const Offset(0, -300), // scroll hacia arriba en píxeles
      );
      await tester.pumpAndSettle();
      scrolls++;
    }

    // Al final, espera que el botón sea visible
    expect(buttonFinder, findsOneWidget);

    // Se presiona botón para finalmente agregar el cliente a la base de datos
    await tester.tap(buttonFinder);

    /* -------------------------------------------- */
    /*             PANTALLA DE CLIENTES             */
    /* -------------------------------------------- */

    await tester.pumpAndSettle();

    expect(find.byKey(KEY__clientes_screen__boton__agregar_cliente),
        findsOneWidget);
  });
}
