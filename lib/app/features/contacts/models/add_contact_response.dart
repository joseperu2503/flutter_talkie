class AddContactResponse {
  String message;

  AddContactResponse({
    required this.message,
  });

  factory AddContactResponse.fromJson(Map<String, dynamic> json) =>
      AddContactResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
