import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';
import 'package:valen_market_admin/constants/values.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double width;
  final double height;

  const CustomInfoCard({
    super.key,
    required this.title,
    required this.children,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Contenedor principal
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.blancoTraslucido,
            borderRadius: BorderRadius.circular(
                VALUE__general_widget__campo__big_border_radius),
            border: Border.all(color: Colors.black, width: 2),
          ),
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: children
                .expand((widget) => [widget, const SizedBox(height: 10)])
                .toList()
              ..removeLast(),
          ),
        ),

        // Título flotante encima del borde superior
        Positioned(
          top: -15,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(
                    VALUE__general_widget__campo__big_border_radius),
              ),
              child: Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
