import 'package:flutter_test/flutter_test.dart';
import 'package:valen_market_admin/features/auth/services/auth_service.dart';

void main() {
  final authService = AuthService();

  test('Registro y login exitoso', () async {
    const email = 'test@example.com';
    const password = 'password123';

    try {
      await authService.register(email, password);
      await authService.signIn(email, password);
      expect(true, true);
    } catch (e) {
      fail("Error durante login: $e");
    }
  });
}
