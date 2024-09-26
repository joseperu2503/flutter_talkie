import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/widgets/message_item.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });

  final String? chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? internalChatId;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Obx(
        () {
          final Chat? chat = chatController.currentChat.value;

          if (chat == null) {
            return Container();
          }

          return CustomScrollView(
            reverse: true,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
      bottomNavigationBar: Container(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 54,
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
                ),
                TextButton(
                  onPressed: () {
                    chatController.sendMessage(
                      messageController.text,
                    );

                    setState(() {
                      messageController.text = '';
                    });
                  },
                  child: const Text('S'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
