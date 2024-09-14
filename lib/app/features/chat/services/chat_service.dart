import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/chat/models/chat.dart';
import 'package:flutter_talkie/app/features/chat/models/messages_response.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    try {
      final response = await Api.get('/chats');

      return List<Chat>.from(response.data.map((x) => Chat.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }

  static Future<MessagesResponse> getMessagesByChat({
    required int chatId,
  }) async {
    try {
      final response = await Api.get('/chats/$chatId/messages');

      return MessagesResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
