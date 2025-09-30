import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/dropbox/dropbox_servicios_web.dart';
import 'package:valen_market_admin/services/firebase/dropbox_keys.dart';

class WebDropboxAuthScreen extends StatefulWidget {
  const WebDropboxAuthScreen({super.key});

  @override
  State<WebDropboxAuthScreen> createState() => _WebDropboxAuthScreenState();
}

class _WebDropboxAuthScreenState extends State<WebDropboxAuthScreen> {
  final _codeController = TextEditingController();
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _cargarClavesGlobales();
  }

  Future<void> _cargarClavesGlobales() async {
    try {
      final claves = await FirebaseService.getDropboxGlobalKeys();

      if (claves == null ||
          claves['appKey'] == null ||
          claves['appSecret'] == null) {
        setState(() =>
            _mensaje = 'Error: No se encontraron claves globales de Dropbox.');
        return;
      }

      DropboxServiciosWeb.definirClaves(
          claves['appKey']!, claves['appSecret']!);
    } catch (e) {
      setState(() => _mensaje = 'Error al cargar claves: $e');
    }
  }

  void _abrirUrlDropbox() async {
    try {
      final url = Uri.parse(DropboxServiciosWeb.generarUrlDeAutorizacion());
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() => _mensaje = 'Error al abrir la URL: $e');
    }
  }

  void _autenticarDropbox() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _mensaje = 'Debe ingresar un código válido.');
      return;
    }

    setState(() => _mensaje = null);

    try {
      await DropboxServiciosWeb.autenticar(code);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
    } catch (e) {
      setState(() => _mensaje = 'Error durante la autenticación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Conectar con Dropbox',
            pantallaPadreRouteName: null,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomGradientButton(
                        text: 'ABRIR URL DE AUTORIZACIÓN',
                        onPressed: _abrirUrlDropbox,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        label: 'Código de autorización',
                        controller: _codeController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 30),
                      CustomGradientButton(
                        text: 'AUTENTICAR',
                        onPressed: _autenticarDropbox,
                      ),
                      const SizedBox(height: 20),
                      if (_mensaje != null)
                        Text(
                          _mensaje!,
                          style: TextStyle(
                            color: _mensaje!.contains('Error')
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
