import 'package:flutter_talkie/app/features/chat/models/messages_response.dart';

class Chat {
  int id;
  String name;
  LastMessage lastMessage;
  List<Sender> users;
  List<Message> messages;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.users,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        name: json["name"],
        lastMessage: LastMessage.fromJson(json["lastMessage"]),
        users: List<Sender>.from(json["users"].map((x) => Sender.fromJson(x))),
        messages: json["messages"] != null
            ? List<Message>.from(json["users"].map((x) => Message.fromJson(x)))
            : [],
      );
}

class LastMessage {
  final int id;
  final String content;
  final DateTime timestamp;
  final Sender sender;

  LastMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
        sender: Sender.fromJson(json["sender"]),
      );
}

class Sender {
  final int id;
  final String name;

  Sender({
    required this.id,
    required this.name,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        name: json["name"],
      );
}
