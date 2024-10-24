import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    try {
      final response = await Api.get('/chats');

      return List<Chat>.from(response.data.map((x) => Chat.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
