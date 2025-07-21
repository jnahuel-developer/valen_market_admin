import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_cliente_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_ficha_productos_section.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';

class WebFichasEditarEliminarScreen extends ConsumerStatefulWidget {
  const WebFichasEditarEliminarScreen({super.key});

  @override
  ConsumerState<WebFichasEditarEliminarScreen> createState() =>
      _WebFichasEditarEliminarScreenState();
}

class _WebFichasEditarEliminarScreenState
    extends ConsumerState<WebFichasEditarEliminarScreen> {
  final fichasService = FichasServiciosFirebase();
  bool _cargando = false;

  Future<void> _confirmarActualizacionFicha() async {
    final bool? confirmar = await _mostrarPopupConfirmacion(
      '¿Deseas actualizar la ficha?',
    );

    if (confirmar == true) {
      setState(() => _cargando = true);

      try {
        final ficha = ref.read(fichaEnCursoProvider);
        await fichasService.actualizarFichaPorID(
          fichaId: ficha.id!,
          nuevosDatos: ficha.toMap(),
        );

        ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ficha actualizada correctamente')),
        );

        // Después de editar volvemos a la pantalla de agregar/buscar
        Navigator.pushReplacementNamed(
            context, PANTALLA_WEB__Fichas__Agregar_Buscar);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar ficha: $e')),
        );
      } finally {
        if (mounted) setState(() => _cargando = false);
      }
    }
  }

  Future<void> _confirmarEliminacionFicha() async {
    final bool? confirmar = await _mostrarPopupConfirmacion(
      '¿Deseas eliminar la ficha?',
    );

    if (confirmar == true) {
      setState(() => _cargando = true);

      try {
        final ficha = ref.read(fichaEnCursoProvider);
        await fichasService.eliminarFichaPorID(ficha.id!);

        ref.read(fichaEnCursoProvider.notifier).limpiarFicha();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ficha eliminada exitosamente')),
        );

        // Después de eliminar volvemos a la pantalla de agregar/buscar
        Navigator.pushReplacementNamed(
            context, PANTALLA_WEB__Fichas__Agregar_Buscar);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar ficha: $e')),
        );
      } finally {
        if (mounted) setState(() => _cargando = false);
      }
    }
  }

  Future<bool?> _mostrarPopupConfirmacion(String mensaje) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fichaEnCurso = ref.watch(fichaEnCursoProvider);

    final Map<String, dynamic> clienteCargado = {
      'UID': fichaEnCurso.uidCliente ?? '',
      'Nombre': fichaEnCurso.nombreCliente ?? 'Mal cargado',
      'Apellido': fichaEnCurso.apellidoCliente ?? '',
      'Zona': fichaEnCurso.zonaCliente ?? '',
      'Dirección': fichaEnCurso.direccionCliente ?? '',
      'Teléfono': fichaEnCurso.telefonoCliente ?? '',
    };

    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                                text: 'Editar',
                                onPressed: _confirmarActualizacionFicha,
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
                                onPressed: _confirmarEliminacionFicha,
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
          if (_cargando)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
