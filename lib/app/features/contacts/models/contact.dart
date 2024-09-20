class Contact {
  final int id;
  final String name;
  final String surname;
  final String? photo;
  final String phone;
  final String eamil;
  final bool isOnline;
  final DateTime lastConnection;

  Contact({
    required this.id,
    required this.name,
    required this.surname,
    required this.photo,
    required this.phone,
    required this.eamil,
    required this.isOnline,
    required this.lastConnection,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        photo: json["photo"],
        phone: json["phone"],
        eamil: json["eamil"],
        isOnline: json["isOnline"],
        lastConnection: DateTime.parse(json["lastConnection"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "photo": photo,
        "phone": phone,
        "eamil": eamil,
        "isOnline": isOnline,
        "lastConnection": lastConnection.toIso8601String(),
      };
}
