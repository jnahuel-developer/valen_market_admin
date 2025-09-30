import 'package:flutter/material.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/utils/validador_texto.dart';

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

  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _agregarCliente() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();

    if (!ValidadorTexto.esEntradaSegura(nombre) ||
        !ValidadorTexto.esEntradaSegura(apellido) ||
        !ValidadorTexto.esEntradaSegura(direccion) ||
        !ValidadorTexto.esEntradaSegura(telefono)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Alguno de los datos ingresados no es seguro')),
      );
      return;
    }

    setState(() => _guardando = true);

    await ClientesServiciosFirebase.agregarClienteABDD(
      nombre: nombre,
      apellido: apellido,
      direccion: direccion,
      telefono: telefono,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente agregado exitosamente')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Agregar Cliente',
            pantallaPadreRouteName: PANTALLA_WEB__Clientes,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Nombre',
                          controller: _nombreController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Apellido',
                          controller: _apellidoController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Dirección',
                          controller: _direccionController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Teléfono',
                          controller: _telefonoController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 40),
                        _guardando
                            ? const CircularProgressIndicator()
                            : CustomGradientButton(
                                text: 'CONFIRMAR',
                                onPressed: _agregarCliente,
                              ),
                      ],
                    ),
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
