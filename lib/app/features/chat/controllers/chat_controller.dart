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
  Rx<String?> chatId = Rx<String?>(null);

  setChatId(String? id) {
    chatId.value = id;
  }

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
        addMessageToChat(
          messageReceived.message,
          messageReceived.chatId,
        );
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

  addMessageToChat(Message message, String chatId) {
    final Chat? chat = chats.firstWhereOrNull((chat) => chat.id == chatId);

    if (chat == null) return;

    List<Message> messages = chat.messages;

    messages.insert(0, message);
    chat.messages = messages;

    chats.refresh();
  }

  void updateChat(Chat chat) {
    // Buscar si el chat ya existe en la lista
    final Chat? existingChat =
        chats.firstWhereOrNull((element) => element.id == chat.id);

    if (existingChat != null) {
      // Si el chat existe, eliminarlo de la lista
      chats.remove(existingChat);
    }

    // Insertar el chat al inicio de la lista
    chats.insert(0, chat);

    // Refrescar la lista de chats para notificar cambios
    chats.refresh();
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

  sendImage() async {
    final String? path = await CameraService.takePhoto();

    if (path == null) return;
    if (chatId.value == null) return;

    try {
      await ChatService.uploadPhoto(path: path, chatId: chatId.value!);
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
