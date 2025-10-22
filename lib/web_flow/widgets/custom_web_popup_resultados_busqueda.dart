import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/textos.dart';
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
    try {
      final fichaProvider = ref.read(fichaEnCursoProvider);
      final resultados =
          await fichaProvider.buscarFichasPorCriterio(widget.criterio);

      if (!mounted) return;
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
      });
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

    // Si el criterio no fue "Cliente seleccionado", completar los datos del cliente
    if (widget.criterio !=
        TEXTO__resultados_widget__criterio__cliente_seleccionado) {
      final uidCliente = fichaMap[FIELD_NAME__cliente_ficha_model__ID];
      if (uidCliente != null && (uidCliente as String).isNotEmpty) {
        final clienteData =
            await ClientesServiciosFirebase.obtenerClientePorId(uidCliente);
        if (clienteData != null) {
          fichaMap[FIELD_NAME__ficha_model__Cliente] = clienteData;
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente no encontrado')),
            );
          }
        }
      }
    }

    // Cargar la ficha seleccionada en el Provider
    await ref
        .read(fichaEnCursoProvider)
        .inicializarDesdeFichaExistente(fichaMap);

    widget.onFichaSeleccionada(fichaMap);

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
    } catch (_) {}
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
          DataColumn(
              label: Text(FIELD_NAME__fecha_ficha_model__Fecha_De_Venta)),
          DataColumn(
              label:
                  Text(FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso)),
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
              DataCell(Text(ficha['Cliente']
                      ?[FIELD_NAME__cliente_ficha_model__Nombre] ??
                  '')),
              DataCell(Text(ficha['Cliente']
                      ?[FIELD_NAME__cliente_ficha_model__Apellido] ??
                  '')),
              DataCell(Text(ficha['Cliente']
                      ?[FIELD_NAME__cliente_ficha_model__Zona] ??
                  '')),
              DataCell(Text(_formatearFecha(ficha['Fechas']
                  ?[FIELD_NAME__fecha_ficha_model__Fecha_De_Venta]))),
              DataCell(Text(_formatearFecha(ficha['Fechas']
                  ?[FIELD_NAME__fecha_ficha_model__Fecha_De_Proximo_Aviso]))),
              DataCell(Text(ficha['Pagos']
                          ?[FIELD_NAME__pago_ficha_model__Importe_Saldado]
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
        width: 1000,
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
