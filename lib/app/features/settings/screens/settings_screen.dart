import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final chatController = Get.find<ChatController>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    chatController.getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
        ],
      ),
    );
  }
}
