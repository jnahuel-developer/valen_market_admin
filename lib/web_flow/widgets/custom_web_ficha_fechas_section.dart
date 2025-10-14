/// ---------------------------------------------------------------------------
/// CUSTOM_WEB_FICHA_FECHAS_SECTION
///
/// 🔹 Rol: Contenedor de los campos de fechas de una ficha.
/// 🔹 Widgets incluidos:
///   - [CustomWebCampoFechaConCheckbox] → gestiona la fecha de venta.
///   - [CustomWebCampoFrecuenciaAviso] → gestiona la fecha de aviso.
/// 🔹 Interactúa con:
///   - [FichaEnCursoProvider]: sólo lo pasa a los widgets hijos.
/// 🔹 Lógica:
///   Este widget ya no inicializa ni actualiza las fechas.
///   Delegación total a los widgets hijos para manejar su propio estado.
/// ---------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valen_market_admin/constants/textos.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_bloque_con_titulo.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_fecha_con_checkbox.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_campo_frecuencia_aviso.dart';

class CustomWebFichaFechasSection extends ConsumerWidget {
  const CustomWebFichaFechasSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomWebBloqueConTitulo(
      titulo: TEXTO_ES__fichas_fechas_widget__campo__titulo,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWebCampoFechaConCheckbox(
            label: TEXTO_ES__fichas_fechas_widget__campo__label,
          ),
          SizedBox(height: 20),
          CustomWebCampoFrecuenciaAviso(),
        ],
      ),
    );
  }
}
