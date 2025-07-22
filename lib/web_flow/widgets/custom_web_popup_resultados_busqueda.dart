import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valen_market_admin/Web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/services/firebase/fichas_servicios_firebase.dart';
import 'package:valen_market_admin/services/firebase/clientes_servicios_firebase.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class PopupResultadosBusqueda extends ConsumerStatefulWidget {
  final String criterio;
  final Function(Map<String, dynamic> fichaSeleccionada) onFichaSeleccionada;

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
    final fichasService = FichasServiciosFirebase();

    if (widget.criterio == 'Cliente seleccionado') {
      final uidCliente = ref.read(fichaEnCursoProvider).uidCliente;

      if (uidCliente == null || uidCliente.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      final resultados =
          await fichasService.buscarFichasPorClienteId(uidCliente);

      if (!mounted) return;
      setState(() {
        _resultados = resultados;
        _cargando = false;
      });
    } else if (widget.criterio == 'Nombre seleccionado') {
      final nombre = ref.read(fichaEnCursoProvider).nombreCliente;

      if (nombre == null || nombre.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      final resultados = await fichasService.buscarFichasPorNombre(nombre);

      if (!mounted) return;
      setState(() {
        _resultados = resultados;
        _cargando = false;
      });
    } else if (widget.criterio == 'Apellido seleccionado') {
      final apellido = ref.read(fichaEnCursoProvider).apellidoCliente;

      if (apellido == null || apellido.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      final resultados = await fichasService.buscarFichasPorApellido(apellido);

      if (!mounted) return;
      setState(() {
        _resultados = resultados;
        _cargando = false;
      });
    } else if (widget.criterio == 'Zona seleccionada') {
      final zona = ref.read(fichaEnCursoProvider).zonaCliente;

      if (zona == null || zona.isEmpty) {
        Navigator.of(context).pop();
        return;
      }

      final resultados = await fichasService.buscarFichasPorZona(zona);

      if (!mounted) return;
      setState(() {
        _resultados = resultados;
        _cargando = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<void> _confirmarSeleccion() async {
    if (_fichaSeleccionadaId == null) return;

    final ficha = _resultados.firstWhere(
      (f) => f['id'] == _fichaSeleccionadaId,
    );

    if (widget.criterio == 'Cliente seleccionado') {
      ref.read(fichaEnCursoProvider.notifier).cargarSoloDatosDeFichaYProductos(
            ficha,
            fichaId: ficha['id'],
          );
    } else {
      final String? uidCliente = ficha['UID_Cliente'];
      if (uidCliente != null && uidCliente.isNotEmpty) {
        final clienteData =
            await ClientesServiciosFirebase.obtenerClientePorId(uidCliente);

        if (clienteData != null) {
          ficha['Nombre'] = clienteData['Nombre'];
          ficha['Apellido'] = clienteData['Apellido'];
          ficha['Zona'] = clienteData['Zona'];
          ficha['Dirección'] = clienteData['Dirección'];
          ficha['Teléfono'] = clienteData['Teléfono'];

          ref.read(fichaEnCursoProvider.notifier).cargarFichaDesdeMapa(
                ficha,
                fichaId: ficha['id'],
              );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente no encontrado')),
            );
          }
        }
      }
    }

    widget.onFichaSeleccionada(ficha);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          PANTALLA_WEB__Fichas__Editar_Eliminar,
        );
      }
    });
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

  Widget _buildTablaResultados() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Apellido')),
          DataColumn(label: Text('Zona')),
          DataColumn(label: Text('Ficha')),
          DataColumn(label: Text('Venta')),
          DataColumn(label: Text('Productos')),
          DataColumn(label: Text('Cuotas pagas')),
          DataColumn(label: Text('Restante')),
        ],
        rows: _resultados.map((ficha) {
          return DataRow(
            cells: [
              DataCell(
                Radio<String>(
                  value: ficha['id'],
                  groupValue: _fichaSeleccionadaId,
                  onChanged: (value) {
                    setState(() {
                      _fichaSeleccionadaId = value;
                    });
                  },
                ),
              ),
              DataCell(Text(ficha['Nombre'] ?? '')),
              DataCell(Text(ficha['Apellido'] ?? '')),
              DataCell(Text(ficha['Zona'] ?? '')),
              DataCell(Text(ficha['Nro_de_ficha']?.toString() ?? '')),
              DataCell(Text(_formatearFecha(ficha['Fecha_de_Venta']))),
              DataCell(Text(ficha['Cantidad_de_Productos']?.toString() ?? '')),
              DataCell(Text(ficha['Nro_de_cuotas_pagadas']?.toString() ?? '0')),
              DataCell(Text(ficha['Restante']?.toString() ?? '0')),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return '';

    if (fecha is Timestamp) {
      final dt = fecha.toDate();
      return '${dt.day}/${dt.month}/${dt.year}';
    }

    return '';
  }
}
