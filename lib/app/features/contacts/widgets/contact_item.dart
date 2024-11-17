import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:talkie/app/core/widgets/width.dart';
import 'package:talkie/app/shared/widgets/user_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:talkie/app/core/constants/app_colors.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/screens/chat_screen.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return SizedBox(
      height: 84,
      child: TextButton(
        onPressed: () {
          context.go('/chats');
          if (Breakpoints.isMdDown(context)) {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatId: chat.id,
                ),
              ),
            );
          }
        },
        style: TextButton.styleFrom(
          shape: const ContinuousRectangleBorder(),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
        ),
        child: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.isDarkMode
                    ? AppColors.neutralDark
                    : AppColors.neutralLine,
              ),
            ),
          ),
          child: Row(
            children: [
              UserImage(
                name: chat.receiver.name,
                surname: chat.receiver.surname,
                photo: chat.receiver.photo,
                isConnected: chat.receiver.isConnected,
              ),
              const Width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.receiver.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode
                          ? AppColors.white
                          : AppColors.neutralActive,
                      height: 20 / 15,
                      leadingDistribution: TextLeadingDistribution.even,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    chat.receiver.isConnected
                        ? 'Online'
                        : 'Last seen ${timeago.format(chat.receiver.lastConnection)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutralDisabled,
                      height: 20 / 13,
                      leadingDistribution: TextLeadingDistribution.even,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
