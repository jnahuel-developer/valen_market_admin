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
      titulo: TEXTO__fichas_fechas_widget__campo__titulo,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomWebCampoFechaConCheckbox(
            label: TEXTO__fichas_fechas_widget__campo__label,
          ),
          SizedBox(height: 20),
          CustomWebCampoFrecuenciaAviso(),
        ],
      ),
    );
  }
}
