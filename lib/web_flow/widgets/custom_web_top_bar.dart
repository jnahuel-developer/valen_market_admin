import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/values.dart';
import 'package:valen_market_admin/services/dropbox/dropbox_servicios_web.dart';
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
      try {
        await AuthServiciosFirebaseWeb.logout();
        await DropboxServiciosWeb.limpiarTokens();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            PANTALLA_WEB__Login,
            (_) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cerrar sesión')),
          );
        }
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

    final isMobile = MediaQuery.of(context).size.width < 600;
    final titleFontSize = isMobile ? 16.0 : 20.0;
    final buttonFontSize = isMobile ? 12.0 : 14.0;

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
              style: TextStyle(
                fontSize: titleFontSize,
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
              icon: Icon(Icons.logout, size: isMobile ? 16 : 20),
              label: Text(
                isMobile ? 'Cerrar' : 'Cerrar sesión',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: WebColors.blancoTraslucido,
                foregroundColor: WebColors.textoRosa,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      VALUE__general_widget__campo__big_border_radius),
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
