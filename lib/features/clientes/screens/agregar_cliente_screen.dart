import 'package:flutter/material.dart';
import 'package:valen_market_admin/utils/validador_texto.dart';
import 'package:valen_market_admin/widgets/custom_simple_information.dart';
import 'package:valen_market_admin/widgets/custom_info_card.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_big_button.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';

class AgregarClienteScreen extends StatefulWidget {
  const AgregarClienteScreen({super.key});

  @override
  State<AgregarClienteScreen> createState() => _AgregarClienteScreenState();
}

class _AgregarClienteScreenState extends State<AgregarClienteScreen> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final direccionController = TextEditingController();
  final telefonoController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    direccionController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  void _handleAgregar() async {
    final nombre = nombreController.text;
    final apellido = apellidoController.text;
    final direccion = direccionController.text;
    final telefono = telefonoController.text;

    final inputs = [nombre, apellido, direccion, telefono];
    final esSeguro = inputs.every(ValidadorTexto.esEntradaSegura);

    if (!esSeguro) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos inválidos o inseguros')),
      );
      return;
    }

    try {
      await ClientesServiciosFirebase.agregarClienteABDD(
        nombre: nombre,
        apellido: apellido,
        direccion: direccion,
        telefono: telefono,
      );

      // Ir a la pantalla de Clientes luego de guardar
      Navigator.pushReplacementNamed(context, '/clientes');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo de la pantalla
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppAssets.bgClientes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Menú superior
          const CustomTopBar(title: 'Agregar Cliente'),

          // Cuerpo principal
          Padding(
            padding: const EdgeInsets.only(top: 130, bottom: 80),
            child: Column(
              children: [
                /// Bloque 1: Datos para buscar
                Center(
                  child: CustomInfoCard(
                    title: 'DATOS DEL CLIENTE',
                    height: 550,
                    width: 400,
                    children: [
                      CustomSimpleInformation(
                          label: 'Nombre', controller: nombreController),
                      CustomSimpleInformation(
                          label: 'Apellido', controller: apellidoController),
                      CustomSimpleInformation(
                          label: 'Dirección', controller: direccionController),
                      CustomSimpleInformation(
                          label: 'Teléfono', controller: telefonoController),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Boton para agregar clientes a la BBDD
          Positioned(
            top: 750,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBigButton(
                text: 'Agregar',
                onTap: _handleAgregar,
              ),
            ),
          ),

          // Menú inferior
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
