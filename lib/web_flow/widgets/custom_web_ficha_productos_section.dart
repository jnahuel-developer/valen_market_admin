import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_ficha_shop_item.dart';

class CustomWebProductosSection extends ConsumerStatefulWidget {
  const CustomWebProductosSection({super.key});

  @override
  ConsumerState<CustomWebProductosSection> createState() =>
      CustomWebProductosSectionState();
}

class CustomWebProductosSectionState
    extends ConsumerState<CustomWebProductosSection> {
  bool _cargando = true;
  List<Map<String, dynamic>> _productosVisibles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarLista();
    });
  }

  /* -------------------------------------------------------------------- */
  /* Function: _inicializarLista                                          */
  /* -------------------------------------------------------------------- */
  /* Description: Initializes the list of visible products depending on   */
  /*  whether a valid record (ficha) exists or not.                       */
  /*                                                                      */
  /* Input: none                                                          */
  /* Output: Future<void>                                                 */
  /* -------------------------------------------------------------------- */
  Future<void> _inicializarLista() async {
    final fichaProvider = ref.read(fichaEnCursoProvider);

    try {
      if (fichaProvider.hayFichaValida) {
        _productosVisibles = fichaProvider.obtenerProductos();
      } else {
        if (fichaProvider.catalogoCache.isEmpty) {
          await fichaProvider.actualizarCacheProductos();
        }
        _productosVisibles = fichaProvider.catalogoCache;
      }
    } catch (e, st) {
      debugPrint('Error al inicializar lista de productos: $e');
      debugPrintStack(stackTrace: st);
      _productosVisibles = [];
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return CustomWebBloqueConTitulo(
        titulo: TEXTO__custom_web_ficha_productos_section__titulo,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_productosVisibles.isEmpty) {
      return CustomWebBloqueConTitulo(
        titulo: TEXTO__custom_web_ficha_productos_section__titulo,
        child: const Center(
          child: Text(
            TEXTO__custom_web_ficha_productos_section__campo__sin_productos,
            style: TextStyle(color: WebColors.textoRosa, fontSize: 16),
          ),
        ),
      );
    }

    // Construcción principal del bloque de productos
    return CustomWebBloqueConTitulo(
      titulo: TEXTO__custom_web_ficha_productos_section__titulo,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _productosVisibles.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final producto = _productosVisibles[index];

            return CustomWebFichaShopItem(producto: producto);
          },
        ),
      ),
    );
  }
}
