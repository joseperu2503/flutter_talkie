import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/screens/chat_screen.dart';

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
                const SizedBox(
                  height: 2,
                ),
                Text(
                  chat.lastMessage?.content ?? '',
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
    );
  }
}
