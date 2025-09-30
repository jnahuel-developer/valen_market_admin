import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/services/google/clientes_servicios_google_sheets_web.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebClientesScreen extends StatefulWidget {
  const WebClientesScreen({super.key});

  @override
  State<WebClientesScreen> createState() => _WebClientesScreenState();
}

class _WebClientesScreenState extends State<WebClientesScreen> {
  bool _exportando = false;

  Future<void> _pasarAExcel() async {
    setState(() => _exportando = true);

    final url = await ClientesServiciosGoogleSheetsWeb.exportarClientes();

    if (!mounted) return;
    setState(() => _exportando = false);

    if (url != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Exportación exitosa.'),
          action: SnackBarAction(
            label: 'ABRIR',
            onPressed: () => launchUrl(Uri.parse(url)),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo exportar a Excel.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Clientes',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomGradientButton(
                      text: 'AGREGAR',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          PANTALLA_WEB__Clientes__AgregarCliente,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomGradientButton(
                      text: 'BUSCAR',
                      onPressed: () {
                        // Implementar luego
                      },
                    ),
                    const SizedBox(height: 20),
                    _exportando
                        ? const CircularProgressIndicator()
                        : CustomGradientButton(
                            text: 'PASAR A EXCEL',
                            onPressed: _pasarAExcel,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
