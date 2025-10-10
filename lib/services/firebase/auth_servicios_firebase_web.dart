import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<String?> obtenerUidActual() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<bool> loginConGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: GOOGLE_SIGN_IN_CLIENT_ID_DEV,
        scopes: ['email', 'profile', 'openid'],
      );

      // 🔍 Intentar login silencioso
      GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();

      // ❗ Si no funcionó, abrir ventana emergente
      googleUser ??= await googleSignIn.signIn();
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

      log('✅ Login con Google (silencioso o manual) exitoso.');
      return true;
    } catch (e) {
      log('❌ Error en loginConGoogle: $e');
      return false;
    }
  }

  /*
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
  */

  static Future<bool> loginConEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('✅ Login con email exitoso');
      return true;
    } catch (e) {
      log('❌ Error en loginConEmail: $e');
      return false;
    }
  }

  static Future<bool> registrarUsuario(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      log('✅ Registro exitoso, email de verificación enviado');
      return true;
    } catch (e) {
      log('❌ Error en registrarUsuario: $e');
      return false;
    }
  }

  static Future<bool> enviarEmailRecuperacion(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      log('✅ Email de recuperación enviado a $email');
      return true;
    } catch (e) {
      log('❌ Error al enviar email de recuperación: $e');
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

  static Future<User?> getCurrentUserWithReload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }

  static Future<void> crearAdminEnBDD({
    required String uid,
    required String email,
    required String nombre,
    required String apellido,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('BDD_Admins').doc(uid).set({
        'email': email,
        'Nombre': nombre,
        'Apellido': apellido,
      });
      log('✅ Documento creado en BDD_Admins para UID: $uid');
    } catch (e) {
      log('❌ Error al crear documento en BDD_Admins: $e');
      rethrow;
    }
  }
}
