import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/shared/layouts/internal_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withOpacity(0.04),
            offset: const Offset(0, -1),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
        color: context.isDarkMode ? AppColors.neutralActive : AppColors.white,
      ),
      height: 60 + screen.padding.bottom,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        backgroundColor: Colors.transparent,
        onTap: (value) {
          _onTap(context, value);
        },
        selectedItemColor:
            context.isDarkMode ? AppColors.white : AppColors.brandColorDefault,
        unselectedItemColor: context.isDarkMode
            ? AppColors.neutralOffWhite
            : AppColors.neutralActive,
        items: [
          for (var menuTab in menuTabs)
            BottomNavigationBarItem(
              label: menuTab.label,
              icon: SvgPicture.asset(
                menuTab.icon,
                colorFilter: ColorFilter.mode(
                  context.isDarkMode
                      ? AppColors.neutralOffWhite
                      : AppColors.neutralActive,
                  BlendMode.srcIn,
                ),
              ),
              activeIcon: SvgPicture.asset(
                menuTab.activeIcon,
                colorFilter: ColorFilter.mode(
                  context.isDarkMode
                      ? AppColors.white
                      : AppColors.brandColorDefault,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
