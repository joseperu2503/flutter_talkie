import 'package:talkie/app/features/chat/models/chat.dart';

class MessagesReceived {
  final Message message;

  MessagesReceived({
    required this.message,
  });

  factory MessagesReceived.fromJson(Map<String, dynamic> json) =>
      MessagesReceived(
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
      };
}
