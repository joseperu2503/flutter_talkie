import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
            color: message.isSender
                ? context.isDarkMode
                    ? AppColors.brandColorDarkMode
                    : AppColors.brandColorDefault
                : context.isDarkMode
                    ? AppColors.neutralActive
                    : AppColors.white,
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
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: message.isSender
                      ? AppColors.neutralOffWhite
                      : context.isDarkMode
                          ? AppColors.neutralOffWhite
                          : AppColors.neutralActive,
                  height: 22 / 14,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                DateFormat('HH:mm').format(message.timestamp.toLocal()),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: message.isSender
                      ? AppColors.white
                      : AppColors.neutralDisabled,
                  height: 22 / 10,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
