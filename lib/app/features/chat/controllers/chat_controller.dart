import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/models/messages_response.dart';
import 'package:flutter_talkie/app/features/chat/services/chat_service.dart';
import 'package:flutter_talkie/app/features/chat/sockets/chat_socket.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  RxList<Chat> chats = <Chat>[].obs;

  @override
  void onInit() {
    super.onInit();
    getChats();
  }

  getChats() async {
    loading.value = LoadingStatus.loading;
    try {
      chats.value = await ChatService.getChats();

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackBarService.show(e.message);
    }
  }

  getMessagesByChat(int chatId) async {
    print('getMessagesByChat $chatId');

    final int index = chats.indexWhere((chat) => chat.id == chatId);
    if (index < 0) {
      return;
    }

    try {
      final response = await ChatService.getMessagesByChat(chatId: chatId);
      final messages = response.items;

      chats.value = chats.map((chat) {
        if (chat.id == chatId) {
          chat.messages = messages;
        }
        return chat;
      }).toList();
    } on ServiceException catch (e) {
      SnackBarService.show(e.message);
    }
  }

  ChatSocket? socket;

  connectSocket() async {
    disconnectSocket();
    final (validToken, _) = await AuthService.verifyToken();

    if (!validToken) return;
    socket = ChatSocket(
      onMessageReceived: (messageReceived) {
        final int index =
            chats.indexWhere((chat) => chat.id == messageReceived.chatId);
        if (index < 0) {
          return;
        }

        List<Message> messages = chats[index].messages;

        messages.insert(0, messageReceived.message);
        chats[index].messages = messages;
        chats.refresh();
      },
    );

    await socket?.connect();
  }

  disconnectSocket() {
    socket?.disconnect();
  }
}
