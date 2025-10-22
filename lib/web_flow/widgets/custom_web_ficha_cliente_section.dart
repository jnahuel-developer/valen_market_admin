import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/zonas_disponibles.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_dropdown_clientes.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_dropdown.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_sin_checkbox_textfield.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';

class CustomWebClienteSection extends ConsumerStatefulWidget {
  const CustomWebClienteSection({super.key});

  @override
  ConsumerState<CustomWebClienteSection> createState() =>
      CustomWebClienteSectionState();
}

class CustomWebClienteSectionState
    extends ConsumerState<CustomWebClienteSection> {
  // Estado local
  List<Map<String, dynamic>> _clientes = [];
  List<Map<String, dynamic>> _clientesFiltrados = [];

  // Filtros
  bool _filterNombre = false;
  bool _filterApellido = false;
  bool _filterZona = false;

  String _textoNombreFiltro = '';
  String _textoApellidoFiltro = '';
  String? _zonaFiltro;

  String? _clienteSeleccionadoNombreCompleto;

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _apellidoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarClientesDesdeFirebase();
  }

  // ---------------------- CARGA INICIAL ----------------------
  Future<void> _cargarClientesDesdeFirebase() async {
    try {
      debugPrint('🔹 Cargando lista de clientes desde Firebase...');
      final lista = await ClientesServiciosFirebase.obtenerTodosLosClientes();
      setState(() {
        _clientes = lista;
        _aplicarFiltros();
      });

      // Si la ficha actual tiene datos, preseleccionar el cliente
      final ficha = ref.read(fichaEnCursoProvider);
      final clienteFicha = ficha.obtenerCliente();
      final idFicha = clienteFicha[FIELD_NAME__cliente_ficha_model__ID];

      if (idFicha != null && idFicha.toString().isNotEmpty) {
        debugPrint('🔹 Ficha tiene cliente preexistente: ID=$idFicha');
        final clienteCoincidente = lista.firstWhere(
          (c) =>
              c[FIELD_NAME__cliente_ficha_model__ID].toString() ==
              idFicha.toString(),
          orElse: () => {},
        );
        if (clienteCoincidente.isNotEmpty) {
          final nombreCompleto = _formatNombreCompleto(clienteCoincidente);
          debugPrint('🔹 Seleccionando cliente en dropdown: $nombreCompleto');
          setState(() {
            _clienteSeleccionadoNombreCompleto = nombreCompleto;
            _nombreCtrl.text = _capitalizar(
                clienteCoincidente[FIELD_NAME__cliente_ficha_model__Nombre] ??
                    '');
            _apellidoCtrl.text = _capitalizar(
                clienteCoincidente[FIELD_NAME__cliente_ficha_model__Apellido] ??
                    '');
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error al cargar clientes: $e');
    }
  }

  // ---------------------- FILTROS ----------------------
  void _aplicarFiltros() {
    debugPrint('🔹 Aplicando filtros...');
    var filtrados = _clientes;

    if (_filterNombre && _textoNombreFiltro.isNotEmpty) {
      filtrados = filtrados.where((c) {
        final nombre = (c[FIELD_NAME__cliente_ficha_model__Nombre] ?? '')
            .toString()
            .toLowerCase();
        return nombre.contains(_textoNombreFiltro.toLowerCase());
      }).toList();
    }

    if (_filterApellido && _textoApellidoFiltro.isNotEmpty) {
      filtrados = filtrados.where((c) {
        final apellido = (c[FIELD_NAME__cliente_ficha_model__Apellido] ?? '')
            .toString()
            .toLowerCase();
        return apellido.contains(_textoApellidoFiltro.toLowerCase());
      }).toList();
    }

    if (_filterZona && _zonaFiltro != null && _zonaFiltro!.isNotEmpty) {
      filtrados = filtrados.where((c) {
        final zona = (c[FIELD_NAME__cliente_ficha_model__Zona] ?? '')
            .toString()
            .toLowerCase();
        return zona == _zonaFiltro!.toLowerCase();
      }).toList();
    }

    setState(() {
      _clientesFiltrados = filtrados;
    });

    debugPrint('🔹 Clientes filtrados: ${_clientesFiltrados.length}');
  }

  // ---------------------- SELECCIÓN ----------------------
  String _formatNombreCompleto(Map<String, dynamic> c) {
    final n = (c[FIELD_NAME__cliente_ficha_model__Nombre] ?? '').toString();
    final a = (c[FIELD_NAME__cliente_ficha_model__Apellido] ?? '').toString();
    return '${_capitalizar(n)} ${_capitalizar(a)}'.trim();
  }

  String _capitalizar(String s) =>
      s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1).toLowerCase();

  void _onDropdownChanged(String? nombreCompleto) {
    if (nombreCompleto == null) return;

    debugPrint('🔹 Cliente seleccionado: $nombreCompleto');

    final clienteMap = _clientesFiltrados.firstWhere(
      (c) => _formatNombreCompleto(c) == nombreCompleto,
      orElse: () => {},
    );

    if (clienteMap.isNotEmpty) {
      setState(() {
        _clienteSeleccionadoNombreCompleto = nombreCompleto;
        _nombreCtrl.text = _capitalizar(
            clienteMap[FIELD_NAME__cliente_ficha_model__Nombre] ?? '');
        _apellidoCtrl.text = _capitalizar(
            clienteMap[FIELD_NAME__cliente_ficha_model__Apellido] ?? '');
      });

      final mapToEnviar = {
        FIELD_NAME__cliente_ficha_model__ID:
            clienteMap[FIELD_NAME__cliente_ficha_model__ID] ?? '',
        FIELD_NAME__cliente_ficha_model__Nombre:
            clienteMap[FIELD_NAME__cliente_ficha_model__Nombre] ?? '',
        FIELD_NAME__cliente_ficha_model__Apellido:
            clienteMap[FIELD_NAME__cliente_ficha_model__Apellido] ?? '',
        FIELD_NAME__cliente_ficha_model__Zona:
            clienteMap[FIELD_NAME__cliente_ficha_model__Zona] ?? '',
        FIELD_NAME__cliente_ficha_model__Direccion:
            clienteMap[FIELD_NAME__cliente_ficha_model__Direccion] ?? '',
        FIELD_NAME__cliente_ficha_model__Telefono:
            clienteMap[FIELD_NAME__cliente_ficha_model__Telefono] ?? '',
      };

      debugPrint('🔹 Enviando cliente al provider: $mapToEnviar');
      ref.read(fichaEnCursoProvider.notifier).actualizarCliente(mapToEnviar);
    } else {
      debugPrint('⚠️ No se encontró coincidencia para $nombreCompleto');
    }
  }

  void _onNombreFiltroChanged(String nuevo) {
    _textoNombreFiltro = _capitalizar(nuevo.trim());
    _aplicarFiltros();
  }

  void _onApellidoFiltroChanged(String nuevo) {
    _textoApellidoFiltro = _capitalizar(nuevo.trim());
    _aplicarFiltros();
  }

  void _onZonaFiltroChanged(String? zona) {
    _zonaFiltro = zona;
    _aplicarFiltros();
  }

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    final ficha = ref.watch(fichaEnCursoProvider);
    final cliente = ficha.obtenerCliente();

    final nombre = cliente[FIELD_NAME__cliente_ficha_model__Nombre] ?? '';
    final apellido = cliente[FIELD_NAME__cliente_ficha_model__Apellido] ?? '';
    final zona = cliente[FIELD_NAME__cliente_ficha_model__Zona];

    if (!_filterNombre) _nombreCtrl.text = _capitalizar(nombre);
    if (!_filterApellido) _apellidoCtrl.text = _capitalizar(apellido);

    debugPrint(
        '🔹 Construyendo UI de cliente. Cliente actual en ficha: $cliente');

    return CustomWebBloqueConTitulo(
      titulo: 'Datos del cliente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWebDropdownClientes(
            clientes: _clientesFiltrados.map(_formatNombreCompleto).toList(),
            clienteSeleccionado: _clienteSeleccionadoNombreCompleto,
            onChanged: _onDropdownChanged,
          ),
          const SizedBox(height: 20),

          CustomWebCampoConCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Nombre,
            controller: _nombreCtrl,
            isEditable: _filterNombre,
            onCheckboxChanged: (v) {
              setState(() => _filterNombre = v);
              _aplicarFiltros();
            },
            onTextChanged: (s) {
              if (_filterNombre) _onNombreFiltroChanged(s);
            },
          ),
          const SizedBox(height: 20),

          CustomWebCampoConCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Apellido,
            controller: _apellidoCtrl,
            isEditable: _filterApellido,
            onCheckboxChanged: (v) {
              setState(() => _filterApellido = v);
              _aplicarFiltros();
            },
            onTextChanged: (s) {
              if (_filterApellido) _onApellidoFiltroChanged(s);
            },
          ),
          const SizedBox(height: 20),

          CustomWebCampoConCheckboxDropdown(
            label: FIELD_NAME__cliente_ficha_model__Zona,
            options: zonasDisponibles,
            selectedOption: zona,
            isEditable: _filterZona,
            onCheckboxChanged: (v) {
              setState(() => _filterZona = v);
              _aplicarFiltros();
            },
            onChanged: _onZonaFiltroChanged,
          ),
          const SizedBox(height: 20),

          // Dirección
          const CustomWebCampoSinCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Direccion,
            isDireccion: true,
          ),
          const SizedBox(height: 20),

          // Teléfono
          const CustomWebCampoSinCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Telefono,
            isDireccion: false,
          ),
        ],
      ),
    );
  }
}
