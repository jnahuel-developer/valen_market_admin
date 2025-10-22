import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_home_menu_bloque.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/web_flow/features/fichas/provider/ficha_en_curso_provider.dart';

class WebHomeScreen extends ConsumerWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double padding = 25;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth - (padding * 4);
          final double availableHeight =
              constraints.maxHeight - (padding * 3) - 60;

          final double bloqueWidth = availableWidth / 3;
          final double bloqueHeight = availableHeight / 2;

          return Column(
            children: [
              const CustomWebTopBar(
                titulo: TEXTO__home_screen__titulo,
                pantallaPadreRouteName: null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Primera fila
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__clientes, [
                            TEXTO__home_screen__boton__ver_clientes,
                            TEXTO__home_screen__boton__agregar_cliente,
                            TEXTO__home_screen__boton__volcar_panilla_de_clientes,
                          ], [
                            () {},
                            () => Navigator.pushNamed(context,
                                PANTALLA_WEB__Clientes__AgregarCliente),
                            () {},
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__catalogo, [
                            TEXTO__home_screen__boton__ver_catalogo,
                            TEXTO__home_screen__boton__agregar_producto,
                            TEXTO__home_screen__boton__volcar_panilla_de_productos,
                          ], [
                            () => Navigator.pushNamed(
                                context, PANTALLA_WEB__Catalogo__VerCatalogo),
                            () => Navigator.pushNamed(context,
                                PANTALLA_WEB__Catalogo__AgregarProducto),
                            () {},
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__fichas, [
                            TEXTO__home_screen__boton__agregar_ficha,
                            TEXTO__home_screen__boton__buscar_ficha,
                            TEXTO__home_screen__boton__editar_ficha,
                          ], [
                            // 🔹 Agregar ficha
                            () {
                              ref
                                  .read(fichaEnCursoProvider.notifier)
                                  .inicializarFichaLimpia();
                              Navigator.pushNamed(
                                  context, PANTALLA_WEB__Fichas__Agregar);
                            },
                            // 🔹 Buscar ficha
                            () {
                              ref
                                  .read(fichaEnCursoProvider.notifier)
                                  .inicializarFichaLimpia();
                              Navigator.pushNamed(
                                  context, PANTALLA_WEB__Fichas__Buscar);
                            },
                            // 🔹 Editar ficha (usa la misma pantalla de búsqueda)
                            () {
                              ref
                                  .read(fichaEnCursoProvider.notifier)
                                  .inicializarFichaLimpia();
                              Navigator.pushNamed(
                                  context, PANTALLA_WEB__Fichas__Buscar);
                            },
                          ]),
                        ],
                      ),
                      // Segunda fila (sin cambios)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__pagos, [
                            TEXTO__home_screen__boton__agregar_pagos,
                            TEXTO__home_screen__boton__buscar_pagos,
                            TEXTO__home_screen__boton__editar_pagos,
                          ], [
                            () {},
                            () {},
                            () {},
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__promociones, [
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                          ], [
                            () {},
                            () {},
                            () {}
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO__home_screen__bloque__estadisticas, [
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                          ], [
                            () {},
                            () {},
                            () {}
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBloque(
    BuildContext context,
    double width,
    double height,
    String titulo,
    List<String> textos,
    List<VoidCallback> acciones,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomWebHomeMenuBloque(
        titulo: titulo,
        textosBotones: textos,
        accionesBotones: acciones,
      ),
    );
  }
}
