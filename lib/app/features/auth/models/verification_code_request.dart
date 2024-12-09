class VerificationCodeRequest {
  final String id;
  final String code;

  VerificationCodeRequest({
    required this.id,
    required this.code,
  });

  factory VerificationCodeRequest.fromJson(Map<String, dynamic> json) =>
      VerificationCodeRequest(
        id: json["id"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
      };
}
