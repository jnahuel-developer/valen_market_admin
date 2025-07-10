import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/environment.dart';

class AuthServiciosFirebaseWeb {
  static const _keyEmail = 'email';
  static const _keyAccessToken = 'access_token';

  static Future<bool> estaLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyEmail) &&
        FirebaseAuth.instance.currentUser != null;
  }

  static Future<String?> obtenerEmailLogueado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<bool> loginConGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: GOOGLE_SIGN_IN_CLIENT_ID_DEV,
        scopes: ['email', 'profile', 'openid'],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyEmail, googleUser.email);
      if (googleAuth.accessToken != null) {
        await prefs.setString(_keyAccessToken, googleAuth.accessToken!);
      }

      log('✅ Login exitoso y datos guardados en caché.');
      return true;
    } catch (e) {
      log('❌ Error en loginConGoogle: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    log('🟡 Sesión cerrada.');
  }
}
