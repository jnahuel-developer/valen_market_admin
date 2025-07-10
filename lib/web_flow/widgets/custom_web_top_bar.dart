import 'package:flutter/material.dart';
import 'package:valen_market_admin/services/firebase/auth_servicios_firebase_web.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/pantallas.dart';

class CustomWebTopBar extends StatelessWidget {
  final String titulo;
  final String? pantallaPadreRouteName;

  const CustomWebTopBar({
    super.key,
    required this.titulo,
    this.pantallaPadreRouteName,
  });

  Future<void> _confirmarLogout(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que querés cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await AuthServiciosFirebaseWeb.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          PANTALLA_WEB__Login,
          (_) => false,
        );
      }
    }
  }

  void _irAPantallaPadre(BuildContext context) {
    final rutaActual = ModalRoute.of(context)?.settings.name;
    if (pantallaPadreRouteName != null &&
        pantallaPadreRouteName != rutaActual) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        pantallaPadreRouteName!,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool mostrarFlecha = pantallaPadreRouteName != null &&
        pantallaPadreRouteName != ModalRoute.of(context)?.settings.name;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: WebColors.plataTranslucida,
        border: const Border(
          bottom: BorderSide(
            color: WebColors.bordeRosa,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Flecha de volver (si corresponde)
          if (mostrarFlecha)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => _irAPantallaPadre(context),
                icon:
                    const Icon(Icons.arrow_upward, color: WebColors.textoRosa),
                tooltip: 'Volver',
              ),
            ),

          // Título centrado
          Center(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                color: WebColors.textoRosa,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Botón de cerrar sesión
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _confirmarLogout(context),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: WebColors.blancoTraslucido,
                foregroundColor: WebColors.textoRosa,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: WebColors.bordeRosa,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
