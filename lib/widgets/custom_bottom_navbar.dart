import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valen_market_admin/constants/assets.dart';
import 'package:valen_market_admin/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: AppColors.amarillo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.azul, width: 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconButton(AppAssets.iconBack, () {
            Navigator.pop(context);
          }),
          _iconButton(AppAssets.iconUser,
              () => _navigateIfNotCurrent(context, '/clientes')),
          _iconButton(AppAssets.iconHome,
              () => _navigateIfNotCurrent(context, '/home')),
          _iconButton(AppAssets.iconTicket,
              () => _navigateIfNotCurrent(context, '/fichas')),
          _iconButton(AppAssets.iconCart,
              () => _navigateIfNotCurrent(context, '/catalogo')),
        ],
      ),
    );
  }

  Widget _iconButton(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        path,
        width: 30,
        height: 30,
        colorFilter: const ColorFilter.mode(AppColors.azul, BlendMode.srcIn),
      ),
    );
  }
}

void _navigateIfNotCurrent(BuildContext context, String route) {
  if (ModalRoute.of(context)?.settings.name != route) {
    Navigator.pushReplacementNamed(context, route);
  }
}
