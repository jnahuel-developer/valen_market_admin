import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_informar_pago.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';

class WebFichasEditarEliminarScreen extends ConsumerStatefulWidget {
  const WebFichasEditarEliminarScreen({super.key});

  @override
  ConsumerState<WebFichasEditarEliminarScreen> createState() =>
      _WebFichasEditarEliminarScreenState();
}

class _WebFichasEditarEliminarScreenState
    extends ConsumerState<WebFichasEditarEliminarScreen> {
  final FichasServiciosFirebase fichasService = FichasServiciosFirebase();
  bool _cargando = false;

  // ─────────────────────────────────────────────────────────────
  // MÉTODO: Confirmar Actualización
  // ─────────────────────────────────────────────────────────────
  Future<void> _confirmarActualizacionFicha() async {
    final bool? confirmar = await _mostrarPopupConfirmacion(
      TEXTO__editar_fichas_screen__mensaje__confirmar_actualizacion,
    );

    if (confirmar == true) {
      setState(() => _cargando = true);
      try {
        final ficha = ref.read(fichaEnCursoProvider);
        final String? idFicha = ficha.id;

        if (idFicha == null) {
          throw Exception(TEXTO__editar_fichas_screen__mensaje__ID_no_definido);
        }

        final FichaModel fichaActualizada = ficha.construirFichaCompleta();
        await fichasService.ActualizarFichaEnFirebase(
            idFicha, fichaActualizada);

        ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  TEXTO__editar_fichas_screen__mensaje__ficha_actualizada)),
        );
        Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar ficha: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _cargando = false);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // MÉTODO: Confirmar Eliminación
  // ─────────────────────────────────────────────────────────────
  Future<void> _confirmarEliminacionFicha() async {
    final bool? confirmar = await _mostrarPopupConfirmacion(
      TEXTO__editar_fichas_screen__mensaje__confirmar_eliminacion,
    );

    if (confirmar == true) {
      setState(() => _cargando = true);
      try {
        final ficha = ref.read(fichaEnCursoProvider);
        final String? idFicha = ficha.id;

        if (idFicha == null) {
          throw Exception(TEXTO__editar_fichas_screen__mensaje__ID_no_definido);
        }

        await fichasService.EliminarFichaEnFirebase(idFicha);
        ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text(TEXTO__editar_fichas_screen__mensaje__ficha_eliminada)),
        );
        Navigator.pushReplacementNamed(context, PANTALLA_WEB__Home);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar ficha: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _cargando = false);
      }
    }
  }

// ─────────────────────────────────────────────────────────────
// MÉTODO: Informar Pago (versión definitiva)
// ─────────────────────────────────────────────────────────────
  Future<void> _informarPago() async {
    final ficha = ref.read(fichaEnCursoProvider);
    final String? idFicha = ficha.id;

    if (idFicha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            TEXTO__editar_fichas_screen__mensaje__ID_no_definido,
          ),
        ),
      );
      return;
    }

    // Mostrar popup para ingresar el pago
    showDialog(
      context: context,
      builder: (_) => CustomWebPopupInformarPago(
        onConfirmar: (double montoPagado, DateTime nuevaFechaAviso) async {
          try {
            // Construir mapa del pago
            final pagoMap = {
              FIELD_NAME__pago_item_model__Monto: montoPagado,
              FIELD_NAME__pago_item_model__Fecha: nuevaFechaAviso,
            };

            // Registrar el pago en el Provider (NO directamente en Firebase)
            ref.read(fichaEnCursoProvider.notifier).registrarPago(pagoMap);

            // Actualizar la ficha en Firebase con el nuevo estado de pagos
            await ref
                .read(fichaEnCursoProvider.notifier)
                .actualizarFichaMedianteID();

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  TEXTO__editar_fichas_screen__mensaje__pago_registrado,
                ),
              ),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al registrar pago: $e'),
              ),
            );
          }
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // POPUP Confirmación genérico
  // ─────────────────────────────────────────────────────────────
  Future<bool?> _mostrarPopupConfirmacion(String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(TEXTO__editar_fichas_screen__boton__confirmacion),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(TEXTO__editar_fichas_screen__boton__cancelar),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(TEXTO__editar_fichas_screen__boton__confirmar),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const CustomWebTopBar(
                titulo: TEXTO__editar_fichas_screen__titulo,
                pantallaPadreRouteName: PANTALLA_WEB__Home,
              ),
              Expanded(
                child: Row(
                  children: [
                    // Columna izquierda: cliente + fechas
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: CustomWebClienteSection(),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              flex: 1,
                              child: CustomWebFichaFechasSection(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Columna derecha: productos
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: CustomWebProductosSection(),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Botones inferiores
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomGradientButton(
                        text: TEXTO__editar_fichas_screen__boton__editar,
                        onPressed: _confirmarActualizacionFicha,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomGradientButton(
                        text: TEXTO__editar_fichas_screen__boton__informar_pago,
                        onPressed: _informarPago,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomGradientButton(
                        text: TEXTO__editar_fichas_screen__boton__eliminar,
                        onPressed: _confirmarEliminacionFicha,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Indicador de carga
          if (_cargando)
            Container(
              color: WebColors.negro,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
