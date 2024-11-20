import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/services/chat_service.dart';
import 'package:talkie/app/features/chat/sockets/chat_socket.dart';
import 'package:talkie/app/shared/enums/loading_status.dart';
import 'package:talkie/app/shared/services/camera_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

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
      onMessageReceived: (message) {
        onMessageReceived(message);
      },
      onChatUpdated: (chat) {
        updateChat(chat);
      },
      onContactUpdated: (contact) {
        updatedContat(contact);
      },
      onMessageDelivered: (message) {
        onMessageDelivered(message);
      },
      onMessageRead: (messages) {
        onMessageRead(messages);
      },
    );

    await socket?.connect();
  }

  onMessageReceived(Message message) {
    // Obtener el último mensaje almacenado en el mapa de mensajes.
    final existingMessages = messages.value[message.chatId] ?? [];

    // Buscar si existe un mensaje con el mismo id o temporalId.
    final index = existingMessages.indexWhere((existingMessage) =>
        existingMessage.id == message.id ||
        (message.temporalId != null &&
            (existingMessage.temporalId == message.temporalId &&
                message.temporalId != null)));

    if (index != -1) {
      // Si existe, reemplazar el mensaje en la posición encontrada.
      existingMessages[index] = message;
    } else {
      // Si no existe, agregar el nuevo mensaje al inicio de la lista.
      existingMessages.insert(0, message);
    }

    // Actualizar el mapa de mensajes.
    messages.value = {
      ...messages.value,
      message.chatId: existingMessages,
    };
  }

  onMessageDelivered(Message message) {
    // Obtener el último mensaje almacenado en el mapa de mensajes.
    final existingMessages = messages.value[message.chatId] ?? [];

    // Buscar si existe un mensaje con el mismo id o temporalId.
    final index = existingMessages
        .indexWhere((existingMessage) => existingMessage.id == message.id);

    if (index != -1) {
      // Si existe, reemplazar el mensaje en la posición encontrada.
      existingMessages[index] = message;
    }

    // Actualizar el mapa de mensajes.
    messages.value = {
      ...messages.value,
      message.chatId: existingMessages,
    };
  }

  onMessageRead(Message message) {
    final String chatId = message.chatId;
    // Obtener el último mensaje almacenado en el mapa de mensajes.
    final existingMessages = messages.value[chatId] ?? [];

    // Buscar si existe un mensaje con el mismo id o temporalId.
    int index = existingMessages
        .indexWhere((existingMessage) => existingMessage.id == message.id);

    if (index != -1) {
      // Si existe, reemplazar el mensaje en la posición encontrada.
      existingMessages[index] = message;
    }

    // Actualizar el mapa de mensajes.
    messages.value = {
      ...messages.value,
      chatId: existingMessages,
    };
  }

  void updateChat(Chat chat) {
    final index = chats.indexWhere((c) => c.id == chat.id);

    if (index != -1) {
      // Si existe, actualizar el chat en la posición correspondiente
      chats[index] = chat;
    } else {
      // Si no existe, agregarlo a la lista
      chats.add(chat);
    }
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
    try {
      final String temporalId = const Uuid().v4();
      final AuthController authController = Get.find<AuthController>();
      final user = authController.user.value;
      if (user == null) return;
      final existingMessages = messages.value[chatId] ?? [];

      final Message temporalMessage = Message(
        id: temporalId,
        content: content,
        sentAt: DateTime.now(),
        sender: Sender(
          id: user.id,
          name: user.name,
          surname: user.surname,
          email: user.email,
          photo: user.photo,
        ),
        isSender: true,
        fileUrl: null,
        isImage: false,
        chatId: chatId,
        temporalId: temporalId,
        receivers: [],
      );

      // Combinar los mensajes existentes con los nuevos.
      final updatedMessages = [
        temporalMessage,
        ...existingMessages,
      ];

      // Actualizar el mapa de mensajes.
      messages.value = {
        ...messages.value,
        chatId: updatedMessages,
      };

      await ChatService.sendMessage(
        content: content,
        chatId: chatId,
        temporalId: temporalId,
      );
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  disconnectSocket() {
    socket?.disconnect();
  }

  sendImage(String chatId) async {
    final path = await CameraService.takePhoto();

    if (path == null) return;

    try {
      await ChatService.sendFile(file: path, chatId: chatId);
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
