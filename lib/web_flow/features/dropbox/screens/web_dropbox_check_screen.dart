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
    try {
      final adminId = await _secureStorage.read(key: 'UID');

      if (adminId == null || adminId.isEmpty) {
        _redirigirAAutorizacion();
        return;
      }

      final claves = await FirebaseService.getDropboxGlobalKeys();

      if (claves == null ||
          claves['appKey'] == null ||
          claves['appSecret'] == null) {
        _redirigirAAutorizacion();
        return;
      }

      DropboxServiciosWeb.definirClaves(
          claves['appKey']!, claves['appSecret']!);

      final conectado = await DropboxServiciosWeb.hasStoredToken();

      if (!mounted) return;

      if (conectado) {
        Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
      } else {
        _redirigirAAutorizacion();
      }
    } catch (e) {
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
