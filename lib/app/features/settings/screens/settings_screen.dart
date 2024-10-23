import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/settings/widgets/menu_item.dart';
import 'package:flutter_talkie/app/features/settings/widgets/theme_dialog.dart';
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
                child: Row(
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.isDarkMode
                            ? AppColors.neutralOffWhite
                            : AppColors.neutralActive,
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.neutralDark
                              : AppColors.neutralLine,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralActive,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Obx(() {
                        final user = authController.user.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user == null
                                  ? ''
                                  : '${user.name} ${user.surname}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.isDarkMode
                                    ? AppColors.neutralOffWhite
                                    : AppColors.neutralActive,
                                height: 24 / 14,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              user == null ? '' : user.phone,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutralDisabled,
                                height: 20 / 12,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ],
                        );
                      }),
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
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/tabs/chat_outlined.svg',
                  label: 'Chats',
                ),
                const SizedBox(
                  height: 16,
                ),
                MenuItem(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ThemeDialog();
                      },
                    );
                  },
                  icon: 'assets/icons/sun.svg',
                  label: 'Appereance',
                ),
                MenuItem(
                  onPressed: () {},
                  icon: 'assets/icons/notification.svg',
                  label: 'Notification',
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
                  color: context.isDarkMode
                      ? AppColors.neutralDark
                      : AppColors.neutralLine,
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
                  color: context.isDarkMode
                      ? AppColors.neutralDark
                      : AppColors.neutralLine,
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
