import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomTopBar extends StatelessWidget {
  final String title;

  const CustomTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.sombra,
              offset: Offset(0, 10),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: 0.25,
              child: Image.asset(
                AppAssets.bgMenuSuperior,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Stack(
                  children: [
                    Text(
                      title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.amarillo,
                        shadows: [
                          Shadow(color: AppColors.azul, offset: Offset(-2, -2)),
                          Shadow(color: AppColors.azul, offset: Offset(2, -2)),
                          Shadow(color: AppColors.azul, offset: Offset(2, 2)),
                          Shadow(color: AppColors.azul, offset: Offset(-2, 2)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
