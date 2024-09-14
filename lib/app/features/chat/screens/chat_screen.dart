import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });

  final int chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final chatController = Get.find<ChatController>();
    chatController.getMessagesByChat(widget.chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Obx(() {
          final Chat? chat = chatController.chats
              .firstWhereOrNull((chat) => chat.id == widget.chatId);

          if (chat == null) {
            return Container();
          }

          return CustomScrollView(
            slivers: [
              SliverList.builder(
                itemBuilder: (context, index) {
                  final message = chat.messages[index];
                  return Text(message.content);
                },
                itemCount: chat.messages.length,
              )
            ],
          );
        }));
  }
}
