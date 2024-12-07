class PhoneRequest {
  final String number;
  final int countryId;

  PhoneRequest({
    required this.number,
    required this.countryId,
  });

  factory PhoneRequest.fromJson(Map<String, dynamic> json) => PhoneRequest(
        number: json["number"],
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "countryId": countryId,
      };
}
