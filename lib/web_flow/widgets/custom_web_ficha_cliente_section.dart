import 'package:flutter/material.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/Web_flow/widgets/custom_web_dropdown_clientes.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/clientes_mock.dart';
import 'package:valen_market_admin/constants/zonas_disponibles.dart';

class CustomWebClienteSection extends StatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  State<CustomWebClienteSection> createState() =>
      _CustomWebClienteSectionState();
}

class _CustomWebClienteSectionState extends State<CustomWebClienteSection> {
  List<Map<String, dynamic>> _clientesCompleto = clientesMock;
  List<Map<String, dynamic>> _clientesFiltrados = [];

  String? _clienteSeleccionadoNombreCompleto;
  String? _uidClienteSeleccionado;
  String? _zonaSeleccionada;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool _nombreEditable = false;
  bool _apellidoEditable = false;
  bool _zonaEditable = false;

  @override
  void initState() {
    super.initState();
    _clientesFiltrados = List.from(_clientesCompleto);
  }

  void _filtrarClientes() {
    List<Map<String, dynamic>> resultado = List.from(_clientesCompleto);

    if (_nombreEditable && _nombreController.text.trim().isNotEmpty) {
      resultado = resultado
          .where((c) => c['nombre'] == _nombreController.text.trim())
          .toList();
    }

    if (_apellidoEditable && _apellidoController.text.trim().isNotEmpty) {
      resultado = resultado
          .where((c) => c['apellido'] == _apellidoController.text.trim())
          .toList();
    }

    if (_zonaEditable && _zonaSeleccionada != null) {
      resultado =
          resultado.where((c) => c['zona'] == _zonaSeleccionada).toList();
    }

    setState(() {
      _clientesFiltrados = resultado;
      if (!_clientesFiltrados.any((c) =>
          '${c['nombre']} ${c['apellido']}' ==
          _clienteSeleccionadoNombreCompleto)) {
        _clienteSeleccionadoNombreCompleto = null;
        _uidClienteSeleccionado = null;
        _limpiarCampos();
      }
    });
  }

  void _limpiarCampos() {
    if (!_nombreEditable) {
      _nombreController.clear();
    }
    if (!_apellidoEditable) {
      _apellidoController.clear();
    }
    if (!_zonaEditable) {
      _zonaSeleccionada = null;
    }

    // Siempre limpiar dirección y teléfono
    _direccionController.clear();
    _telefonoController.clear();
  }

  void _onSeleccionCliente(String? nombreCompleto) {
    setState(() {
      _clienteSeleccionadoNombreCompleto = nombreCompleto;

      final cliente = _clientesCompleto.firstWhere(
        (c) => '${c['nombre']} ${c['apellido']}' == nombreCompleto,
        orElse: () => {},
      );

      if (cliente.isNotEmpty) {
        _uidClienteSeleccionado = cliente['uid'];
        _nombreController.text = cliente['nombre'] ?? '';
        _apellidoController.text = cliente['apellido'] ?? '';
        _zonaSeleccionada = cliente['zona'];
        _direccionController.text = cliente['direccion'] ?? '';
        _telefonoController.text = cliente['telefono'] ?? '';
      }
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
            clientes: _clientesFiltrados.isNotEmpty
                ? _clientesFiltrados
                    .map((c) => '${c['nombre']} ${c['apellido']}')
                    .toList()
                : ['No hay datos'],
            clienteSeleccionado: _clienteSeleccionadoNombreCompleto,
            onChanged: _onSeleccionCliente,
          ),
          const SizedBox(height: 25),
          CustomWebCampoConCheckboxTextField(
            label: 'Nombre',
            controller: _nombreController,
            isEditable: _nombreEditable,
            onCheckboxChanged: (value) {
              setState(() => _nombreEditable = value);
              _filtrarClientes();
            },
            onTextChanged: (_) => _filtrarClientes(),
          ),
          const SizedBox(height: 20),
          CustomWebCampoConCheckboxTextField(
            label: 'Apellido',
            controller: _apellidoController,
            isEditable: _apellidoEditable,
            onCheckboxChanged: (value) {
              setState(() => _apellidoEditable = value);
              _filtrarClientes();
            },
            onTextChanged: (_) => _filtrarClientes(),
          ),
          const SizedBox(height: 20),
          CustomWebCampoConCheckboxDropdown(
            label: 'Zona',
            options: zonasDisponibles,
            selectedOption: _zonaSeleccionada,
            isEditable: _zonaEditable,
            onCheckboxChanged: (value) {
              setState(() => _zonaEditable = value);
              _filtrarClientes();
            },
            onChanged: (value) {
              setState(() {
                _zonaSeleccionada = value;
              });
              _filtrarClientes();
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
