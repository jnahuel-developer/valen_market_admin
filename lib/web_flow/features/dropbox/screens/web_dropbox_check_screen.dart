import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/dropbox/dropbox_servicios_web.dart';
import 'package:valen_market_admin/services/firebase/dropbox_keys.dart';

class WebDropboxCheckScreen extends StatefulWidget {
  const WebDropboxCheckScreen({super.key});

  @override
  State<WebDropboxCheckScreen> createState() => _WebDropboxCheckScreenState();
}

class _WebDropboxCheckScreenState extends State<WebDropboxCheckScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _verificarDropbox();
  }

  Future<void> _verificarDropbox() async {
    print('[DropboxCheck] Iniciando verificación de Dropbox...');

    try {
      final adminId = await _secureStorage.read(key: 'UID');
      print('[DropboxCheck] UID leído: $adminId');

      if (adminId == null || adminId.isEmpty) {
        print('[DropboxCheck] UID nulo o vacío. Redirigiendo a autorización.');
        _redirigirAAutorizacion();
        return;
      }

      final claves = await FirebaseService.getDropboxGlobalKeys();
      print('[DropboxCheck] Claves globales obtenidas: ${claves != null}');

      if (claves == null ||
          claves['appKey'] == null ||
          claves['appSecret'] == null) {
        print(
            '[DropboxCheck] Claves faltantes o inválidas. Redirigiendo a autorización.');
        _redirigirAAutorizacion();
        return;
      }

      DropboxServiciosWeb.definirClaves(
          claves['appKey']!, claves['appSecret']!);
      print('[DropboxCheck] Claves definidas correctamente');

      final conectado = await DropboxServiciosWeb.hasStoredToken();
      print('[DropboxCheck] Estado de conexión a Dropbox: $conectado');

      if (!mounted) return;

      if (conectado) {
        print('[DropboxCheck] Ya conectado. Redirigiendo a HOME');
        Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
      } else {
        print('[DropboxCheck] No conectado. Redirigiendo a autorización');
        _redirigirAAutorizacion();
      }
    } catch (e) {
      print('[DropboxCheck] ❌ Error inesperado: $e');
      if (!mounted) return;
      _redirigirAAutorizacion();
    }
  }

  void _redirigirAAutorizacion() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, PANTALLA_WEB__Dropbox__Auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
