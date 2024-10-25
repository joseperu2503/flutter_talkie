import 'package:dio/dio.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    try {
      final response = await Api.get('/chats');

      return List<Chat>.from(response.data.map((x) => Chat.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while load chats', e);
    }
  }

  static Future<void> uploadPhoto({
    required String path,
    required String chatId,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path),
        'chatId': chatId,
      });

      await Api.post('/chats/send/file', data: data);
    } catch (e) {
      throw ServiceException('An error occurred while upload photo.', e);
    }
  }
}
