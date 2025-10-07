import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_fecha_con_checkbox.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_dropdown_clientes.dart';
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
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  String? _clienteSeleccionado;
  String? _zonaSeleccionada;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  bool _nombreEditable = false;
  bool _apellidoEditable = false;
  bool _zonaEditable = false;
  bool _usarHoy = true;

  List<Map<String, dynamic>> _clientes = [];
  List<Map<String, dynamic>> _clientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _inicializarDesdeProvider();
  }

  void _inicializarDesdeProvider() {
    final ficha = ref.read(fichaEnCursoProvider);

    if (ficha.fechaDeVenta != null) {
      _fechaController.text = _formatter.format(ficha.fechaDeVenta!);
      _usarHoy = false;
    } else {
      _fechaController.text = _formatter.format(DateTime.now());
      _usarHoy = true;
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

      if (widget.clienteCargado != null) {
        _cargarCliente(widget.clienteCargado!);
      }
    } catch (_) {}
  }

  void _seleccionarCliente(String? value) async {
    if (value == null) return;

    final cliente = _clientesFiltrados.firstWhere(
      (c) => _formatNombreCompleto(c) == value,
      orElse: () => {},
    );

    if (cliente.isNotEmpty) {
      _cargarCliente(cliente);
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
      _zonaSeleccionada = cliente['Zona'] ?? '';
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
    setState(() => _clientesFiltrados = filtrados);
  }

  String _formatNombreCompleto(Map<String, dynamic> cliente) {
    String nombre = cliente['Nombre'] ?? '';
    String apellido = cliente['Apellido'] ?? '';
    return '${_capitalizar(nombre)} ${_capitalizar(apellido)}';
  }

  String _capitalizar(String texto) =>
      texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);

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
    return CustomWebBloqueConTitulo(
      titulo: 'Datos del cliente',
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
            onCheckboxChanged: (v) {
              setState(() => _nombreEditable = v);
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
            onCheckboxChanged: (v) {
              setState(() => _apellidoEditable = v);
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
            onCheckboxChanged: (v) {
              setState(() => _zonaEditable = v);
              _aplicarFiltros();
            },
            onChanged: (v) {
              setState(() => _zonaSeleccionada = v);
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
          const SizedBox(height: 20),
          CustomWebCampoFechaConCheckbox(
            label: TEXTO_ES__fichas_screen__campo__fecha_label,
            controller: _fechaController,
            usarHoy: _usarHoy,
            onCheckboxChanged: (v) {
              setState(() => _usarHoy = v);

              if (!v) {
                // Si el usuario activa el modo manual, no hacemos nada aún.
                // La fecha se actualizará cuando confirme el popup.
                debugPrint(
                    '📅 Modo manual activado, esperando selección de fecha.');
              } else {
                // Si marca usar hoy, tomamos la fecha actual y la guardamos en provider
                final hoy = DateTime.now();
                _fechaController.text = _formatter.format(hoy);
                debugPrint('📅 Usando fecha de hoy: $hoy');

                ref
                    .read(fichaEnCursoProvider.notifier)
                    .actualizarFechaDeVenta(hoy);
              }
            },
            onDateSelected: (fechaSeleccionada) {
              // ✅ Solo acá actualizamos la fecha en el provider
              debugPrint('🗓 Fecha confirmada desde popup: $fechaSeleccionada');

              ref
                  .read(fichaEnCursoProvider.notifier)
                  .actualizarFechaDeVenta(fechaSeleccionada);
            },
          ),
        ],
      ),
    );
  }
}
