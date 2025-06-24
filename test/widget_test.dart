import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/app/app.dart';

void main() {
  testWidgets('La app muestra pantalla de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Registrarse'),
        findsNothing); // Asumiendo que solo hay login al inicio
  });
}
