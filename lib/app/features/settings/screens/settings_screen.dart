import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/settings/widgets/menu_item.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            scrolledUnderElevation: 0,
            flexibleSpace: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralActive,
                        height: 30 / 18,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 16,
                    left: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neutralLine,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.neutralActive,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Almayra Zamzamy',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralActive,
                              height: 24 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '+62 1309 - 1710 - 1920',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutralDisabled,
                              height: 20 / 12,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/profile.svg',
                  label: 'Account',
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/tabs/chat_outlined.svg',
                  label: 'Chats',
                ),
                const SizedBox(
                  height: 24,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/sun.svg',
                  label: 'Appereance',
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/notification.svg',
                  label: 'Notification',
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/privacy.svg',
                  label: 'Privacy',
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: AppColors.neutralLine,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/help.svg',
                  label: 'Help',
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/email.svg',
                  label: 'Invite Your Friends',
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: AppColors.neutralLine,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                MenuItem(
                  onPressed: () {
                    authController.logout();
                  },
                  icon: 'assets/icons/logout.svg',
                  label: 'Logout',
                  withArrow: false,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
