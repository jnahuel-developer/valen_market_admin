import 'package:flutter/material.dart';
import '../../features/clientes/services/clientes_servicios_firebase.dart';
import '../../utils/validador_texto.dart';

class WebAgregarClienteScreen extends StatefulWidget {
  const WebAgregarClienteScreen({super.key});

  @override
  State<WebAgregarClienteScreen> createState() =>
      _WebAgregarClienteScreenState();
}

class _WebAgregarClienteScreenState extends State<WebAgregarClienteScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _agregarCliente() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();

    if (!ValidadorTexto.esEntradaSegura(nombre) ||
        !ValidadorTexto.esEntradaSegura(apellido) ||
        !ValidadorTexto.esEntradaSegura(direccion) ||
        !ValidadorTexto.esEntradaSegura(telefono)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Alguno de los datos ingresados no es seguro')),
      );
      return;
    }

    await ClientesServiciosFirebase.agregarClienteABDD(
      nombre: nombre,
      apellido: apellido,
      direccion: direccion,
      telefono: telefono,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente agregado exitosamente')),
    );

    Navigator.pop(context); // Volver a pantalla de CLIENTES
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cliente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: [
            _buildTextField('Nombre', _nombreController),
            const SizedBox(height: 20),
            _buildTextField('Apellido', _apellidoController),
            const SizedBox(height: 20),
            _buildTextField('Dirección', _direccionController),
            const SizedBox(height: 20),
            _buildTextField('Teléfono', _telefonoController),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _agregarCliente,
                child: const Text('CONFIRMAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
