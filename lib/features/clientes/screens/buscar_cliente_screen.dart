import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/widgets/custom_bottom_navbar.dart';
import 'package:valen_market_admin/widgets/custom_info_card.dart';
import 'package:valen_market_admin/widgets/custom_simple_information.dart';
import 'package:valen_market_admin/widgets/custom_top_bar.dart';

class BuscarClienteScreen extends StatelessWidget {
  const BuscarClienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para búsqueda
    final TextEditingController nombreBusquedaController =
        TextEditingController();
    final TextEditingController numeroBusquedaController =
        TextEditingController();

    // Controladores para los datos visuales del cliente
    final TextEditingController nombreClienteController =
        TextEditingController();
    final TextEditingController apellidoClienteController =
        TextEditingController();
    final TextEditingController direccionClienteController =
        TextEditingController();
    final TextEditingController telefonoClienteController =
        TextEditingController();
    final TextEditingController zonaClienteController = TextEditingController();

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
                      CustomSimpleInformation(
                        label: 'Número',
                        controller: numeroBusquedaController,
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
