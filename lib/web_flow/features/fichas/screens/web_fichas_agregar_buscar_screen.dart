import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_popup_resultados_busqueda.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_popup_selector_criterio_busqueda.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';

class WebFichasAgregarBuscarScreen extends ConsumerStatefulWidget {
  const WebFichasAgregarBuscarScreen({super.key});

  @override
  ConsumerState<WebFichasAgregarBuscarScreen> createState() =>
      _WebFichasAgregarBuscarScreenState();
}

class _WebFichasAgregarBuscarScreenState
    extends ConsumerState<WebFichasAgregarBuscarScreen> {
  final fichasService = FichasServiciosFirebase();

  Future<String?> _mostrarSelectorDeCriterio(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => PopupSelectorCriterioBusqueda(
        onCriterioSeleccionado: (criterio) {
          Navigator.of(context).pop(criterio);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _mostrarFichasParaCriterio(
      BuildContext context, String criterio) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => PopupResultadosBusqueda(
        criterio: criterio,
        onFichaSeleccionada: (_) {},
      ),
    );
  }

  void _navegarAEditarFicha(BuildContext context) {
    print('Valido contexto');
    if (!context.mounted) return;

    Navigator.pushNamed(context, PANTALLA_WEB__Fichas__Editar_Eliminar);
  }

  Future<void> _agregarFicha() async {
    final fichaEnCurso = ref.read(fichaEnCursoProvider);

    if (!fichaEnCurso.esValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Debes seleccionar un cliente y al menos un producto.')),
      );
      return;
    }

    try {
      await fichasService.agregarFicha(
        uidCliente: fichaEnCurso.uidCliente!,
        productos: fichaEnCurso.productos.map((p) => p.toMap()).toList(),
        fechaDeVenta: DateTime.now(),
        frecuenciaDeAviso: 'mensual',
        proximoAviso: DateTime.now().add(const Duration(days: 30)),
      );

      print('✅ Ficha agregada correctamente en Firestore');

      ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ficha guardada exitosamente.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la ficha: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(titulo: 'Agregar o buscar fichas'),
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
                        const Expanded(
                          child: CustomWebClienteSection(),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: CustomGradientButton(
                            text: 'Agregar',
                            onPressed: _agregarFicha,
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
                        const Expanded(
                          child: CustomWebProductosSection(),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: CustomGradientButton(
                            text: 'Buscar',
                            onPressed: () async {
                              final criterioSeleccionado =
                                  await _mostrarSelectorDeCriterio(context);
                              if (criterioSeleccionado == null) return;

                              final fichaSeleccionada =
                                  await _mostrarFichasParaCriterio(
                                      context, criterioSeleccionado);
                              if (fichaSeleccionada == null) return;
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
