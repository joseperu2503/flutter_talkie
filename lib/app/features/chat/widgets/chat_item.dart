import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/screens/chat_screen.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return SizedBox(
      height: 72,
      child: TextButton(
        onPressed: () {
          chatController.setChatId(chat.id);
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
        child: SizedBox(
          height: 56,
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
                            color: context.isDarkMode
                                ? AppColors.brandColorDarkMode
                                : AppColors.brandColorDefault,
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
              const Width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${chat.receiver.name} ${chat.receiver.surname}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? AppColors.white
                                  : AppColors.neutralActive,
                              height: 24 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatTimestamp(chat.lastMessage?.timestamp),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutralDisabled,
                            height: 16 / 10,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ],
                    ),
                    const Height(2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage?.content ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.neutralDisabled,
                              height: 20 / 12,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Width(4),
                        if (chat.unreadMessagesCount > 0)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.brandColorBackground,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              chat.unreadMessagesCount.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandColorDark,
                                height: 10 / 10,
                                leadingDistribution:
                                    TextLeadingDistribution.even,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTimestamp(DateTime? timestamp) {
  if (timestamp == null) return '';

  // Convertir el timestamp a la hora local del dispositivo
  final localTimestamp = timestamp.toLocal();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDate =
      DateTime(localTimestamp.year, localTimestamp.month, localTimestamp.day);

  if (messageDate == today) {
    // Mostrar solo la hora si es hoy
    return DateFormat.Hm().format(localTimestamp);
  } else if (messageDate == yesterday) {
    // Mostrar "Yesterday" si es ayer
    return 'Yesterday';
  } else {
    // Mostrar la fecha en formato dd/MM/yy para días anteriores
    return DateFormat('dd/MM/yy').format(localTimestamp);
  }
}
