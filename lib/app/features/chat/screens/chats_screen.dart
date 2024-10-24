import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/features/chat/screens/chat_screen.dart';
import 'package:talkie/app/core/constants/app_colors.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/widgets/chat_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    chatController.getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isMdUp(context)) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(
              width: 300,
              child: ChatsView(),
            ),
            Obx(
              () => chatController.chatId.value == null
                  ? Container()
                  : Expanded(
                      child: ChatScreen(
                        chatId: chatController.chatId.value!,
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    return const ChatsView();
  }
}

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    chatController.getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    Text(
                      'Chats',
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
          Obx(
            () => SliverPadding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  final chat = chatController.chats
                      .where((c) => c.lastMessage != null)
                      .toList()[index];
                  return ChatItem(chat: chat);
                },
                itemCount: chatController.chats
                    .where((c) => c.lastMessage != null)
                    .length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 56,
        width: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            context.go('/contacts');
          },
          child: SvgPicture.asset(
            'assets/icons/add_chat.svg',
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
