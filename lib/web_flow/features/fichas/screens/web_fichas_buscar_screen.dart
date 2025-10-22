import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_selector_criterio_busqueda.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_resultados_busqueda.dart';

class WebFichasBuscarScreen extends ConsumerStatefulWidget {
  const WebFichasBuscarScreen({super.key});

  @override
  ConsumerState<WebFichasBuscarScreen> createState() =>
      _WebFichasBuscarScreenState();
}

class _WebFichasBuscarScreenState extends ConsumerState<WebFichasBuscarScreen> {
  final GlobalKey<CustomWebClienteSectionState> _clienteKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: 'Buscar fichas',
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
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
                      const SizedBox(height: 10),

                      // Fechas
                      Expanded(
                        flex: 1,
                        child: CustomWebFichaFechasSection(),
                      ),
                      const SizedBox(height: 30),

                      // Botón de búsqueda
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
            ),
          ),
        ],
      ),
    );
  }
}
