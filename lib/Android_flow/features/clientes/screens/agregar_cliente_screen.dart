import 'package:flutter/material.dart';
import 'package:valen_market_admin/utils/validador_texto.dart';
import 'package:valen_market_admin/widgets/custom_simple_information.dart';
import 'package:valen_market_admin/widgets/custom_info_card.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_big_button.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/keys.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

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
        const SnackBar(
            content: Text(
                TEXTO_ES__agregar_clientes_screen__snackbar__datos_invalidos)),
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
      Navigator.pushReplacementNamed(context, PANTALLA__Clientes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                TEXTO_ES__agregar_clientes_screen__snackbar__error_al_guardar)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //
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
          const CustomTopBar(title: TEXTO_ES__agregar_clientes_screen__titulo),

          // Cuerpo principal envuelto en SingleChildScrollView
          Padding(
            padding: const EdgeInsets.only(top: 130, bottom: 80),
            child: SingleChildScrollView(
              key: KEY__agregar_clientes_screen__scrollview__principal,
              child: Column(
                children: [
                  /// Bloque 1: Datos para buscar
                  Center(
                    child: CustomInfoCard(
                      title:
                          TEXTO_ES__agregar_clientes_screen__custom_info_card__titulo,
                      height: 550,
                      width: 400,
                      children: [
                        CustomSimpleInformation(
                          label:
                              TEXTO_ES__agregar_clientes_screen__ingreso_datos__nombre,
                          controller: nombreController,
                          fieldKey:
                              KEY__agregar_clientes_screen__ingreso_datos__nombre,
                        ),
                        CustomSimpleInformation(
                          label:
                              TEXTO_ES__agregar_clientes_screen__ingreso_datos__apellido,
                          controller: apellidoController,
                          fieldKey:
                              KEY__agregar_clientes_screen__ingreso_datos__apellido,
                        ),
                        CustomSimpleInformation(
                          label:
                              TEXTO_ES__agregar_clientes_screen__ingreso_datos__direccion,
                          controller: direccionController,
                          fieldKey:
                              KEY__agregar_clientes_screen__ingreso_datos__direccion,
                        ),
                        CustomSimpleInformation(
                          label:
                              TEXTO_ES__agregar_clientes_screen__ingreso_datos__telefono,
                          controller: telefonoController,
                          fieldKey:
                              KEY__agregar_clientes_screen__ingreso_datos__telefono,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botón para agregar clientes a la BBDD
                  Center(
                    child: CustomBigButton(
                      text:
                          TEXTO_ES__agregar_clientes_screen__boton__agregar_cliente,
                      onTap: _handleAgregar,
                      fieldKey:
                          KEY__agregar_clientes_screen__boton__agregar_cliente,
                    ),
                  ),
                ],
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
