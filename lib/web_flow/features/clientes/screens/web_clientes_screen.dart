import 'package:flutter/material.dart';
import 'web_agregar_cliente_screen.dart';

class WebClientesScreen extends StatelessWidget {
  const WebClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'AGREGAR', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const WebAgregarClienteScreen()),
              );
            }),
            const SizedBox(height: 20),
            _buildButton(context, 'BUSCAR', () {
              // Pendiente de implementar
            }),
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
