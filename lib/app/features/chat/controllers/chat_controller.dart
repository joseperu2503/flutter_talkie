import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/services/chat_service.dart';
import 'package:talkie/app/features/chat/sockets/chat_socket.dart';
import 'package:talkie/app/shared/enums/loading_status.dart';
import 'package:talkie/app/shared/services/camera_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  RxList<Chat> chats = <Chat>[].obs;
  Rx<Map<String, List<Message>>> messages = Rx<Map<String, List<Message>>>({});

  getChats() async {
    loading.value = LoadingStatus.loading;
    try {
      chats.value = await ChatService.getChats();

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  ChatSocket? socket;

  connectSocket() async {
    disconnectSocket();
    final (validToken, _) = await AuthService.verifyToken();

    if (!validToken) return;
    socket = ChatSocket(
      onMessageReceived: (messageReceived) {
        addMessageToChat(messageReceived.message);
      },
      onChatUpdated: (chat) {
        updateChat(chat);
      },
      onContactUpdated: (contact) {
        updatedContat(contact);
      },
    );

    await socket?.connect();
  }

  addMessageToChat(Message message) {
    // Obtener el último mensaje almacenado en el mapa de mensajes.
    final existingMessages = messages.value[message.chatId] ?? [];

    // Combinar los mensajes existentes con los nuevos.
    final updatedMessages = [
      message,
      ...existingMessages,
    ];

    // Actualizar el mapa de mensajes.
    messages.value = {
      ...messages.value,
      message.chatId: updatedMessages,
    };
  }

  void updateChat(Chat chat) {
    chats.value = chats.map((c) {
      if (c.id == chat.id) {
        return chat;
      }
      return c;
    }).toList();
  }

  void updatedContat(Contact contact) {
    Chat? chatToUpdate = chats.firstWhereOrNull(
      (chat) => chat.receiver.id == contact.id,
    );

    if (chatToUpdate == null) return;
    chatToUpdate.receiver = contact;

    chats.value = chats.map((chat) {
      if (chat.id == contact.chatId) {
        chat.receiver = contact;
      }
      return chat;
    }).toList();

    chats.refresh();
  }

  markChatAsRead(String chatId) {
    socket?.markChatAsRead(
      chatId: chatId,
    );
  }

  sendMessage(String content, String chatId) async {
    socket?.sendMessage(
      content: content,
      chatId: chatId,
    );
  }

  disconnectSocket() {
    socket?.disconnect();
  }

  sendImage(String chatId) async {
    final path = await CameraService.takePhoto();

    if (path == null) return;

    try {
      await ChatService.uploadPhoto(file: path, chatId: chatId);
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  getMessages(String chatId) async {
    try {
      // Obtener el último mensaje almacenado en el mapa de mensajes.
      final existingMessages = messages.value[chatId] ?? [];
      String? lastMessageId =
          existingMessages.isNotEmpty ? existingMessages.last.id : null;

      // Obtener los nuevos mensajes desde el servicio.
      final newMessages = await ChatService.getMessages(chatId, lastMessageId);

      // Combinar los mensajes existentes con los nuevos.
      final updatedMessages = [...existingMessages, ...newMessages];

      // Actualizar el mapa de mensajes.
      messages.value = {
        ...messages.value,
        chatId: updatedMessages,
      };
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
