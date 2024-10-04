import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/screens/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: chat.id,
            ),
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 56,
        child: Row(
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
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.receiver.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralActive,
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
                  const SizedBox(
                    height: 2,
                  ),
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
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandColorBackground,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandColorDark,
                            height: 10 / 10,
                            leadingDistribution: TextLeadingDistribution.even,
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
