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
