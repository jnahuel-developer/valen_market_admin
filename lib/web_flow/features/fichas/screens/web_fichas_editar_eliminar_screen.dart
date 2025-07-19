import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebFichasEditarEliminarScreen extends ConsumerWidget {
  const WebFichasEditarEliminarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fichaEnCurso = ref.watch(fichaEnCursoProvider);

    // Armamos el cliente a partir del provider
    final Map<String, dynamic> clienteCargado = {
      'UID': fichaEnCurso.uidCliente ?? '',
      'nombre': fichaEnCurso.nombreCliente ?? '',
      'apellido': fichaEnCurso.apellidoCliente ?? '',
      'zona': fichaEnCurso.zonaCliente ?? '',
      'direccion': fichaEnCurso.direccionCliente ?? '',
      'telefono': fichaEnCurso.telefonoCliente ?? '',
    };

    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Editar o eliminar ficha',
            pantallaPadreRouteName: PANTALLA_WEB__Fichas__Agregar_Buscar,
          ),
          Expanded(
            child: Row(
              children: [
                // Lado izquierdo - Cliente
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomWebClienteSection(
                            clienteCargado: clienteCargado,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: CustomGradientButton(
                            text: 'Confirmar',
                            onPressed: () {
                              // Aquí implementar lógica de actualización de ficha
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidad en desarrollo'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lado derecho - Productos
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomWebProductosSection(
                            productosDeFicha: fichaEnCurso.productos,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: CustomGradientButton(
                            text: 'Eliminar',
                            onPressed: () {
                              // Aquí implementar lógica de eliminación
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Funcionalidad en desarrollo'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
