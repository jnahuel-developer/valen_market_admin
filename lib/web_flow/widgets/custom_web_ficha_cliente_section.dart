import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_dropdown_clientes.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/zonas_disponibles.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

class CustomWebClienteSection extends ConsumerStatefulWidget {
  final Map<String, dynamic>? clienteCargado;

  const CustomWebClienteSection({
    super.key,
    this.clienteCargado,
  });

  @override
  ConsumerState<CustomWebClienteSection> createState() =>
      CustomWebClienteSectionState();
}

class CustomWebClienteSectionState
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

  List<Map<String, dynamic>> _clientes = [];
  List<Map<String, dynamic>> _clientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();

    if (widget.clienteCargado != null) {
      _cargarCliente(widget.clienteCargado!);
    }
  }

  Future<void> _cargarClientes() async {
    try {
      final clientes =
          await ClientesServiciosFirebase.obtenerTodosLosClientes();
      setState(() {
        _clientes = clientes;
        _aplicarFiltros();
      });
    } catch (e) {
      // Error opcional
    }
  }

  void _seleccionarCliente(String? value) async {
    if (value == null) return;

    final cliente = _clientesFiltrados.firstWhere(
      (c) => _formatNombreCompleto(c) == value,
      orElse: () => {},
    );

    if (cliente.isNotEmpty) {
      _cargarCliente(cliente);

      // Actualizamos el provider con todos los datos directamente
      ref.read(fichaEnCursoProvider.notifier).actualizarDatosCliente(
            uidCliente: cliente['id'] ?? '',
            nombre: cliente['Nombre'] ?? '',
            apellido: cliente['Apellido'] ?? '',
            zona: cliente['Zona'] ?? '',
            direccion: cliente['Dirección'] ?? '',
            telefono: cliente['Teléfono'] ?? '',
          );
    }
  }

  void _cargarCliente(Map<String, dynamic> cliente) {
    setState(() {
      _clienteSeleccionado = _formatNombreCompleto(cliente);
      _nombreController.text = cliente['Nombre'] ?? '';
      _apellidoController.text = cliente['Apellido'] ?? '';
      _zonaSeleccionada = cliente['Zona'];
      _direccionController.text = cliente['Dirección'] ?? '';
      _telefonoController.text = cliente['Teléfono'] ?? '';
    });
  }

  void _aplicarFiltros() {
    var filtrados = _clientes;

    if (_nombreEditable && _nombreController.text.isNotEmpty) {
      filtrados = filtrados
          .where((c) =>
              (c['Nombre'] as String).toLowerCase() ==
              _nombreController.text.toLowerCase())
          .toList();
    }

    if (_apellidoEditable && _apellidoController.text.isNotEmpty) {
      filtrados = filtrados
          .where((c) =>
              (c['Apellido'] as String).toLowerCase() ==
              _apellidoController.text.toLowerCase())
          .toList();
    }

    if (_zonaEditable && _zonaSeleccionada != null) {
      filtrados = filtrados
          .where((c) =>
              (c['Zona'] as String).toLowerCase() ==
              _zonaSeleccionada!.toLowerCase())
          .toList();
    }

    setState(() {
      _clientesFiltrados = filtrados;
    });
  }

  String _formatNombreCompleto(Map<String, dynamic> cliente) {
    String nombre = cliente['Nombre'] ?? '';
    String apellido = cliente['Apellido'] ?? '';
    return '${_capitalizar(nombre)} ${_capitalizar(apellido)}';
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }

  // Método público para resetear todos los datos visuales
  void resetear() {
    setState(() {
      _clienteSeleccionado = null;
      _zonaSeleccionada = null;

      _nombreController.clear();
      _apellidoController.clear();
      _direccionController.clear();
      _telefonoController.clear();

      _nombreEditable = false;
      _apellidoEditable = false;
      _zonaEditable = false;

      _clientesFiltrados = _clientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
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
            clientes: _clientesFiltrados.map(_formatNombreCompleto).toList(),
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
              _aplicarFiltros();
            },
            onTextChanged: (_) {
              if (_nombreEditable) _aplicarFiltros();
            },
          ),
          const SizedBox(height: 20),
          CustomWebCampoConCheckboxTextField(
            label: 'Apellido',
            controller: _apellidoController,
            isEditable: _apellidoEditable,
            onCheckboxChanged: (value) {
              setState(() => _apellidoEditable = value);
              _aplicarFiltros();
            },
            onTextChanged: (_) {
              if (_apellidoEditable) _aplicarFiltros();
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
              _aplicarFiltros();
            },
            onChanged: (value) {
              setState(() => _zonaSeleccionada = value);
              if (_zonaEditable) _aplicarFiltros();
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
    );
  }
}
