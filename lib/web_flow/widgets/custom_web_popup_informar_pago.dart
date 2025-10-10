import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_con_checkbox_textfield.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_fechas_section.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_en_curso_model.dart';

class CustomWebPopupInformarPago extends StatefulWidget {
  final FichaEnCurso ficha;
  final Function(double montoPagado, DateTime nuevaFechaAviso) onConfirmar;

  const CustomWebPopupInformarPago({
    super.key,
    required this.ficha,
    required this.onConfirmar,
  });

  @override
  State<CustomWebPopupInformarPago> createState() =>
      _CustomWebPopupInformarPagoState();
}

class _CustomWebPopupInformarPagoState
    extends State<CustomWebPopupInformarPago> {
  final NumberFormat _formatter =
      NumberFormat.currency(locale: 'es_AR', symbol: '\$');
  late TextEditingController _montoController;
  bool _usarValorEstandar = true;

  @override
  void initState() {
    super.initState();
    _montoController = TextEditingController();
    _calcularMontoEstandar();
  }

  void _calcularMontoEstandar() {
    double total = 0;
    for (final p in widget.ficha.productos) {
      if ((p.cuotasPagas ?? 0) < (p.cantidadDeCuotas ?? 1)) {
        total += p.precioDeLasCuotas ?? 0;
      }
    }
    _montoController.text = _formatter.format(total);
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  double _parseMonto(String text) {
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.')) ??
        0.0;
  }

  @override
  Widget build(BuildContext context) {
    final productos = widget.ficha.productos;

    // --- Cálculos generales ---
    final double totalFicha =
        productos.fold(0, (sum, p) => sum + (p.precioUnitario ?? 0));
    final double totalSaldado =
        productos.fold(0, (sum, p) => sum + (p.totalSaldado ?? 0));
    final int maxCuotas = productos.fold(
        0, (max, p) => p.cantidadDeCuotas > max ? p.cantidadDeCuotas : max);
    final double valorCuotaEstandar =
        productos.fold(0, (sum, p) => sum + (p.precioDeLasCuotas ?? 0));

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
                child: DataTable(
                  columnSpacing: 16,
                  columns: const [
                    DataColumn(label: Text('Producto')),
                    DataColumn(label: Text('Precio venta')),
                    DataColumn(label: Text('Unidades')),
                    DataColumn(label: Text('Precio cuota')),
                    DataColumn(label: Text('Pagadas / Totales')),
                    DataColumn(label: Text('Saldado')),
                    DataColumn(label: Text('Restante')),
                  ],
                  rows: productos.map((p) {
                    return DataRow(
                      cells: [
                        DataCell(Text(p.nombreProducto)),
                        DataCell(Text(_formatter.format(p.precioUnitario))),
                        DataCell(Text('${p.unidades ?? 1}')),
                        DataCell(Text(_formatter.format(p.precioDeLasCuotas))),
                        DataCell(
                            Text('${p.cuotasPagas} / ${p.cantidadDeCuotas}')),
                        DataCell(Text(_formatter.format(p.totalSaldado ?? 0))),
                        DataCell(Text(_formatter.format(p.restante ?? 0))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ─────────── BLOQUE RESUMEN ───────────
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
                  Text('Total ficha: ${_formatter.format(totalFicha)}'),
                  Text('Total saldado: ${_formatter.format(totalSaldado)}'),
                  Text('Cuotas restantes: $maxCuotas'),
                  Text(
                      'Valor estándar de cuota: ${_formatter.format(valorCuotaEstandar)}'),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ─────────── BLOQUE PAGO ───────────
            CustomWebCampoConCheckboxTextField(
              label: 'Usar valor estándar',
              controller: _montoController,
              isEditable: true,
              onCheckboxChanged: (v) {
                setState(() {
                  _usarValorEstandar = v;
                  if (v) _calcularMontoEstandar();
                });
              },
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
                  onPressed: () {
                    final monto = _parseMonto(_montoController.text);
                    widget.onConfirmar(monto, DateTime.now());
                    Navigator.of(context).pop();
                  },
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
