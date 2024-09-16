import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/message_received.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocket {
  late io.Socket socket;
  final void Function(MessagesReceived messageReceived) onMessageReceived;

  ChatSocket({
    required this.onMessageReceived,
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
      print('messageReceived $data');
      MessagesReceived messageReceived = MessagesReceived.fromJson(data);
      onMessageReceived(messageReceived);
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

  sendMessage({
    required String content,
    required int recipientId,
  }) {
    //** Emitir */

    Map<String, dynamic> data = {
      "content": content,
      "recipientId": recipientId,
    };

    socket.emit('sendMessage', data);
  }

  void disconnect() {
    socket.disconnect();
  }
}
