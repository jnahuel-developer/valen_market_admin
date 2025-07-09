import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WebLoginWebScreen extends StatefulWidget {
  const WebLoginWebScreen({super.key});

  @override
  State<WebLoginWebScreen> createState() => _WebLoginWebScreenState();
}

class _WebLoginWebScreenState extends State<WebLoginWebScreen> {
  bool _logueando = false;

  Future<void> _loginConGoogle() async {
    setState(() => _logueando = true);

    try {
      final googleUser = await GoogleSignIn(
        clientId:
            '1089321285838-jvb3agltggcimsc1hgbiq6lkh11g7kr4.apps.googleusercontent.com',
      ).signIn();

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio cancelado')),
        );
        setState(() => _logueando = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/web_home');
      }
    } catch (e) {
      print('⚠️ Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }

    if (mounted) {
      setState(() => _logueando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _logueando
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _loginConGoogle,
                child: const Text('Iniciar sesión con Google'),
              ),
      ),
    );
  }
}
