import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_text_field.dart';

class CustomWebPopupEditarProducto extends ConsumerStatefulWidget {
  final String idProducto;

  const CustomWebPopupEditarProducto({
    super.key,
    required this.idProducto,
  });

  @override
  ConsumerState<CustomWebPopupEditarProducto> createState() =>
      _CustomWebPopupEditarProductoState();
}

class _CustomWebPopupEditarProductoState
    extends ConsumerState<CustomWebPopupEditarProducto> {
  late TextEditingController _precioController;
  late TextEditingController _cuotasController;
  late TextEditingController _precioCuotasController;

  bool _relacionarVariables = true;
  bool _productoCargado = false;
  Map<String, dynamic>? _producto;

  final _formatter = NumberFormat("#,##0.##", "es_AR");

  /* -------------------------------------------------------------------- */
  /* Function: initState                                                  */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Initialize the controllers and load the product data    */
  /*  from fichaEnCursoProvider according to the received ID.             */
  /* -------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fichaProvider = ref.read(fichaEnCursoProvider);
      final producto = fichaProvider.obtenerProductoPorId(widget.idProducto);

      if (producto == null) {
        debugPrint('No se encontró producto con ID: ${widget.idProducto}');
        return;
      }

      _producto = Map<String, dynamic>.from(producto);

      final double precioInit =
          (_producto?[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0)
              .toDouble();

      final int cuotasInit =
          (_producto?[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ??
                  1)
              .toInt();

      final double precioCuotaInit =
          (_producto?[FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ??
                  (cuotasInit > 0 ? precioInit / cuotasInit : 0))
              .toDouble();

      _precioController =
          TextEditingController(text: _formatter.format(precioInit));
      _cuotasController = TextEditingController(text: cuotasInit.toString());
      _precioCuotasController =
          TextEditingController(text: _formatter.format(precioCuotaInit));

      setState(() {
        _productoCargado = true;
      });
    });
  }

  /* -------------------------------------------------------------------- */
  /* Function: dispose                                                    */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Dispose text controllers to free memory.                */
  /* -------------------------------------------------------------------- */
  @override
  void dispose() {
    if (_productoCargado) {
      _precioController.dispose();
      _cuotasController.dispose();
      _precioCuotasController.dispose();
    }
    super.dispose();
  }

  /* -------------------------------------------------------------------- */
  /* Function: _parseDouble                                               */
  /* -------------------------------------------------------------------- */
  /* Input: String                                                        */
  /* Output: double                                                       */
  /* -------------------------------------------------------------------- */
  /* Description: Convert text to double safely, handling locale formats. */
  /* -------------------------------------------------------------------- */
  double _parseDouble(String s) {
    return double.tryParse(s.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
  }

  /* -------------------------------------------------------------------- */
  /* Function: _parseInt                                                  */
  /* -------------------------------------------------------------------- */
  /* Input: String                                                        */
  /* Output: int                                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Convert text to integer, removing invalid characters.   */
  /* -------------------------------------------------------------------- */
  int _parseInt(String s) =>
      int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')) ?? 1;

  /* -------------------------------------------------------------------- */
  /* Function: _recalcularDesdePrecio                                     */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Update cuota price when base price is modified.         */
  /* -------------------------------------------------------------------- */
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

  /* -------------------------------------------------------------------- */
  /* Function: _recalcularDesdeCuotas                                     */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Update cuota price when cuota count changes.            */
  /* -------------------------------------------------------------------- */
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

  /* -------------------------------------------------------------------- */
  /* Function: _recalcularDesdePrecioCuota                                */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Update total price when cuota price is modified.        */
  /* -------------------------------------------------------------------- */
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

  /* -------------------------------------------------------------------- */
  /* Function: _onAceptar                                                 */
  /* -------------------------------------------------------------------- */
  /* Input: -                                                             */
  /* Output: -                                                            */
  /* -------------------------------------------------------------------- */
  /* Description: Save product changes into ficha provider.               */
  /* -------------------------------------------------------------------- */
  void _onAceptar() {
    if (!_productoCargado || _producto == null) {
      debugPrint('Producto no cargado correctamente.');
      Navigator.of(context).pop();
      return;
    }

    final fichaProvider = ref.read(fichaEnCursoProvider);

    final nuevoPrecio = _parseDouble(_precioController.text);
    final nuevasCuotas = _parseInt(_cuotasController.text);
    double nuevoPrecioCuota = _parseDouble(_precioCuotasController.text);

    if (_relacionarVariables && nuevasCuotas > 0) {
      nuevoPrecioCuota = nuevoPrecio / nuevasCuotas;
    }

    fichaProvider.actualizarProducto(widget.idProducto, {
      FIELD_NAME__producto_ficha_model__Precio_Unitario: nuevoPrecio,
      FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas: nuevasCuotas,
      FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas: nuevoPrecioCuota,
    });

    Navigator.of(context).pop();
  }

  /* -------------------------------------------------------------------- */
  /* Function: build                                                      */
  /* -------------------------------------------------------------------- */
  /* Input: BuildContext                                                  */
  /* Output: Widget                                                       */
  /* -------------------------------------------------------------------- */
  /* Description: Build UI for editing product data in ficha.             */
  /* -------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    if (!_productoCargado) {
      return const Center(child: CircularProgressIndicator());
    }

    final fichaProvider = ref.watch(fichaEnCursoProvider);
    final producto =
        fichaProvider.obtenerProductoPorId(widget.idProducto) ?? {};

    final nombre =
        producto[FIELD_NAME__producto_ficha_model__Nombre]?.toString() ??
            'Producto';
    final stock =
        (producto[FIELD_NAME__producto_ficha_model__Stock] ?? 0).toInt();
    final imageUrl =
        producto[FIELD_NAME__producto_ficha_model__Link_De_La_Foto] ?? '';
    final cantidadSeleccionada =
        (producto[FIELD_NAME__producto_ficha_model__Unidades] ?? 0).toInt();

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
                final total = precioCuota * cantidadSeleccionada;

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
                      Text('Unidades seleccionadas: $cantidadSeleccionada',
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
