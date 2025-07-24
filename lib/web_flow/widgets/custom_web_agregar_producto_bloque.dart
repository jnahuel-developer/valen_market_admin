import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomWebAgregarProductoBloque extends StatelessWidget {
  final String titulo;
  final Widget child;

  const CustomWebAgregarProductoBloque({
    super.key,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 15,
                  right: 15,
                  bottom: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: WebColors.bordeRosa,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        fontSize: 18,
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
      ),
    );
  }
}
