import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_talkie/app/core/constants/app_colors.dart';
import 'package:flutter_talkie/app/core/constants/breakpoints.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/screens/chat_screen.dart';

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
          chatController.setChatId(chat.id);
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
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.neutralLine,
              ),
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: chat.receiver.photo != null
                        ? Image.network(
                            chat.receiver.photo!,
                            width: 48,
                            height: 48,
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            color: AppColors.primary,
                            child: Center(
                              child: Text(
                                '${chat.receiver.name[0]}${chat.receiver.surname[0]}',
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
                  ),
                  if (chat.receiver.isConnected)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentSuccess,
                          ),
                          width: 12,
                          height: 12,
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.receiver.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralActive,
                      height: 24 / 14,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  Text(
                    'Last seen ${timeago.format(chat.receiver.lastConnection)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
