import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_resultados_busqueda.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_selector_criterio_busqueda.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
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

  final GlobalKey<CustomWebClienteSectionState> _clienteKey = GlobalKey();
  final GlobalKey<CustomWebProductosSectionState> _productosKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Espera a que termine el build inicial antes de modificar el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fichaEnCursoProvider.notifier).limpiarFicha();
    });
  }

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

    // Mostrar loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await fichasService.agregarFicha(
        uidCliente: fichaEnCurso.uidCliente!,
        nombreCliente: fichaEnCurso.nombreCliente ?? '',
        apellidoCliente: fichaEnCurso.apellidoCliente ?? '',
        zonaCliente: fichaEnCurso.zonaCliente ?? '',
        productos: fichaEnCurso.productos.map((p) => p.toMap()).toList(),
        fechaDeVenta: fichaEnCurso.fechaDeVenta ?? DateTime.now(),
        frecuenciaDeAviso: 'mensual',
        proximoAviso: DateTime.now().add(const Duration(days: 30)),
      );

      ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

      if (!mounted) return;

      Navigator.of(context).pop(); // Cerrar el loader

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ficha guardada exitosamente.')),
      );

      // Resetear la UI de clientes y productos
      _clienteKey.currentState?.resetear();
      _productosKey.currentState?.resetear();
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Cerrar el loader
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
          const CustomWebTopBar(
            titulo: 'Agregar o buscar fichas',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          Expanded(
            child: Row(
              children: [
                // Lado izquierdo - Cliente + Fechas
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Datos del cliente
                        Expanded(
                          flex: 2,
                          child: CustomWebClienteSection(
                            key: _clienteKey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Fechas de control (nuevo bloque)
                        Expanded(
                          flex: 1,
                          child: CustomWebFichaFechasSection(),
                        ),
                        const SizedBox(height: 20),

                        // Botón para agregar ficha
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
                        Expanded(
                          child: CustomWebProductosSection(
                            key: _productosKey,
                          ),
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
