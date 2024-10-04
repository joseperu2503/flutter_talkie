import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/widgets/message_item.dart';
import 'package:flutter_talkie/app/shared/widgets/back_button.dart';
import 'package:get/get.dart';

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
  }

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
      backgroundColor: AppColors.neutralOffWhite,
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

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 16,
                ),
                height: 64,
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        '${chat.receiver.name} ${chat.receiver.surname}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutralActive,
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
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 54 + 8 + 8 + screen.padding.bottom,
                ),
                sliver: SliverList.builder(
                  itemBuilder: (context, index) {
                    final message = chat.messages[index];
                    return MessageItem(
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
      bottomSheet: Container(
        color: AppColors.neutralOffWhite,
        child: Container(
          padding: EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
            bottom: 8 + screen.padding.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x101B4F26),
                  offset: Offset(0, 15),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
              ],
            ),
            height: 54,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(
                      color: AppColors.blue2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 22 / 14,
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
                        color: AppColors.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 22 / 16,
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 40,
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      isCollapsed: true,
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
                            ? AppColors.gray
                            : AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
