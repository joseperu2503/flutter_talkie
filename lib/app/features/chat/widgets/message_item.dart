import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:talkie/app/shared/layouts/internal_layout.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

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

  final _utils = EmojiPickerUtils();

  @override
  Widget build(BuildContext context) {
    final sent = widget.message.receivers.isNotEmpty;

    final delivered = sent && widget.message.receivers[0].deliveredAt != null;
    final read = sent && widget.message.receivers[0].readAt != null;

    super.build(context);
    return Row(
      mainAxisAlignment: widget.message.isSender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              constraints: BoxConstraints(
                maxWidth: Breakpoints.isMdDown(context)
                    ? MediaQuery.of(context).size.width * 0.7
                    : leftWidth * 0.7,
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
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  topRight: const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: widget.message.isSender
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: widget.message.isSender
                                  ? AppColors.white
                                  : context.isDarkMode
                                      ? AppColors.neutralOffWhite
                                      : AppColors.neutralActive,
                              height: 20 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            children: _utils.setEmojiTextStyle(
                              widget.message.content!,
                              emojiStyle: DefaultEmojiTextStyle.copyWith(
                                fontFamily: 'NotoColorEmoji',
                                fontSize: 20,
                                height: 24 / 20,
                              ),
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: SizedBox(
                              width: widget.message.isSender ? 60 : 45,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              right: 10,
              child: Row(
                children: [
                  Text(
                    DateFormat('HH:mm').format(widget.message.sentAt.toLocal()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: widget.message.isSender
                          ? AppColors.neutralOffWhite
                          : AppColors.neutralDisabled,
                      height: 1.2,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  if (widget.message.isSender)
                    Row(
                      children: [
                        const Width(4),
                        if (!delivered && !read)
                          Icon(
                            sent ? Icons.check : Icons.schedule,
                            size: 14,
                            color: widget.message.isSender
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralDisabled,
                          ),
                        if (delivered || read)
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: read
                                ? AppColors.accentSuccess
                                : AppColors.neutralOffWhite,
                          ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
