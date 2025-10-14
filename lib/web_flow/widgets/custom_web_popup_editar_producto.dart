/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_POPUP_EDITAR_PRODUCTO
///
/// 🔹 Rol: Popup para editar los valores financieros de un producto.
/// 🔹 Interactúa con:
///   - Widget que lo abre (CustomWebProductosSection):
///       • Devuelve un Map<String,dynamic> con las nuevas variables.
/// 🔹 Lógica:
///   - El checkbox "Relacionar variables" mantiene relación entre precio,
///     cuotas y precio por cuota. Al aceptar se devuelve un Map con:
///       { 'nuevoPrecioUnitario': double,
///         'nuevaCantidadDeCuotas': int,
///         'nuevoPrecioDeCuotas': double }
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';

class CustomWebPopupEditarProducto extends StatefulWidget {
  final Map<String, dynamic> productoCatalogo;
  final int cantidadSeleccionada;
  final void Function(Map<String, dynamic> resultado) onAceptar;

  const CustomWebPopupEditarProducto({
    super.key,
    required this.productoCatalogo,
    required this.cantidadSeleccionada,
    required this.onAceptar,
  });

  @override
  State<CustomWebPopupEditarProducto> createState() =>
      _CustomWebPopupEditarProductoState();
}

class _CustomWebPopupEditarProductoState
    extends State<CustomWebPopupEditarProducto> {
  late TextEditingController _precioController;
  late TextEditingController _cuotasController;
  late TextEditingController _precioCuotasController;

  bool _relacionarVariables = true; // Checkbox activado por defecto
  final _formatter = NumberFormat("#,##0.##", "es_AR");

  @override
  void initState() {
    super.initState();

    final double precioInit = (widget.productoCatalogo[
                FIELD_NAME__producto_ficha_model__Precio_Unitario] ??
            widget.productoCatalogo[FIELD_NAME__catalogo__Precio] ??
            0)
        .toDouble();
    final int cuotasInit = (widget.productoCatalogo[
            FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ??
        widget.productoCatalogo[FIELD_NAME__catalogo__Cantidad_De_Cuotas] ??
        1) as int;
    final double precioCuotaInit = (widget.productoCatalogo[
                FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ??
            ((precioInit > 0 && cuotasInit > 0)
                ? (precioInit / cuotasInit)
                : 0.0))
        .toDouble();

    _precioController =
        TextEditingController(text: _formatter.format(precioInit));
    _cuotasController = TextEditingController(text: cuotasInit.toString());
    _precioCuotasController =
        TextEditingController(text: _formatter.format(precioCuotaInit));
  }

  @override
  void dispose() {
    _precioController.dispose();
    _cuotasController.dispose();
    _precioCuotasController.dispose();
    super.dispose();
  }

  double _parseDouble(String s) {
    return double.tryParse(s.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
  }

  int _parseInt(String s) =>
      int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')) ?? 1;

  void _recalcularDesdePrecio() {
    if (!_relacionarVariables) {
      setState(() {});
      return;
    }
    final precio = _parseDouble(_precioController.text);
    final cuotas = _parseInt(_cuotasController.text);
    if (cuotas <= 0) return;
    final nuevoPrecioCuota = precio / cuotas;
    _precioCuotasController.text = _formatter.format(nuevoPrecioCuota);
    setState(() {});
  }

  void _recalcularDesdeCuotas() {
    if (!_relacionarVariables) {
      setState(() {});
      return;
    }
    final precio = _parseDouble(_precioController.text);
    final cuotas = _parseInt(_cuotasController.text);
    if (cuotas <= 0) return;
    final nuevoPrecioCuota = precio / cuotas;
    _precioCuotasController.text = _formatter.format(nuevoPrecioCuota);
    setState(() {});
  }

  void _recalcularDesdePrecioCuota() {
    if (!_relacionarVariables) {
      setState(() {});
      return;
    }
    final precioCuota = _parseDouble(_precioCuotasController.text);
    final cuotas = _parseInt(_cuotasController.text);
    final nuevoPrecioTotal = precioCuota * cuotas;
    _precioController.text = _formatter.format(nuevoPrecioTotal);
    setState(() {});
  }

  void _onAceptar() {
    final nuevoPrecio = _parseDouble(_precioController.text);
    final nuevasCuotas = _parseInt(_cuotasController.text);
    double nuevoPrecioCuota = _parseDouble(_precioCuotasController.text);

    if (_relacionarVariables && nuevasCuotas > 0) {
      nuevoPrecioCuota = nuevoPrecio / nuevasCuotas;
    }

    final resultado = <String, dynamic>{
      'nuevoPrecioUnitario': nuevoPrecio,
      'nuevaCantidadDeCuotas': nuevasCuotas,
      'nuevoPrecioDeCuotas': nuevoPrecioCuota,
    };

    widget.onAceptar(resultado);
    Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    final nombre =
        widget.productoCatalogo[FIELD_NAME__catalogo__Nombre_Del_Producto] ??
            'Producto';
    final stock =
        (widget.productoCatalogo[FIELD_NAME__catalogo__Stock] ?? 0).toInt();
    final imageUrl =
        widget.productoCatalogo[FIELD_NAME__catalogo__Link_De_La_Foto] ?? '';
    final formatCurrency = NumberFormat.currency(locale: 'es_AR', symbol: '\$');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            VALUE__general_widget__campo__big_border_radius),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Imagen centrada
              Container(
                width: 280,
                height: 200,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: WebColors.blanco,
                  border: Border.all(color: WebColors.bordeRosa),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 50),
                      )
                    : const Icon(Icons.image_not_supported, size: 50),
              ),
              const SizedBox(height: 20),

              Text(
                'Stock disponible: $stock',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Bloque de campos numéricos
              CustomTextField(
                label: 'Precio unitario',
                controller: _precioController,
                keyboardType: TextInputType.number,
                isMoney: true,
                isRequired: true,
                onFieldSubmitted: (_) => _recalcularDesdePrecio(),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Cantidad de cuotas',
                      controller: _cuotasController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      onFieldSubmitted: (_) => _recalcularDesdeCuotas(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Precio de las cuotas',
                      controller: _precioCuotasController,
                      keyboardType: TextInputType.number,
                      isMoney: true,
                      onFieldSubmitted: (_) => _recalcularDesdePrecioCuota(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _relacionarVariables,
                    onChanged: (v) {
                      setState(() => _relacionarVariables = v ?? true);
                    },
                  ),
                  Text(
                    'Relacionar variables',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: _relacionarVariables
                          ? FontStyle.normal
                          : FontStyle.italic,
                      color: _relacionarVariables
                          ? WebColors.negro
                          : WebColors.grisClaro,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Vista previa
              Builder(builder: (context) {
                final precio = _parseDouble(_precioController.text);
                final cuotas = _parseInt(_cuotasController.text);
                final precioCuota = _parseDouble(_precioCuotasController.text);
                final total = precioCuota * widget.cantidadSeleccionada;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: WebColors.plataTranslucida,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Unidades seleccionadas: ${widget.cantidadSeleccionada}',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 6),
                      Text('Precio unitario: ${formatCurrency.format(precio)}',
                          style: const TextStyle(fontSize: 14)),
                      Text(
                        'Precio por cuota: ${formatCurrency.format(precioCuota)} — $cuotas cuotas',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total estimado: ${formatCurrency.format(total)}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 28),

              // Botones centrados
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _onAceptar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebColors.textoRosa,
                      foregroundColor: WebColors.blanco,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
