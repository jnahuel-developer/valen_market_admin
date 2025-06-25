import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/features/clientes/services/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_info_card.dart';
import 'package:valen_market_admin/widgets/custom_simple_information.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';
import 'package:valen_market_admin/widgets/custom_opciones_desplegables.dart';

class BuscarClienteScreen extends StatefulWidget {
  const BuscarClienteScreen({super.key});

  @override
  State<BuscarClienteScreen> createState() => _BuscarClienteScreenState();
}

class _BuscarClienteScreenState extends State<BuscarClienteScreen> {
  final TextEditingController nombreBusquedaController =
      TextEditingController();

  // Controladores para los datos visuales del cliente
  final TextEditingController nombreClienteController = TextEditingController();
  final TextEditingController apellidoClienteController =
      TextEditingController();
  final TextEditingController direccionClienteController =
      TextEditingController();
  final TextEditingController telefonoClienteController =
      TextEditingController();
  final TextEditingController zonaClienteController = TextEditingController();

  String? nombreSeleccionado;
  List<String> nombresClientes = [];

  @override
  void initState() {
    super.initState();
    cargarNombresDeClientes();
  }

  Future<void> cargarNombresDeClientes() async {
    final nombres = await ClientesServiciosFirebase.obtenerNombresDeClientes();
    setState(() {
      nombresClientes = nombres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo de la pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.bgClientes),
                fit: BoxFit.cover,
              ),
            ),
            foregroundDecoration: const BoxDecoration(
              color: AppColors.blancoTraslucido,
            ),
          ),

          // Menú superior
          const CustomTopBar(title: 'BUSCAR CLIENTES'),

          // Cuerpo principal
          Padding(
            padding: const EdgeInsets.only(top: 130, bottom: 80),
            child: Column(
              children: [
                /// Bloque 1: Datos para buscar
                Center(
                  child: CustomInfoCard(
                    title: 'Datos para buscar',
                    height: 200,
                    width: 400,
                    children: [
                      CustomSimpleInformation(
                        label: 'Nombre',
                        controller: nombreBusquedaController,
                      ),
                      CustomOpcionesDesplegables(
                        valorSeleccionado: nombreSeleccionado,
                        opciones: nombresClientes,
                        onChanged: (nuevoValor) {
                          setState(() {
                            nombreSeleccionado = nuevoValor;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                /// Bloque 2: Datos del cliente (por ahora visual)
                Center(
                  child: CustomInfoCard(
                    title: 'Datos del cliente',
                    height: 400,
                    width: 400,
                    children: [
                      CustomSimpleInformation(
                        label: 'Nombre',
                        controller: nombreClienteController,
                      ),
                      CustomSimpleInformation(
                        label: 'Apellido',
                        controller: apellidoClienteController,
                      ),
                      CustomSimpleInformation(
                        label: 'Dirección',
                        controller: direccionClienteController,
                      ),
                      CustomSimpleInformation(
                        label: 'Teléfono',
                        controller: telefonoClienteController,
                      ),
                      CustomSimpleInformation(
                        label: 'Zona',
                        controller: zonaClienteController,
                      ),
                    ],
                  ),
                ),
              ],
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
