import 'package:flutter/material.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_google_sheets.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_google_sheets_web.dart';
import 'web_clientes_screen.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valen Market Admin - Web')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'CLIENTES', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WebClientesScreen()),
              );
            }),
            const SizedBox(height: 20),
            /*
            ElevatedButton(
              onPressed: () async {
                await ClientesServiciosGoogleSheets.exportarClientes(context);
              },
              child: const Text('Exportar a Google Sheets'),
            ),
            */
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  ClientesServiciosGoogleSheetsWeb.exportarClientes(context),
              child: const Text('Exportar a Google Sheets'),
            ),
            const SizedBox(height: 20),
            _buildButton(context, 'FICHAS', () {}),
            const SizedBox(height: 20),
            _buildButton(context, 'CATALOGO', () {}),
            const SizedBox(height: 20),
            _buildButton(context, 'PLANILLA DE COBROS', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
