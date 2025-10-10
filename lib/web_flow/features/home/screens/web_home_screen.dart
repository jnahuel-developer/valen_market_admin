import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_top_bar.dart';
import 'package:valen_market_admin/constants/pantallas.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_home_menu_bloque.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double padding = 25;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth - (padding * 4);
          final double availableHeight = constraints.maxHeight -
              (padding * 3) -
              60; // 60 = top bar height aprox.

          final double bloqueWidth = availableWidth / 3;
          final double bloqueHeight = availableHeight / 2;

          return Column(
            children: [
              const CustomWebTopBar(
                titulo: TEXTO_ES__home_screen__titulo,
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
                              TEXTO_ES__home_screen__bloque__clientes, [
                            TEXTO_ES__home_screen__boton__ver_clientes,
                            TEXTO_ES__home_screen__boton__agregar_cliente,
                            TEXTO_ES__home_screen__boton__volcar_panilla_de_clientes,
                          ], [
                            // Ver clientes -> Todavia no fue desarrollado
                            () {},
                            // Agregar un cliente
                            () => Navigator.pushNamed(context,
                                PANTALLA_WEB__Clientes__AgregarCliente),
                            // Volcar la planilla -> Todavia no fue desarrollado
                            () {},
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO_ES__home_screen__bloque__catalogo, [
                            TEXTO_ES__home_screen__boton__ver_catalogo,
                            TEXTO_ES__home_screen__boton__agregar_producto,
                            TEXTO_ES__home_screen__boton__volcar_panilla_de_productos,
                          ], [
                            // Ver el catálogo completo
                            () => Navigator.pushNamed(
                                context, PANTALLA_WEB__Catalogo__VerCatalogo),
                            // Agregar un producto
                            () => Navigator.pushNamed(context,
                                PANTALLA_WEB__Catalogo__AgregarProducto),
                            // Volcar la planilla -> Todavia no fue desarrollado
                            () {},
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO_ES__home_screen__bloque__fichas, [
                            TEXTO_ES__home_screen__boton__agregar_ficha,
                            TEXTO_ES__home_screen__boton__buscar_ficha,
                            TEXTO_ES__home_screen__boton__editar_ficha,
                          ], [
                            // Agregar ficha
                            () => Navigator.pushNamed(
                                context, PANTALLA_WEB__Fichas__Agregar),
                            // Buscar ficha
                            () => Navigator.pushNamed(
                                context, PANTALLA_WEB__Fichas__Buscar),
                            // Editar ficha (primero hay que buscarla)
                            () => Navigator.pushNamed(
                                context, PANTALLA_WEB__Fichas__Buscar),
                          ]),
                        ],
                      ),
                      // Segunda fila
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO_ES__home_screen__bloque__pagos, [
                            TEXTO_ES__home_screen__boton__agregar_pagos,
                            TEXTO_ES__home_screen__boton__buscar_pagos,
                            TEXTO_ES__home_screen__boton__editar_pagos,
                          ], [
                            () {}, // planilla
                            () {}, // registrar pago
                            () {}, // historial
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO_ES__home_screen__bloque__promociones, [
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                          ], [
                            () {}, // ventas
                            () {}, // cobros
                            () {}, // clientes
                          ]),
                          _buildBloque(context, bloqueWidth, bloqueHeight,
                              TEXTO_ES__home_screen__bloque__estadisticas, [
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                            'NO DISPONIBLE',
                          ], [
                            () {}, // usuarios
                            () {}, // zonas
                            () {}, // otros
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

  Widget _buildBloque(BuildContext context, double width, double height,
      String titulo, List<String> textos, List<VoidCallback> acciones) {
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
