import 'package:flutter_talkie/app/features/chat/models/messages_response.dart';

class MessagesReceived {
  final Message message;
  final int chatId;

  MessagesReceived({
    required this.message,
    required this.chatId,
  });

  factory MessagesReceived.fromJson(Map<String, dynamic> json) =>
      MessagesReceived(
        chatId: json["chatId"],
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "message": message.toJson(),
      };
}
