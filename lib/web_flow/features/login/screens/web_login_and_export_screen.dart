import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_google_sheets_web.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/config/environment.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLoginAndExportScreen extends StatefulWidget {
  const WebLoginAndExportScreen({super.key});

  @override
  State<WebLoginAndExportScreen> createState() =>
      _WebLoginAndExportScreenState();
}

class _WebLoginAndExportScreenState extends State<WebLoginAndExportScreen> {
  bool _procesando = false;

  Future<void> _iniciarSesionYExportar() async {
    setState(() => _procesando = true);

    try {
      /*
      print('🔁 Cerrando sesión previa...');
      final signIn = GoogleSignIn();
      final isSignedIn = await signIn.isSignedIn();
      if (isSignedIn) {
        print('🔁 Cerrando sesión previa...');
        await signIn.signOut();
      } else {
        print('ℹ️ No había sesión activa.');
      }
      */

      print('🔁 Inicializando GoogleSignIn...');
      final googleSignIn = GoogleSignIn(
        clientId: GOOGLE_SIGN_IN_CLIENT_ID_DEV,
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/drive.file',
          'https://www.googleapis.com/auth/spreadsheets',
        ],
      );

      print('🔁 Solicitando login...');
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('🛑 Login cancelado por el usuario.');
        _mostrarMensaje('❌ Inicio cancelado por el usuario.');
        setState(() => _procesando = false);
        return;
      }

      print('✅ Login exitoso');
      print('👤 googleUser.displayName: ${googleUser.displayName}');
      print('👤 googleUser.email: ${googleUser.email}');
      print('👤 googleUser.id: ${googleUser.id}');

      print('🔁 Solicitando tokens...');
      final googleAuth = await googleUser.authentication;

      print('🔐 googleAuth.accessToken: ${googleAuth.accessToken}');
      print('🔐 googleAuth.idToken: ${googleAuth.idToken}');

      if (googleAuth.accessToken == null) {
        print('🛑 No se recibió accessToken de Google.');
        _mostrarMensaje('❌ No se recibió accessToken de Google.');
        setState(() => _procesando = false);
        return;
      }

      print('🔁 Autenticando con Firebase...');
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      print('✅ Firebase auth OK');

      print('📤 Iniciando exportación a Google Sheets...');
      final url =
          await ClientesServiciosGoogleSheetsWeb.exportarClientes(context);

      if (url != null && context.mounted) {
        print('✅ Exportación OK. Hoja: $url');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Clientes exportados correctamente'),
            action: SnackBarAction(
              label: 'ABRIR',
              onPressed: () => launchUrl(Uri.parse(url)),
            ),
          ),
        );

        Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
      } else {
        print('⚠️ No se generó el archivo de exportación.');
        _mostrarMensaje('⚠️ No se generó el archivo de exportación.');
      }
    } catch (e, st) {
      print('❌ Error en login/exportación: $e');
      print(st);

      _mostrarMensaje('❌ Error inesperado durante la exportación.\n$e');
    }

    if (mounted) setState(() => _procesando = false);
  }

  void _mostrarMensaje(String mensaje) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 6),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso y Exportación')),
      body: Center(
        child: _procesando
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Iniciá sesión para exportar datos'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _iniciarSesionYExportar,
                    child: const Text('Login + Exportar a Google Sheets'),
                  ),
                ],
              ),
      ),
    );
  }
}
