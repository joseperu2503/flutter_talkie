class SendVerificationCodeResponse {
  final bool success;
  final String message;

  SendVerificationCodeResponse({
    required this.success,
    required this.message,
  });

  factory SendVerificationCodeResponse.fromJson(Map<String, dynamic> json) =>
      SendVerificationCodeResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
