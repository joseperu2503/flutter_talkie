import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/shared/widgets/user_image.dart';
import 'package:go_router/go_router.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: TextButton(
        onPressed: () {
          context.go('/chats/${chat.id}');
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
              UserImage(
                name: chat.receiver.name,
                surname: chat.receiver.surname,
                photo: chat.receiver.photo,
                isConnected: chat.receiver.isConnected,
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? AppColors.white
                                  : AppColors.neutralActive,
                              height: 20 / 15,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatTimestamp(chat.lastMessage?.timestamp),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutralDisabled,
                            height: 16 / 13,
                            leadingDistribution: TextLeadingDistribution.even,
                            overflow: TextOverflow.ellipsis,
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
