class Chat {
  String id;
  Message? lastMessage;
  List<Message> messages;
  Contact receiver;
  int unreadMessagesCount;

  Chat({
    required this.id,
    required this.lastMessage,
    required this.messages,
    required this.receiver,
    required this.unreadMessagesCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        lastMessage: json["lastMessage"] == null
            ? null
            : Message.fromJson(json["lastMessage"]),
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
        receiver: Contact.fromJson(json["receiver"]),
        unreadMessagesCount: json["unreadMessagesCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastMessage": lastMessage?.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "receiver": receiver.toJson(),
        "unreadMessagesCount": unreadMessagesCount,
      };
}

class Message {
  String id;
  String? content;
  DateTime timestamp;
  Sender sender;
  bool isSender;
  String? fileUrl;
  bool isImage;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sender,
    required this.isSender,
    required this.fileUrl,
    required this.isImage,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
        sender: Sender.fromJson(json["sender"]),
        isSender: json["isSender"],
        fileUrl: json["fileUrl"],
        isImage: json["isImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "sender": sender.toJson(),
        "isSender": isSender,
        "fileUrl": fileUrl,
        "isImage": isImage,
      };
}

class Sender {
  int id;
  String name;
  String surname;
  String email;
  String? photo;

  Sender({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.photo,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
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

class Contact {
  int id;
  String name;
  String surname;
  String? photo;
  String phone;
  String email;
  bool isConnected;
  DateTime lastConnection;
  String chatId;

  Contact({
    required this.id,
    required this.name,
    required this.surname,
    required this.photo,
    required this.phone,
    required this.email,
    required this.isConnected,
    required this.lastConnection,
    required this.chatId,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        photo: json["photo"],
        phone: json["phone"],
        email: json["email"],
        isConnected: json["isConnected"],
        lastConnection: DateTime.parse(json["lastConnection"]),
        chatId: json["chatId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "photo": photo,
        "phone": phone,
        "email": email,
        "isConnected": isConnected,
        "lastConnection": lastConnection.toIso8601String(),
        "chatId": chatId,
      };
}
