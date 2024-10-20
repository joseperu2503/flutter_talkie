class AuthUser {
  final int id;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String? photo;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
    required this.photo,
  });

  String get fullName => '$name $surname';

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        surname: json["surname"],
        phone: json["phone"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "surname": surname,
        "phone": phone,
        "photo": photo,
      };
}
