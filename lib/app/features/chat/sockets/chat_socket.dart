import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/chat/models/message_received.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocket {
  late io.Socket socket;
  final void Function(MessagesReceived messageReceived) onMessageReceived;
  final void Function(Chat chat) onChatUpdated;
  final void Function(Contact contact) onContactUpdated;

  ChatSocket({
    required this.onMessageReceived,
    required this.onChatUpdated,
    required this.onContactUpdated,
  });

  Future<void> connect() async {
    final token = await StorageService.get<String>(StorageKeys.token);
    //* Configuración del socket */
    socket = io.io(
      '${Environment.baseUrl}/chats',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'authorization': token})
          .setAuth({'authorization': token})
          .setQuery({'token': token})
          .build(),
    );

    //** Conectar al socket */
    socket.connect();

    //** Socket se conecta */
    socket.onConnect((_) {
      print('Connected to WebSocket ${socket.id}');
    });

    //** Escuchar Socket */
    socket.on('messageReceived', (dynamic data) {
      // print('messageReceived $data');
      MessagesReceived messageReceived = MessagesReceived.fromJson(data);
      onMessageReceived(messageReceived);
    });

    //** Escuchar Socket */
    socket.on('chatUpdated', (dynamic data) {
      Chat chatUpdated = Chat.fromJson(data);
      // print('chatUpdated ${chatUpdated.id}');

      onChatUpdated(chatUpdated);
    });

    //** Escuchar Socket */
    socket.on('contactUpdated', (dynamic data) {
      Contact contact = Contact.fromJson(data);

      // print('contactUpdated $contact');
      onContactUpdated(contact);
    });

    //** Errores de conexión */
    socket.onConnectError((data) {
      // print('Connect Error: $data');
    });

    //** Socket se desconecta */
    socket.onDisconnect((_) {
      // print('Disconnected from WebSocket');
    });
  }

  //** Emitir evento enviando un nuevo mensaje */
  sendMessage({
    required String content,
    required String chatId,
  }) {
    Map<String, dynamic> data = {
      "content": content,
      "chatId": chatId,
    };

    socket.emit('sendMessage', data);
  }

  //** Emitir evento indicando si el dispositivo está conectado */
  void updateDeviceConnectionStatus({
    required bool isConnected,
  }) {
    // print(isConnected);
    socket.emit('updateDeviceConnectionStatus', {
      'isConnected': isConnected,
    });
  }

  //** Emitir evento evento indicando que un chat fue leido*/
  markChatAsRead({
    required String chatId,
  }) {
    Map<String, dynamic> data = {
      "chatId": chatId,
    };

    socket.emit('markChatAsRead', data);
  }

  void disconnect() {
    socket.disconnect();
  }
}
