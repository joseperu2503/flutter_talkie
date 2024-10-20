import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_talkie/app/core/constants/breakpoints.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class InternalLayout extends StatelessWidget {
  const InternalLayout({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Breakpoints.isMdUp(context) ? 80 : 0,
            ),
            child: navigationShell,
          ),
          if (Breakpoints.isMdUp(context))
            Container(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(16),
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.04),
                    offset: const Offset(1, 0),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() {
                    final user = authController.user.value;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: user?.photo != null
                          ? Image.network(
                              user!.photo!,
                              width: 48,
                              height: 48,
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              color: AppColors.primary,
                              child: Center(
                                child: Text(
                                  user == null
                                      ? ''
                                      : '${user.name[0]}${user.surname[0]}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    height: 24 / 14,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                              ),
                            ),
                    );
                  }),
                  const SizedBox(
                    height: 52,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final menuTab = menuTabs[index];

                      return SizedBox(
                        width: 48,
                        height: 48,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            navigationShell.goBranch(
                              index,
                              initialLocation:
                                  index == navigationShell.currentIndex,
                            );
                          },
                          child: SvgPicture.asset(
                            navigationShell.currentIndex == index
                                ? menuTab.activeIcon
                                : menuTab.icon,
                            colorFilter: ColorFilter.mode(
                              navigationShell.currentIndex == index
                                  ? AppColors.primary
                                  : AppColors.neutralActive,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 24,
                      );
                    },
                    itemCount: menuTabs.length,
                  )
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Breakpoints.isMdDown(context)
          ? CustomBottomNavigationBar(
              navigationShell: navigationShell,
            )
          : null,
    );
  }
}

final List<MenuTab> menuTabs = [
  MenuTab(
    label: 'Chats',
    icon: 'assets/icons/tabs/chat_outlined.svg',
    activeIcon: 'assets/icons/tabs/chat_solid.svg',
  ),
  MenuTab(
    label: 'Contacts',
    icon: 'assets/icons/tabs/contacts_outlined.svg',
    activeIcon: 'assets/icons/tabs/contacts_solid.svg',
  ),
  MenuTab(
    label: 'Settings',
    icon: 'assets/icons/tabs/settings_outlined.svg',
    activeIcon: 'assets/icons/tabs/settings_solid.svg',
  ),
];

class MenuTab {
  final String icon;
  final String activeIcon;
  final String label;

  MenuTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
