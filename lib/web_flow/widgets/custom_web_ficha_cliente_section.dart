/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_CLIENTE_SECTION
///
/// 🔹 Rol:
///   Desplegar los widgets relacionados al cliente dentro de la ficha: selección,
///   edición de nombre / apellido / zona, visualización de dirección y teléfono.
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider] (a través de su Notifier):
///       • Lectura del cliente actual (nombre, apellido, zona, dirección y teléfono)
///       • Solicitar la carga de todos los clientes disponibles (Map<String,dynamic>)
///       • Actualizar cliente actual mediante `actualizarCliente(Map<String, dynamic>)`
///   - Widgets hijos:
///       • `CustomWebDropdownClientes` → muestra lista filtrada de nombres completos
///       • `CustomWebCampoConCheckboxTextField` → nombre / apellido con checkbox
///       • `CustomWebCampoConCheckboxDropdown` → zona con checkbox
///       • `CustomWebCampoSinCheckboxTextField` → dirección / teléfono (solo lectura)
///
/// 🔹 Lógica:
///   - En initState, solicita al provider (o al notifier) la carga de la lista de clientes.
///   - Se mantiene internamente la lista `_clientes` (Map) y una versión filtrada `_clientesFiltrados`.
///   - Los filtros de nombre/apellido/zona se aplican sobre `_clientes`, generando `_clientesFiltrados`.
///   - Se pasa la lista de nombres completos filtrados a `CustomWebDropdownClientes`.
///   - Cuando el usuario selecciona un cliente, construye un Map con los campos correctos y llama
///     `provider.notifier.actualizarCliente(clienteMap)`.
///   - Los campos de edición y dropdown de zona solo envían sus cambios locales al contenedor, que reconstruye
///     el `clienteMap` y llama de nuevo al Notifier.
///
/// ---------------------------------------------------------------------------
library;

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

  Future<void> _cargarClientesDesdeFirebase() async {
    try {
      final lista = await ClientesServiciosFirebase.obtenerTodosLosClientes();
      setState(() {
        _clientes = lista;
        _aplicarFiltros();
      });
    } catch (e) {
      debugPrint('Error al cargar clientes: $e');
    }
  }

  void _aplicarFiltros() {
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
  }

  String _formatNombreCompleto(Map<String, dynamic> c) {
    final n = (c[FIELD_NAME__cliente_ficha_model__Nombre] ?? '').toString();
    final a = (c[FIELD_NAME__cliente_ficha_model__Apellido] ?? '').toString();
    return '${_capitalizar(n)} ${_capitalizar(a)}'.trim();
  }

  String _capitalizar(String s) =>
      s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);

  void _onDropdownChanged(String? nombreCompleto) {
    if (nombreCompleto == null) return;

    final clienteMap = _clientesFiltrados.firstWhere(
      (c) => _formatNombreCompleto(c) == nombreCompleto,
      orElse: () => {},
    );

    if (clienteMap.isNotEmpty) {
      // Guarda selección local
      setState(() {
        _clienteSeleccionadoNombreCompleto = nombreCompleto;
      });

      // Construir map para actualizar en el provider
      final mapToEnviar = <String, dynamic>{
        FIELD_NAME__cliente_ficha_model__UID:
            clienteMap[FIELD_NAME__cliente_ficha_model__UID] ??
                clienteMap[FIELD_NAME__cliente_ficha_model__UID] ??
                '',
        FIELD_NAME__cliente_ficha_model__Nombre:
            clienteMap[FIELD_NAME__cliente_ficha_model__Nombre] ?? '',
        FIELD_NAME__cliente_ficha_model__Apellido:
            clienteMap[FIELD_NAME__cliente_ficha_model__Apellido] ?? '',
        FIELD_NAME__cliente_ficha_model__Zona:
            clienteMap[FIELD_NAME__cliente_ficha_model__Zona] ?? '',
        FIELD_NAME__cliente_ficha_model__Direccion:
            clienteMap[FIELD_NAME__cliente_ficha_model__Direccion] ??
                clienteMap[FIELD_NAME__cliente_ficha_model__Direccion] ??
                '',
        FIELD_NAME__cliente_ficha_model__Telefono:
            clienteMap[FIELD_NAME__cliente_ficha_model__Telefono] ??
                clienteMap[FIELD_NAME__cliente_ficha_model__Telefono] ??
                '',
      };

      ref.read(fichaEnCursoProvider.notifier).actualizarCliente(mapToEnviar);
    }
  }

  void _onNombreFiltroChanged(String nuevo) {
    _textoNombreFiltro = nuevo.trim();
    _aplicarFiltros();
  }

  void _onApellidoFiltroChanged(String nuevo) {
    _textoApellidoFiltro = nuevo.trim();
    _aplicarFiltros();
  }

  void _onZonaFiltroChanged(String? zona) {
    _zonaFiltro = zona;
    _aplicarFiltros();
  }

  @override
  Widget build(BuildContext context) {
    final ficha = ref.watch(fichaEnCursoProvider);
    // Asegurar que el controlador refleje los valores actuales del provider cuando no se esté editando
    if (!_filterNombre) _nombreCtrl.text = ficha.nombreCliente ?? '';
    if (!_filterApellido) _apellidoCtrl.text = ficha.apellidoCliente ?? '';

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
              setState(() {
                _filterNombre = v;
              });
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
              setState(() {
                _filterApellido = v;
              });
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
            selectedOption: ficha.zonaCliente,
            isEditable: _filterZona,
            onCheckboxChanged: (v) {
              setState(() {
                _filterZona = v;
              });
              _aplicarFiltros();
            },
            onChanged: (zona) {
              _onZonaFiltroChanged(zona);
            },
          ),
          const SizedBox(height: 20),
          const CustomWebCampoSinCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Direccion,
            isDireccion: true,
          ),
          const SizedBox(height: 20),
          const CustomWebCampoSinCheckboxTextField(
            label: FIELD_NAME__cliente_ficha_model__Telefono,
            isDireccion: false,
          ),
        ],
      ),
    );
  }
}
