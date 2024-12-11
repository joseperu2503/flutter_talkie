class VerifyCodeResponse {
  final bool success;
  final String message;

  VerifyCodeResponse({
    required this.success,
    required this.message,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      VerifyCodeResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
