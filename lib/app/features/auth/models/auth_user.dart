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

class Country {
  final int id;
  final String name;
  final String flag;
  final String code;
  final String dialCode;
  final String mask;

  Country({
    required this.id,
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.mask,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        flag: json["flag"],
        code: json["code"],
        dialCode: json["dialCode"],
        mask: json["mask"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "flag": flag,
        "code": code,
        "dialCode": dialCode,
        "mask": mask,
      };
}
