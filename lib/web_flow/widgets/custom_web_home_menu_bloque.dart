import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/web_flow/widgets/custom_web_gradient_button.dart';

class CustomWebHomeMenuBloque extends StatelessWidget {
  final String titulo;
  final List<String> textosBotones;
  final List<VoidCallback> accionesBotones;

  const CustomWebHomeMenuBloque({
    super.key,
    required this.titulo,
    required this.textosBotones,
    required this.accionesBotones,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double innerPadding = 40;
        final double buttonWidth = constraints.maxWidth - (innerPadding * 2);
        final double buttonHeight =
            (constraints.maxHeight - (innerPadding * 4)) / 3;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 30,
                  left: innerPadding,
                  right: innerPadding,
                  bottom: innerPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: WebColors.bordeRosa, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(textosBotones.length, (index) {
                  return SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: CustomGradientButton(
                      text: textosBotones[index],
                      onPressed: accionesBotones[index],
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: WebColors.fondoEtiquetaBloque,
                    border: Border.all(color: WebColors.bordeRosa, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: WebColors.textoRosa,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
