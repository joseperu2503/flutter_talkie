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
  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {});
    });
    final chatController = Get.find<ChatController>();
    chatController.markChatAsRead(widget.chatId);
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
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
                        padding: EdgeInsets.only(right: 12),
                        child: CustomBackButton(),
                      ),
                    Expanded(
                      child: Text(
                        '${chat.receiver.name} ${chat.receiver.surname}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.isDarkMode
                              ? AppColors.white
                              : AppColors.neutralActive,
                          height: 25 / 18,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 44,
                  child: TextFormField(
                    controller: messageController,
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
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Message',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        height: 24 / 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutralDisabled,
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 15,
                        left: 20,
                        right: 20,
                        bottom: 15,
                      ),
                      isCollapsed: true,
                    ),
                    onFieldSubmitted: (value) {
                      if (messageController.text.trim().isEmpty) return;
                      chatController.sendMessage(
                        messageController.text.trim(),
                        widget.chatId,
                      );

                      setState(() {
                        messageController.clear();
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
                  onPressed: messageController.text.trim().isEmpty
                      ? null
                      : () {
                          if (messageController.text.trim().isEmpty) return;

                          chatController.sendMessage(
                            messageController.text.trim(),
                            widget.chatId,
                          );

                          setState(() {
                            messageController.text = '';
                          });
                        },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: SvgPicture.asset(
                    messageController.text.trim().isEmpty
                        ? 'assets/icons/send_outlined.svg'
                        : 'assets/icons/send_solid.svg',
                    colorFilter: ColorFilter.mode(
                      messageController.text.trim().isEmpty
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
