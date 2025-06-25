import 'package:flutter/material.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double top;

  const CustomInfoCard({
    super.key,
    required this.title,
    required this.children,
    this.top = 95,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // CARD
            Container(
              width: 400,
              height: 550,
              decoration: BoxDecoration(
                color: AppColors.blancoTraslucido,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ...children.expand((w) => [w, const SizedBox(height: 10)]),
                ],
              ),
            ),

            // TÍTULO flotante
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
