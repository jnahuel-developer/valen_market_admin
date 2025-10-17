import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class CustomWebPopupInformarPago extends ConsumerStatefulWidget {
  final void Function(double montoPagado, DateTime nuevaFechaAviso)?
      onConfirmar;

  const CustomWebPopupInformarPago({
    super.key,
    this.onConfirmar,
  });

  @override
  ConsumerState<CustomWebPopupInformarPago> createState() =>
      _CustomWebPopupInformarPagoState();
}

class _CustomWebPopupInformarPagoState
    extends ConsumerState<CustomWebPopupInformarPago> {
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'es_AR', symbol: '\$');

  late final TextEditingController _montoController;
  String _medioSeleccionado = 'Efectivo';
  bool _usarValorEstandar = true;

  final List<String> _mediosDisponibles = [
    'Efectivo',
    'Transferencia',
    'Mercado Pago',
    'Tarjeta',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    _montoController = TextEditingController();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _calcularMontoEstandar());
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  void _calcularMontoEstandar() {
    final ficha = ref.read(fichaEnCursoProvider);
    final productos = ficha.obtenerProductos();

    double sumaCuotas = 0.0;
    for (final p in productos) {
      sumaCuotas += (p.precioDeLasCuotas ?? 0).toDouble();
    }

    setState(() {
      _montoController.text = _currencyFormatter.format(sumaCuotas);
      _usarValorEstandar = true;
    });
  }

  double _parseMonto(String text) {
    final sanitized = text
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .replaceAll('\$', '')
        .trim();
    return double.tryParse(sanitized) ?? 0.0;
  }

  DateTime _normalizarSoloFecha(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  Future<void> _onRegistrarPago() async {
    final monto = _parseMonto(_montoController.text);
    if (monto <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese un monto válido mayor que 0')),
        );
      }
      return;
    }

    final hoy = DateTime.now();
    final fechaPago = _normalizarSoloFecha(hoy);

    final pagoMap = <String, dynamic>{
      FIELD_NAME__pago_item_model__Fecha: Timestamp.fromDate(fechaPago),
      FIELD_NAME__pago_item_model__Medio: _medioSeleccionado,
      FIELD_NAME__pago_item_model__Monto: monto.round(),
    };

    try {
      ref.read(fichaEnCursoProvider.notifier).registrarPago(pagoMap);

      final proximoAviso = ref.read(fichaEnCursoProvider).proximoAviso;
      final fechaAvisoFinal = proximoAviso != null
          ? _normalizarSoloFecha(proximoAviso)
          : _normalizarSoloFecha(DateTime.now());

      widget.onConfirmar?.call(monto, fechaAvisoFinal);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar pago: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ficha = ref.watch(fichaEnCursoProvider);

    // Datos provenientes del Provider central
    final productos = ficha.obtenerProductos();
    final pagos = ficha.obtenerPagos();

    // Datos de resumen
    final double totalFicha = pagos.importeTotal.toDouble();
    final double totalSaldado = pagos.importeSaldado.toDouble();
    final double restante = pagos.restante.toDouble();
    final double valorCuota = pagos.importeCuota.toDouble();
    final int cuotasPagas = pagos.cuotasPagas;
    final int cantidadDeCuotas = pagos.cantidadDeCuotas;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            VALUE__general_widget__campo__big_border_radius),
      ),
      child: Container(
        width: 900,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: WebColors.blanco,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Informar pago',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ─────────── BLOQUE PRODUCTOS ───────────
            Container(
              decoration: BoxDecoration(
                color: WebColors.plataTranslucida,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: Text('Producto')),
                    DataColumn(label: Text('Precio venta')),
                    DataColumn(label: Text('Unidades')),
                    DataColumn(label: Text('Precio cuota')),
                  ],
                  rows: productos.map((p) {
                    return DataRow(
                      cells: [
                        DataCell(Text(p.nombre ?? '')),
                        DataCell(Text(
                            _currencyFormatter.format(p.precioUnitario ?? 0))),
                        DataCell(Text('${p.unidades ?? 1}')),
                        DataCell(Text(_currencyFormatter
                            .format(p.precioDeLasCuotas ?? 0))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ─────────── BLOQUE RESUMEN DE PAGOS ───────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: WebColors.plataClara,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Importe total: ${_currencyFormatter.format(totalFicha)}'),
                  Text(
                      'Importe saldado: ${_currencyFormatter.format(totalSaldado)}'),
                  Text('Restante: ${_currencyFormatter.format(restante)}'),
                  Text('Cuotas pagas: $cuotasPagas / $cantidadDeCuotas'),
                  Text(
                      'Valor de cuota: ${_currencyFormatter.format(valorCuota)}'),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ─────────── BLOQUE PAGO ───────────
            Row(
              children: [
                Expanded(
                  child: CustomWebCampoConCheckboxTextField(
                    label: 'Usar valor estándar',
                    controller: _montoController,
                    isEditable: !_usarValorEstandar,
                    onCheckboxChanged: (v) {
                      setState(() {
                        _usarValorEstandar = v;
                        if (v) {
                          _calcularMontoEstandar();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    initialValue: _medioSeleccionado,
                    decoration: InputDecoration(
                      hintText: 'Medio de pago',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            VALUE__general_widget__campo__big_border_radius),
                        borderSide:
                            BorderSide(color: WebColors.bordeControlHabilitado),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            VALUE__general_widget__campo__big_border_radius),
                        borderSide:
                            BorderSide(color: WebColors.negro, width: 1.5),
                      ),
                    ),
                    items: _mediosDisponibles
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _medioSeleccionado = v);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ─────────── BLOQUE FECHAS ───────────
            const CustomWebFichaFechasSection(),

            const SizedBox(height: 30),

            // ─────────── BOTONES ───────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _onRegistrarPago,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.textoRosa,
                    foregroundColor: WebColors.blanco,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Registrar pago'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
