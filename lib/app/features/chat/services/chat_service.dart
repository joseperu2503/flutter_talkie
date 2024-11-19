import 'package:dio/dio.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/shared/services/camera_service.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    try {
      final response = await Api.get('/chats');

      return List<Chat>.from(response.data.map((x) => Chat.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while load chats', e);
    }
  }

  static Future<void> sendFile({
    required CustomFile file,
    required String chatId,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          file.bytes,
          filename: file.name,
        ),
        'chatId': chatId,
      });

      await Api.post('/chats/send/file', data: data);
    } catch (e) {
      throw ServiceException('An error occurred while upload photo.', e);
    }
  }

  static Future<void> sendMessage({
    required String content,
    required String chatId,
  }) async {
    try {
      Map<String, dynamic> form = {
        'content': content,
        'chatId': chatId,
      };

      await Api.post('/chats/send/message', data: form);
    } catch (e) {
      throw ServiceException('An error occurred while send message.', e);
    }
  }

  static Future<List<Message>> getMessages(
    String chatId,
    String? lastMessageId,
  ) async {
    try {
      Map<String, dynamic> queryParameters = {
        "lastMessageId": lastMessageId,
      };
      final response = await Api.get(
        '/chats/$chatId/messages',
        queryParameters: queryParameters,
      );

      return List<Message>.from(response.data.map((x) => Message.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while load messages', e);
    }
  }
}
