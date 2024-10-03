class Contact {
  int id;
  String name;
  String surname;
  String? photo;
  String phone;
  String email;
  bool isOnline;
  DateTime lastConnection;
  String chatId;

  Contact({
    required this.id,
    required this.name,
    required this.surname,
    required this.photo,
    required this.phone,
    required this.email,
    required this.isOnline,
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
        isOnline: json["isOnline"],
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
        "isOnline": isOnline,
        "lastConnection": lastConnection.toIso8601String(),
        "chatId": chatId,
      };
}
