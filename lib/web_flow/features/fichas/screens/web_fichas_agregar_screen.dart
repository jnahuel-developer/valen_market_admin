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
  }

  // ---------------------------------------------------------------------------
  // 🔹 Agregar ficha (guardar en Firebase)
  // ---------------------------------------------------------------------------

  Future<void> _agregarFicha() async {
    final ficha = ref.read(fichaEnCursoProvider);

    if (!ficha.esFichaValidaParaGuardar()) {
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
                        const SizedBox(height: 10),

                        // Sección fechas
                        const Expanded(
                          flex: 1,
                          child: CustomWebFichaFechasSection(),
                        ),
                        const SizedBox(height: 10),

                        // 🔹 Botón "Agregar" centrado
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 250,
                            child: CustomGradientButton(
                              text: TEXTO__editar_fichas_screen__boton__agregar,
                              onPressed: _agregarFicha,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // LADO DERECHO → Solo productos (sin botón buscar)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomWebProductosSection(
                      key: _productosKey,
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
