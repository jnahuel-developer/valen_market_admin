import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_dropdown_clientes.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_gradient_button.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_popup_resultados_busqueda.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_popup_selector_criterio_busqueda.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/clientes_mock.dart';
import 'package:valen_market_admin/constants/zonas_disponibles.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';

final fichasService = FichasServiciosFirebase();

class CustomWebClienteSection extends ConsumerStatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  ConsumerState<CustomWebClienteSection> createState() =>
      _CustomWebClienteSectionState();
}

class _CustomWebClienteSectionState
    extends ConsumerState<CustomWebClienteSection> {
  String? _clienteSeleccionado;
  String? _zonaSeleccionada;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _nombreEditable = false;
  bool _apellidoEditable = false;
  bool _zonaEditable = false;

  void _seleccionarCliente(String? value) {
    if (value == null) {
      print('⚠️ Cliente seleccionado es null');
      return;
    }

    setState(() {
      _clienteSeleccionado = value;
      final cliente = clientesMock.firstWhere(
        (c) => '${c['nombre']} ${c['apellido']}' == value,
        orElse: () => {},
      );

      _nombreController.text = cliente['nombre'] ?? '';
      _apellidoController.text = cliente['apellido'] ?? '';
      _zonaSeleccionada = cliente['zona'];
      _direccionController.text = cliente['direccion'] ?? '';
      _telefonoController.text = cliente['telefono'] ?? '';

      final uidCliente = cliente['UID'];
      if (uidCliente == null || uidCliente.isEmpty) {
        print('❌ Error: el cliente seleccionado no tiene UID válido.');
      } else {
        print('✅ Cliente seleccionado: $uidCliente');
        ref.read(fichaEnCursoProvider.notifier).seleccionarCliente(uidCliente);
      }
    });
  }

  Future<void> _agregarFicha() async {
    final fichaEnCurso = ref.read(fichaEnCursoProvider);

    print('📦 Estado actual antes de guardar ficha:');
    print('UID Cliente: ${fichaEnCurso.uidCliente}');
    print(
        'Cantidad de productos seleccionados: ${fichaEnCurso.productos.length}');

    if (!fichaEnCurso.esValida) {
      print('❌ La ficha no es válida. Cliente o productos faltantes.');
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
      print('ℹ️ Provider limpiado después de guardar');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ficha guardada exitosamente.')),
      );

      // Limpiar UI opcional
      setState(() {
        _clienteSeleccionado = null;
      });
    } catch (e) {
      print('❌ Error al guardar la ficha: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la ficha: $e')),
      );
    }
  }

  Future<void> _buscarFichas() async {
    final criterioSeleccionado = await showDialog<String>(
      context: context,
      builder: (context) => PopupSelectorCriterioBusqueda(
        onCriterioSeleccionado: (criterio) {
          Navigator.of(context).pop(criterio);
        },
      ),
    );

    if (criterioSeleccionado != null) {
      await showDialog(
        context: context,
        builder: (context) => PopupResultadosBusqueda(
          criterio: criterioSeleccionado,
          onFichaSeleccionada: (ficha) {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: WebColors.blanco,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WebColors.bordeRosa, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWebDropdownClientes(
                clientes: clientesMock
                    .map((c) => '${c['nombre']} ${c['apellido']}')
                    .toList(),
                clienteSeleccionado: _clienteSeleccionado,
                onChanged: _seleccionarCliente,
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxTextField(
                label: 'Nombre',
                controller: _nombreController,
                isEditable: _nombreEditable,
                onCheckboxChanged: (value) {
                  setState(() => _nombreEditable = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxTextField(
                label: 'Apellido',
                controller: _apellidoController,
                isEditable: _apellidoEditable,
                onCheckboxChanged: (value) {
                  setState(() => _apellidoEditable = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoConCheckboxDropdown(
                label: 'Zona',
                options: zonasDisponibles,
                selectedOption: _zonaSeleccionada,
                isEditable: _zonaEditable,
                onCheckboxChanged: (value) {
                  setState(() => _zonaEditable = value);
                },
                onChanged: (value) {
                  setState(() => _zonaSeleccionada = value);
                },
              ),
              const SizedBox(height: 20),
              CustomWebCampoSinCheckboxTextField(
                label: 'Dirección',
                controller: _direccionController,
              ),
              const SizedBox(height: 20),
              CustomWebCampoSinCheckboxTextField(
                label: 'Teléfono',
                controller: _telefonoController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Contenedor para los botones en formato grilla 2x2
        LayoutBuilder(
          builder: (context, constraints) {
            final double buttonWidth = (constraints.maxWidth / 2) - 50;

            return Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                CustomGradientButton(
                  text: 'Agregar',
                  width: buttonWidth,
                  onPressed: _agregarFicha,
                ),
                CustomGradientButton(
                  text: 'Buscar',
                  width: buttonWidth,
                  onPressed: () => _buscarFichas(),
                ),
                CustomGradientButton(
                  text: 'Editar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
                CustomGradientButton(
                  text: 'Eliminar',
                  width: buttonWidth,
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
