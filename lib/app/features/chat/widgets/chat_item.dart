import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/screens/chat_screen.dart';
import 'package:get/get.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return GestureDetector(
      onTap: () {
        chatController.selectCurrentChat(chat);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chat.id,
            ),
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 90,
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                'https://randomuser.me/api/portraits/women/23.jpg',
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat.receiver.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue2,
                    height: 1.2,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  chat.lastMessage?.content ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue2,
                    height: 1.2,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
