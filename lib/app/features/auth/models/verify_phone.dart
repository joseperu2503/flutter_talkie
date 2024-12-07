class VerifyPhoneResponse {
  final bool success;
  final bool exists;

  VerifyPhoneResponse({
    required this.success,
    required this.exists,
  });

  factory VerifyPhoneResponse.fromJson(Map<String, dynamic> json) =>
      VerifyPhoneResponse(
        success: json["success"],
        exists: json["exists"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "exists": exists,
      };
}
