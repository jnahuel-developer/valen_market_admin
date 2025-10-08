// lib/web_flow/widgets/custom_web_popup_editar_producto.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/web_flow/features/fichas/model/ficha_en_curso_model.dart';

class CustomWebPopupEditarProducto extends StatefulWidget {
  final Map<String, dynamic> productoCatalogo;
  final ProductoEnFicha? productoEnFicha;
  final int cantidadSeleccionada;
  final void Function(
          double nuevoPrecio, int nuevasCuotas, double nuevoPrecioDeCuotas)
      onAceptar;

  const CustomWebPopupEditarProducto({
    super.key,
    required this.productoCatalogo,
    required this.cantidadSeleccionada,
    required this.onAceptar,
    this.productoEnFicha,
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

  @override
  void initState() {
    super.initState();

    final double precioInit = (widget.productoEnFicha?.precioUnitario ??
            widget.productoCatalogo['Precio'] ??
            0)
        .toDouble();
    final int cuotasInit = widget.productoEnFicha?.cantidadDeCuotas ??
        widget.productoCatalogo['CantidadDeCuotas'] ??
        1;
    final double precioCuotaInit = widget.productoEnFicha?.precioDeLasCuotas ??
        ((precioInit > 0 && cuotasInit > 0) ? (precioInit / cuotasInit) : 0.0);

    _precioController =
        TextEditingController(text: precioInit.toStringAsFixed(2));
    _cuotasController = TextEditingController(text: cuotasInit.toString());
    _precioCuotasController =
        TextEditingController(text: precioCuotaInit.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _precioController.dispose();
    _cuotasController.dispose();
    _precioCuotasController.dispose();
    super.dispose();
  }

  double _parseDouble(String s) {
    return double.tryParse(s.replaceAll(',', '.')) ?? 0.0;
  }

  int _parseInt(String s) {
    return int.tryParse(s) ?? 1;
  }

  void _onAceptar() {
    final nuevoPrecio = _parseDouble(_precioController.text);
    final nuevasCuotas = _parseInt(_cuotasController.text);
    final nuevoPrecioCuota = _parseDouble(_precioCuotasController.text);

    widget.onAceptar(nuevoPrecio, nuevasCuotas, nuevoPrecioCuota);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.productoCatalogo['NombreDelProducto'] ??
        widget.productoCatalogo['Nombre'] ??
        'Producto';
    final stock = (widget.productoCatalogo['Stock'] ?? 0).toInt();
    final imageUrl = widget.productoCatalogo['LinkDeLaFoto'] ?? '';

    final formatCurrency = NumberFormat.currency(locale: 'es_AR', symbol: '\$');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                      child: Text(
                    nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Body: Imagen + Campos
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 180,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 60),
                          )
                        : Container(
                            width: 180,
                            height: 140,
                            color: WebColors.controlDeshabilitado,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stock: $stock'),
                        const SizedBox(height: 12),
                        TextField(
                          key: const Key(
                              'KEY__web_popup_editar_producto__textfield__precio'),
                          controller: _precioController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                              labelText: 'Precio unitario',
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key(
                                    'KEY__web_popup_editar_producto__textfield__cuotas'),
                                controller: _cuotasController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Cantidad de cuotas',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                key: const Key(
                                    'KEY__web_popup_editar_producto__textfield__precio_cuotas'),
                                controller: _precioCuotasController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                    labelText: 'Precio de las cuotas',
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Vista previa rápida
                        Builder(builder: (context) {
                          final precio = _parseDouble(_precioController.text);
                          final cuotas = _parseInt(_cuotasController.text);
                          final precioCuota =
                              _parseDouble(_precioCuotasController.text);
                          final total =
                              precioCuota * widget.cantidadSeleccionada;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Unidades en ficha: ${widget.cantidadSeleccionada}'),
                                const SizedBox(height: 6),
                                Text(
                                    'Precio unitario: ${formatCurrency.format(precio)}'),
                                Text(
                                    'Precio por cuota: ${formatCurrency.format(precioCuota)} — $cuotas cuotas'),
                                const SizedBox(height: 6),
                                Text(
                                    'Total en ficha: ${widget.cantidadSeleccionada} × ${formatCurrency.format(precioCuota)} = ${formatCurrency.format(total)}'),
                              ]);
                        }),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    key: const Key(
                        'KEY__web_popup_editar_producto__boton__cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    key: const Key(
                        'KEY__web_popup_editar_producto__boton__aceptar'),
                    onPressed: _onAceptar,
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
