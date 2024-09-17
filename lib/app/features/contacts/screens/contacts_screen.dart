import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/widgets/chat_item.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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
                  horizontal: 16,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Contacts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue2,
                        height: 1.2,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Obx(
            () => SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  final chat = chatController.chats[index];
                  return ChatItem(chat: chat);
                },
                itemCount: chatController.chats.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              onPressed: () {
                authController.logout();
              },
              child: Text('logout'),
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () {},
          child: SvgPicture.asset(
            'assets/icons/plus.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
