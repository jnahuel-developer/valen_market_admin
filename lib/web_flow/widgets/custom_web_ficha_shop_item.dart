import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/fieldNames.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_popup_editar_producto.dart';

/* -------------------------------------------------------------------------- */
/* Widget: CustomWebFichaShopItem                                             */
/* -------------------------------------------------------------------------- */
/* Description (Español):                                                     */
/*  Representa un producto dentro de la sección de ficha. Permite mostrar     */
/*  la información general, modificar la cantidad, y abrir la ventana de      */
/*  edición del producto.                                                     */
/*                                                                            */
/*  Si la cantidad del producto es cero, los datos se toman desde el          */
/*  parámetro recibido (catálogo). Si es mayor que cero, se obtienen desde    */
/*  la ficha en curso.                                                        */
/* -------------------------------------------------------------------------- */
/* Technical Notes (English):                                                 */
/*  - Type: ConsumerStatefulWidget                                            */
/*  - Keeps local state for quantity persistence                              */
/*  - Reads updated product data from fichaEnCursoProvider when necessary     */
/* -------------------------------------------------------------------------- */
class CustomWebFichaShopItem extends ConsumerStatefulWidget {
  final Map<String, dynamic> producto;

  const CustomWebFichaShopItem({
    super.key,
    required this.producto,
  });

  @override
  ConsumerState<CustomWebFichaShopItem> createState() =>
      _CustomWebFichaShopItemState();
}

class _CustomWebFichaShopItemState
    extends ConsumerState<CustomWebFichaShopItem> {
  late int cantidad;

  @override
  void initState() {
    super.initState();
    // Se inicializa la cantidad desde el producto recibido
    cantidad =
        (widget.producto[FIELD_NAME__producto_ficha_model__Unidades] ?? 0)
            .toInt();
  }

  /* ---------------------------------------------------------------------- */
  /* Function: build                                                        */
  /* ---------------------------------------------------------------------- */
  /* Input: BuildContext, WidgetRef                                         */
  /* Output: Widget                                                         */
  /* ---------------------------------------------------------------------- */
  /* Description: Builds the product item card, reading data from the ficha  */
  /*  provider or from the received product, depending on quantity.          */
  /* ---------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    final fichaProvider = ref.read(fichaEnCursoProvider);

    // Se obtiene el ID del producto recibido
    final String idProducto =
        widget.producto[FIELD_NAME__producto_ficha_model__ID] ?? '';

    // Se inicializan los datos que no cambian desde el producto recibido
    final String nombre =
        widget.producto[FIELD_NAME__producto_ficha_model__Nombre] ?? '';
    final String imageUrl =
        widget.producto[FIELD_NAME__producto_ficha_model__Link_De_La_Foto] ??
            '';
    final int stock =
        (widget.producto[FIELD_NAME__producto_ficha_model__Stock] ?? 0).toInt();

    Map<String, dynamic>? productoEnUso;

    // Si la cantidad es mayor a cero, se busca el producto en la ficha actual
    if (cantidad > 0) {
      final existente = fichaProvider.obtenerProductoPorId(idProducto);
      if (existente != null && existente.isNotEmpty) {
        productoEnUso = existente;
      } else {
        productoEnUso = widget.producto;
      }
    }
    // En caso contrario, se usan los datos del producto recibido
    else {
      productoEnUso = widget.producto;
    }

    // Se extraen los datos del producto en uso
    final double precio =
        (productoEnUso[FIELD_NAME__producto_ficha_model__Precio_Unitario] ?? 0)
            .toDouble();
    final double precioCuota = (productoEnUso[
                FIELD_NAME__producto_ficha_model__Precio_De_Las_Cuotas] ??
            0)
        .toDouble();
    final int cuotas =
        (productoEnUso[FIELD_NAME__producto_ficha_model__Cantidad_De_Cuotas] ??
                0)
            .toInt();

    // Se formatean los precios
    final String precioFormateado =
        NumberFormat('#,###', 'es_AR').format(precio);
    final String precioCuotaFormateado =
        NumberFormat('#,###', 'es_AR').format(precioCuota);

    /* -------------------------------------------------------------------- */
    /* Function: incrementar                                                */
    /* -------------------------------------------------------------------- */
    /* Description: Increments the quantity or adds product to ficha.       */
    /* -------------------------------------------------------------------- */
    void incrementar() {
      setState(() {
        cantidad += 1;
      });

      if (cantidad == 1) {
        fichaProvider.agregarProducto({
          ...productoEnUso!,
          FIELD_NAME__producto_ficha_model__Unidades: cantidad,
        });
      } else {
        fichaProvider.actualizarProducto(idProducto, {
          FIELD_NAME__producto_ficha_model__Unidades: cantidad,
        });
      }
    }

    /* -------------------------------------------------------------------- */
    /* Function: decrementar                                                */
    /* -------------------------------------------------------------------- */
    /* Description: Decrements the quantity or removes product when zero.   */
    /* -------------------------------------------------------------------- */
    void decrementar() {
      if (cantidad <= 0) return;

      setState(() {
        cantidad -= 1;
      });

      if (cantidad <= 0) {
        fichaProvider.eliminarProducto(idProducto);
      } else {
        fichaProvider.actualizarProducto(idProducto, {
          FIELD_NAME__producto_ficha_model__Unidades: cantidad,
        });
      }
    }

    /* -------------------------------------------------------------------- */
    /* Function: editarProducto                                             */
    /* -------------------------------------------------------------------- */
    /* Description: Opens edit popup and updates ficha data.                */
    /* -------------------------------------------------------------------- */
    Future<void> editarProducto() async {
      await showDialog(
        context: context,
        builder: (context) =>
            CustomWebPopupEditarProducto(idProducto: idProducto),
      );
      // Se actualiza el estado local tras la edición
      setState(() {});
    }

    // Estructura visual
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: WebColors.blanco,
            border: Border.all(color: WebColors.bordeRosa, width: 2),
            borderRadius: BorderRadius.circular(
              VALUE__general_widget__campo__big_border_radius,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen
              Container(
                width: 140,
                height: 120,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: WebColors.blanco,
                  border: Border.all(color: WebColors.bordeRosa),
                  borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 10),

              // Nombre
              Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              // Precio y cuotas
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Precio: \$ $precioFormateado',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (cuotas > 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$cuotas cuotas de \$ $precioCuotaFormateado',
                    style: const TextStyle(
                      fontSize: 13,
                      color: WebColors.negro,
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Stock: $stock',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Controles de cantidad
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onPressed: cantidad > 0 ? decrementar : null,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 70,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: WebColors.bordeRosa),
                      borderRadius: BorderRadius.circular(30),
                      color: WebColors.blanco,
                    ),
                    child: Text(
                      cantidad.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildCircleButton(
                    icon: Icons.add,
                    onPressed: incrementar,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Botón de edición
        if (cantidad > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                key: Key(
                    'KEY__custom_web_ficha_shop_item__boton__editar__${widget.producto['ID'] ?? ''}'),
                icon: const Icon(Icons.edit,
                    size: 20, color: WebColors.textoRosa),
                onPressed: editarProducto,
                tooltip: 'Editar producto en ficha',
              ),
            ),
          ),
      ],
    );
  }

  /* ---------------------------------------------------------------------- */
  /* Function: _buildCircleButton                                           */
  /* ---------------------------------------------------------------------- */
  /* Input: IconData, VoidCallback?                                         */
  /* Output: Widget                                                         */
  /* ---------------------------------------------------------------------- */
  /* Description: Crea un botón circular con ícono para los controles de    */
  /*  cantidad.                                                             */
  /* ---------------------------------------------------------------------- */
  Widget _buildCircleButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: WebColors.plataTranslucida,
        border: Border.all(color: WebColors.bordeRosa),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: WebColors.textoRosa),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }
}
