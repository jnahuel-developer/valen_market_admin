import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_resultados_busqueda.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_selector_criterio_busqueda.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class WebFichasAgregarScreen extends ConsumerStatefulWidget {
  const WebFichasAgregarScreen({super.key});

  @override
  ConsumerState<WebFichasAgregarScreen> createState() =>
      _WebFichasAgregarScreenState();
}

class _WebFichasAgregarScreenState
    extends ConsumerState<WebFichasAgregarScreen> {
  final GlobalKey<CustomWebClienteSectionState> _clienteKey = GlobalKey();
  final GlobalKey<CustomWebProductosSectionState> _productosKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Limpiar ficha en curso apenas se construye la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fichaEnCursoProvider).limpiarFicha();
    });
  }

  // ---------------------------------------------------------------------------
  // 🔹 Diálogo de búsqueda (aún activo por compatibilidad)
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // 🔹 Agregar ficha (guardar en Firebase)
  // ---------------------------------------------------------------------------

  Future<void> _agregarFicha() async {
    final ficha = ref.read(fichaEnCursoProvider);

    if (!ficha.hayFichaValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un cliente y al menos un producto.'),
        ),
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
      await ficha.guardarFichaEnFirebase();

      // Cerrar loader
      if (mounted) Navigator.of(context).pop();

      // Feedback visual
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ficha guardada exitosamente.')),
        );
      }

      // Limpiar ficha y resetear secciones visuales
      ficha.limpiarFicha();
      _clienteKey.currentState?.setState(() {}); // refresca cliente
      _productosKey.currentState?.setState(() {}); // refresca productos
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Cerrar loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la ficha: $e')),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomWebTopBar(
            titulo: TEXTO__agregar_fichas_screen__titulo,
            pantallaPadreRouteName: PANTALLA_WEB__Home,
          ),
          Expanded(
            child: Row(
              children: [
                // LADO IZQUIERDO → Cliente + Fechas + Botón agregar
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Sección cliente
                        Expanded(
                          flex: 2,
                          child: CustomWebClienteSection(
                            key: _clienteKey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Sección fechas
                        const Expanded(
                          flex: 1,
                          child: CustomWebFichaFechasSection(),
                        ),
                        const SizedBox(height: 20),

                        // Botón "Agregar"
                        SizedBox(
                          width: double.infinity,
                          child: CustomGradientButton(
                            text: TEXTO__editar_fichas_screen__boton__agregar,
                            onPressed: _agregarFicha,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // LADO DERECHO → Productos + botón buscar (provisorio)
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
                            text: TEXTO__editar_fichas_screen__boton__buscar,
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
