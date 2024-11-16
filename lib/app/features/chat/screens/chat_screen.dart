import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/widgets/message_item.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:talkie/app/shared/widgets/user_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {});
    });
    chatController.markChatAsRead(widget.chatId);

    chatController.getMessages(widget.chatId);

    _scrollController.addListener(_onScroll);
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      chatController.getMessages(widget.chatId);
    }
  }

  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: context.isDarkMode
          ? AppColors.neutralDark
          : AppColors.neutralOffWhite,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        flexibleSpace: Obx(
          () {
            final Chat? chat = chatController.chats
                .firstWhereOrNull((chat) => chat.id == widget.chatId);

            if (chat == null) {
              return Container();
            }

            final unreadMessagesCount = chat.unreadMessagesCount;

            // Detectar cuando unreadMessagesCount aumenta
            if (unreadMessagesCount > 0) {
              chatController.markChatAsRead(widget.chatId);
            }

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 16,
                ),
                height: 64,
                child: Row(
                  children: [
                    if (Breakpoints.isMdDown(context))
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: CustomBackButton(),
                      ),
                    UserImage(
                      name: chat.receiver.name,
                      surname: chat.receiver.surname,
                      photo: chat.receiver.photo,
                      size: 40,
                      isConnected: chat.receiver.isConnected,
                    ),
                    const Width(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${chat.receiver.name} ${chat.receiver.surname}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? AppColors.white
                                  : AppColors.neutralActive,
                              height: 24 / 16,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Obx(
        () {
          final Chat? chat = chatController.chats
              .firstWhereOrNull((chat) => chat.id == widget.chatId);

          if (chat == null) {
            return Container();
          }

          return CustomScrollView(
            controller: _scrollController,
            reverse: true,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                sliver: SliverList.builder(
                  itemBuilder: (context, index) {
                    final message = chat.messages[index];
                    return MessageItem(
                      key: ValueKey(message.id),
                      message: message,
                    );
                  },
                  itemCount: chat.messages.length,
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.neutralActive : AppColors.white,
          border: Border(
            top: BorderSide(
              color: context.isDarkMode
                  ? AppColors.neutralDark
                  : AppColors.neutralLine,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 12,
            right: 12,
            bottom: kIsWeb ? 16 : 8 + screen.padding.bottom,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    chatController.sendImage();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/camera.svg',
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.neutralDisabled,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? AppColors.neutralDark
                        : AppColors.neutralOffWhite,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 44,
                  child: TextFormField(
                    controller: _messageController,
                    style: TextStyle(
                      color: context.isDarkMode
                          ? AppColors.neutralOffWhite
                          : AppColors.neutralActive,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 24 / 14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText: 'Message',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        height: 24 / 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralDisabled,
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                        left: 12,
                        right: 12,
                        bottom: 10,
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      if (_messageController.text.trim().isEmpty) return;
                      chatController.sendMessage(
                        _messageController.text.trim(),
                        widget.chatId,
                      );

                      setState(() {
                        _messageController.clear();
                      });
                      _focusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.send,
                    focusNode: _focusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: _messageController.text.trim().isEmpty
                      ? null
                      : () {
                          if (_messageController.text.trim().isEmpty) return;

                          chatController.sendMessage(
                            _messageController.text.trim(),
                            widget.chatId,
                          );

                          setState(() {
                            _messageController.text = '';
                          });
                        },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: SvgPicture.asset(
                    _messageController.text.trim().isEmpty
                        ? 'assets/icons/send_outlined.svg'
                        : 'assets/icons/send_solid.svg',
                    colorFilter: ColorFilter.mode(
                      _messageController.text.trim().isEmpty
                          ? AppColors.neutralDisabled
                          : context.isDarkMode
                              ? AppColors.brandColorDarkMode
                              : AppColors.brandColorDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
