import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class PopupResultadosBusqueda extends ConsumerStatefulWidget {
  final String criterio;
  final Function(Map<String, dynamic>) onFichaSeleccionada;

  const PopupResultadosBusqueda({
    super.key,
    required this.criterio,
    required this.onFichaSeleccionada,
  });

  @override
  ConsumerState<PopupResultadosBusqueda> createState() =>
      _PopupResultadosBusquedaState();
}

class _PopupResultadosBusquedaState
    extends ConsumerState<PopupResultadosBusqueda> {
  bool _cargando = true;
  List<Map<String, dynamic>> _resultados = [];
  String? _fichaSeleccionadaId;

  @override
  void initState() {
    super.initState();
    _cargarFichas();
  }

  Future<void> _cargarFichas() async {
    final ficha = ref
        .read(fichaEnCursoProvider); // ChangeNotifier con los métodos públicos
    List<FichaModel> fichasModel = [];

    try {
      switch (widget.criterio) {
        case 'Cliente seleccionado':
          final uidCliente = ficha.uidCliente;
          if (uidCliente == null || uidCliente.isEmpty) {
            Navigator.of(context).pop();
            return;
          }
          // Usa el método del provider que obtiene por UID
          fichasModel = await ficha.obtenerFichasMedianteID();
          break;

        case 'Nombre seleccionado':
          final nombre = ficha.nombreCliente;
          if (nombre == null || nombre.isEmpty) {
            Navigator.of(context).pop();
            return;
          }
          fichasModel = await ficha.obtenerFichasMedianteNombre();
          break;

        case 'Apellido seleccionado':
          final apellido = ficha.apellidoCliente;
          if (apellido == null || apellido.isEmpty) {
            Navigator.of(context).pop();
            return;
          }
          fichasModel = await ficha.obtenerFichasMedianteApellido();
          break;

        case 'Zona seleccionada':
          final zona = ficha.zonaCliente;
          if (zona == null || zona.isEmpty) {
            Navigator.of(context).pop();
            return;
          }
          fichasModel = await ficha.obtenerFichasMedianteZona();
          break;

        case 'Fecha de venta':
          // El provider ya tiene método que usa la fecha en su subprovider de fechas.
          fichasModel = await ficha.obtenerFichasMedianteFechaVenta();
          break;

        case 'Fecha de aviso':
          fichasModel = await ficha.obtenerFichasMedianteFechaAviso();
          break;

        default:
          fichasModel = [];
      }

      if (!mounted) return;

      // Convertir a mapas tal como esperan el UI/table.
      final resultados = fichasModel.map((f) {
        final mapa = f.toMap();
        // Asegurar que el ID esté presente y con la constante correcta
        mapa[FIELD_NAME__ficha_model__ID_De_Ficha] = f.id;
        return mapa;
      }).toList();

      setState(() {
        _resultados = resultados;
        _cargando = false;
        _fichaSeleccionadaId = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resultados = [];
        _cargando = false;
        _fichaSeleccionadaId = null;
      });
      // Mostrar error amigable
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar fichas: $e')),
      );
    }
  }

  Future<void> _confirmarSeleccion() async {
    if (_fichaSeleccionadaId == null) return;

    final fichaMap = _resultados.firstWhere(
      (f) => f[FIELD_NAME__ficha_model__ID_De_Ficha] == _fichaSeleccionadaId,
      orElse: () => {},
    );

    if (fichaMap.isEmpty) return;

    // Si el criterio no es “Cliente seleccionado”, debemos enriquecer cliente
    // para cargar en el provider (obtener datos del cliente)
    if (widget.criterio != 'Cliente seleccionado') {
      final uidCliente = fichaMap[FIELD_NAME__cliente_ficha_model__ID];
      if (uidCliente != null && (uidCliente as String).isNotEmpty) {
        final clienteData =
            await ClientesServiciosFirebase.obtenerClientePorId(uidCliente);
        if (clienteData != null) {
          fichaMap[FIELD_NAME__cliente_ficha_model__Nombre] =
              clienteData[FIELD_NAME__cliente_ficha_model__Nombre];
          fichaMap[FIELD_NAME__cliente_ficha_model__Apellido] =
              clienteData[FIELD_NAME__cliente_ficha_model__Apellido];
          fichaMap[FIELD_NAME__cliente_ficha_model__Zona] =
              clienteData[FIELD_NAME__cliente_ficha_model__Zona];
          fichaMap[FIELD_NAME__cliente_ficha_model__Direccion] =
              clienteData[FIELD_NAME__cliente_ficha_model__Direccion];
          fichaMap[FIELD_NAME__cliente_ficha_model__Telefono] =
              clienteData[FIELD_NAME__cliente_ficha_model__Telefono];
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente no encontrado')),
            );
          }
        }
      }
    }

    // Llamar al provider para que cargue toda la ficha desde el Map
    ref.read(fichaEnCursoProvider).cargarDesdeMap(fichaMap);

    widget.onFichaSeleccionada(fichaMap);

    // Luego navegar a pantalla de edición con algo de delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (context.mounted) {
        Navigator.pushNamed(context, PANTALLA_WEB__Fichas__Editar_Eliminar);
      }
    });
  }

  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return '';
    try {
      if (fecha is Timestamp) {
        final dt = fecha.toDate();
        return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      } else if (fecha is DateTime) {
        return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
      } else if (fecha is String) {
        final dt = DateTime.tryParse(fecha);
        if (dt != null) {
          return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
        }
      }
    } catch (_) {
      // Ignorar errores de parsing
    }
    return '';
  }

  Widget _buildTablaResultados() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('')),
          DataColumn(label: Text(FIELD_NAME__cliente_ficha_model__Nombre)),
          DataColumn(label: Text(FIELD_NAME__cliente_ficha_model__Apellido)),
          DataColumn(label: Text(FIELD_NAME__cliente_ficha_model__Zona)),
          DataColumn(label: Text(FIELD_NAME__ficha_model__Numero_De_Ficha)),
          DataColumn(
              label: Text(FIELD_NAME__fecha_ficha_model__Fecha_De_Venta)),
          DataColumn(
              label:
                  Text(FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso)),
          DataColumn(
              label: Text(FIELD_NAME__ficha_model__Cantidad_De_Productos)),
          DataColumn(label: Text(FIELD_NAME__pago_ficha_model__Cuotas_Pagas)),
          DataColumn(
              label: Text(FIELD_NAME__pago_ficha_model__Importe_Saldado)),
        ],
        rows: _resultados.map((ficha) {
          return DataRow(
            cells: [
              DataCell(Radio<String>(
                value: ficha[FIELD_NAME__ficha_model__ID_De_Ficha],
                groupValue: _fichaSeleccionadaId,
                onChanged: (value) {
                  setState(() {
                    _fichaSeleccionadaId = value;
                  });
                },
              )),
              DataCell(
                  Text(ficha[FIELD_NAME__cliente_ficha_model__Nombre] ?? '')),
              DataCell(
                  Text(ficha[FIELD_NAME__cliente_ficha_model__Apellido] ?? '')),
              DataCell(
                  Text(ficha[FIELD_NAME__cliente_ficha_model__Zona] ?? '')),
              DataCell(Text(
                  ficha[FIELD_NAME__ficha_model__Numero_De_Ficha]?.toString() ??
                      '')),
              DataCell(Text(_formatearFecha(
                  ficha[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta]))),
              DataCell(Text(_formatearFecha(ficha[
                  FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso]))),
              DataCell(Text(
                  ficha[FIELD_NAME__ficha_model__Cantidad_De_Productos]
                          ?.toString() ??
                      '')),
              DataCell(Text(ficha[FIELD_NAME__pago_ficha_model__Cuotas_Pagas]
                      ?.toString() ??
                  '0')),
              DataCell(Text(ficha[FIELD_NAME__pago_ficha_model__Importe_Saldado]
                      ?.toString() ??
                  '0')),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fichas para: ${widget.criterio}'),
      content: SizedBox(
        width: 1200,
        height: 500,
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
            : _resultados.isEmpty
                ? const Center(child: Text('No se encontraron fichas.'))
                : _buildTablaResultados(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _fichaSeleccionadaId == null ? null : _confirmarSeleccion,
          child: const Text('Confirmar selección'),
        ),
      ],
    );
  }
}
