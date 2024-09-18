import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:go_router/go_router.dart';

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
    final MediaQueryData screen = MediaQuery.of(context);

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
      ),
      constraints: BoxConstraints(
        minHeight: 60 + screen.padding.bottom,
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        currentIndex: navigationShell.currentIndex,
        onTap: (value) {
          _onTap(context, value);
        },
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: SvgPicture.asset(
              'assets/icons/tabs/chat_outlined.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/tabs/chat_solid.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Contacts',
            icon: SvgPicture.asset(
              'assets/icons/tabs/contacts_outlined.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/tabs/contacts_solid.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: SvgPicture.asset(
              'assets/icons/tabs/settings_outlined.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.neutralActive,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/tabs/settings_solid.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
