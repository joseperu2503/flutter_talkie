class VerifyAccountResponse {
  final bool success;
  final bool exists;

  VerifyAccountResponse({
    required this.success,
    required this.exists,
  });

  factory VerifyAccountResponse.fromJson(Map<String, dynamic> json) =>
      VerifyAccountResponse(
        success: json["success"],
        exists: json["exists"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "exists": exists,
      };
}
