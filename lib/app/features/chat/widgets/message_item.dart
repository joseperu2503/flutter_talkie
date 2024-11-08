import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      mainAxisAlignment: widget.message.isSender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 8,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: widget.message.isSender
                ? context.isDarkMode
                    ? AppColors.brandColorDarkMode
                    : AppColors.brandColorDarkMode
                : context.isDarkMode
                    ? AppColors.neutralActive
                    : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: widget.message.isSender
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
              topRight: const Radius.circular(16),
              bottomLeft: const Radius.circular(16),
              bottomRight: widget.message.isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: widget.message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (widget.message.isImage && widget.message.fileUrl != null)
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.fileUrl!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              if (widget.message.content != null)
                Text(
                  widget.message.content!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: widget.message.isSender
                        ? AppColors.white
                        : context.isDarkMode
                            ? AppColors.neutralOffWhite
                            : AppColors.neutralActive,
                    height: 24 / 14,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              const Height(4),
              Text(
                DateFormat('HH:mm').format(widget.message.timestamp.toLocal()),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: widget.message.isSender
                      ? AppColors.white
                      : AppColors.neutralDisabled,
                  height: 16 / 10,
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
