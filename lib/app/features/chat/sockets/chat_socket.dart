import 'package:flutter_talkie/app/core/core.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocket {
  late io.Socket socket;

  ChatSocket();

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
    socket.on('emitMessageReceived', (dynamic data) {
      print('emitMessageReceived $data');
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

  void disconnect() {
    socket.disconnect();
  }
}
