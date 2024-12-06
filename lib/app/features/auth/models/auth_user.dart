import 'package:talkie/app/features/auth/models/country.dart';

class AuthUser {
  final int id;
  final String email;
  final String name;
  final String surname;
  final Phone phone;
  final String username;
  final String? photo;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.phone,
    required this.username,
    required this.photo,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        surname: json["surname"],
        phone: Phone.fromJson(json["phone"]),
        username: json["username"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "surname": surname,
        "phone": phone.toJson(),
        "username": username,
        "photo": photo,
      };
}

class Phone {
  final String number;
  final Country country;

  Phone({
    required this.number,
    required this.country,
  });

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        number: json["number"],
        country: Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "country": country.toJson(),
      };
}
