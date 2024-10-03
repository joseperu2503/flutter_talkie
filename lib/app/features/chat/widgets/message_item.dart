import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 8,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: message.isSender ? AppColors.primary : AppColors.gray2,
            borderRadius: BorderRadius.only(
              topLeft: message.isSender
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
              topRight: const Radius.circular(16),
              bottomLeft: const Radius.circular(16),
              bottomRight: message.isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: message.isSender ? AppColors.white : AppColors.white,
              height: 22 / 16,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
      ],
    );
  }
}
