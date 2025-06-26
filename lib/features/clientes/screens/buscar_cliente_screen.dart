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
  final TextEditingController numeroBusquedaController =
      TextEditingController();

  final TextEditingController nombreClienteController = TextEditingController();
  final TextEditingController apellidoClienteController =
      TextEditingController();
  final TextEditingController direccionClienteController =
      TextEditingController();
  final TextEditingController telefonoClienteController =
      TextEditingController();
  final TextEditingController zonaClienteController = TextEditingController();

  List<String> nombresClientes = [];
  String? nombreSeleccionado;

  @override
  void initState() {
    super.initState();
    cargarNombresDeClientes();
  }

  Future<void> cargarNombresDeClientes() async {
    try {
      final nombres =
          await ClientesServiciosFirebase.obtenerNombresDeClientes();
      setState(() {
        nombresClientes = nombres;
      });
    } catch (e) {
      debugPrint('Error al cargar nombres: $e');
    }
  }

  Future<void> cargarDatosDelCliente(String nombre) async {
    try {
      final datos =
          await ClientesServiciosFirebase.obtenerClientePorNombre(nombre);
      if (datos != null) {
        setState(() {
          nombreClienteController.text = datos['Nombre'];
          apellidoClienteController.text = datos['Apellido'];
          direccionClienteController.text = datos['Dirección'];
          telefonoClienteController.text = datos['Teléfono'];
          zonaClienteController.text = datos['Zona'];
        });
      }
    } catch (e) {
      debugPrint('Error al cargar datos del cliente: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            AppAssets.bgClientes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: AppColors.blancoTraslucido,
            colorBlendMode: BlendMode.srcOver,
          ),

          // Menú superior
          const CustomTopBar(title: 'BUSCAR CLIENTES'),

          // Cuerpo principal
          Padding(
            padding: const EdgeInsets.only(top: 130, bottom: 80),
            child: SingleChildScrollView(
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
                        // MENÚ DESPLEGABLE para seleccionar nombre
                        Container(
                          width: 350,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.negroSuave,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              value: nombreSeleccionado,
                              hint: const Text(
                                'Seleccionar nombre...',
                                style: TextStyle(color: Colors.white),
                              ),
                              dropdownColor: AppColors.negroSuave,
                              iconEnabledColor: Colors.white,
                              isExpanded: true,
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    nombreSeleccionado = newValue;
                                  });
                                  print('🟡 Seleccionado: $newValue');
                                  cargarDatosDelCliente(newValue);
                                }
                              },
                              items: nombresClientes.map((String nombre) {
                                return DropdownMenuItem<String>(
                                  value: nombre,
                                  child: Center(
                                    child: Text(
                                      nombre,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// Bloque 2: Datos del cliente
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
