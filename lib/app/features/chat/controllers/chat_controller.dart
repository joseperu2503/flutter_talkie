import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/services/chat_service.dart';
import 'package:flutter_talkie/app/features/chat/sockets/chat_socket.dart';
import 'package:flutter_talkie/app/features/contacts/models/contact.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  RxList<Chat> chats = <Chat>[].obs;
  Rx<Chat?> currentChat = Rx<Chat?>(null);
  RxMap<String, List<Message>> chatMessages = <String, List<Message>>{}.obs;

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

  selectCurrentChat(Chat chat) {
    currentChat.value = chat;
  }

  createChat(Contact contact) {
    currentChat.value = Chat(
      id: 'new',
      lastMessage: null,
      receiver: Receiver(
        id: contact.id,
        name: contact.name,
        surname: contact.surname,
        email: contact.email,
      ),
      messages: [],
    );
  }

  ChatSocket? socket;

  connectSocket() async {
    disconnectSocket();
    final (validToken, _) = await AuthService.verifyToken();

    if (!validToken) return;
    socket = ChatSocket(
      onMessageReceived: (messageReceived) {
        addMessageToChat(
          messageReceived.message,
          messageReceived.chatId,
        );
      },
    );

    await socket?.connect();
  }

  addMessageToChat(Message message, String chatId) {
    final int index = chats.indexWhere((chat) => chat.id == chatId);
    if (index < 0) {
      return;
    }

    List<Message> messages = chats[index].messages;

    messages.insert(0, message);
    chats[index].messages = messages;
    chats.refresh();
  }

  sendMessage(String content) async {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;
    if (user == null) return;
    if (currentChat.value == null) return;

    socket?.sendMessage(
      content: content,
      recipientId: currentChat.value!.receiver.id,
    );

    final message = Message(
      id: const Uuid().v4(),
      content: content,
      timestamp: DateTime.now(),
      sender: Receiver(
        id: user.id,
        name: user.name,
        email: user.email,
        surname: user.surname,
      ),
      isSender: true,
    );

    currentChat.update((chat) {
      chat?.messages.insert(0, message);
      chat?.lastMessage = message;
    });

    if (currentChat.value!.id == 'new') {
      chats.insert(0, currentChat.value!);
    } else {
      final Chat? chat =
          chats.firstWhereOrNull((chat) => chat.id == currentChat.value!.id);
      if (chat != null) {
        chat.lastMessage = message;
        chats.remove(chat);
        chats.insert(0, chat);
      }
    }
  }

  disconnectSocket() {
    socket?.disconnect();
  }
}
