class SendVerificationCodeResponse {
  final bool success;
  final String message;
  final Data data;

  SendVerificationCodeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendVerificationCodeResponse.fromJson(Map<String, dynamic> json) =>
      SendVerificationCodeResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String verificationCodeId;

  Data({
    required this.verificationCodeId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        verificationCodeId: json["verificationCodeId"],
      );

  Map<String, dynamic> toJson() => {
        "verificationCodeId": verificationCodeId,
      };
}
