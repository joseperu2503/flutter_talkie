class Chat {
  final int id;
  final String name;
  final LastMessage lastMessage;
  final List<Sender> users;

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.users,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        name: json["name"],
        lastMessage: LastMessage.fromJson(json["lastMessage"]),
        users: List<Sender>.from(json["users"].map((x) => Sender.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastMessage": lastMessage.toJson(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "sender": sender.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
