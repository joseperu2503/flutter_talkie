class Chat {
  String id;
  Message? lastMessage;
  List<Message> messages;
  Receiver receiver;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.messages,
    required this.receiver,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        lastMessage: json["lastMessage"] == null
            ? null
            : Message.fromJson(json["lastMessage"]),
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
        receiver: Receiver.fromJson(json["receiver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastMessage": lastMessage?.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "receiver": receiver.toJson(),
      };
}

class Message {
  String id;
  String content;
  DateTime timestamp;
  Receiver sender;
  bool isSender;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    required this.isSender,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
        sender: Receiver.fromJson(json["sender"]),
        isSender: json["isSender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "sender": sender.toJson(),
        "isSender": isSender,
      };
}

class Receiver {
  int id;
  String name;
  String surname;
  String email;
  String? photo;

  Receiver({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.photo,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "photo": photo,
      };
}
