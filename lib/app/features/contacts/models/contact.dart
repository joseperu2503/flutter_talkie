// ignore_for_file: public_member_api_docs, sort_constructors_first
class Contact {
  String name;
  String surname;
  DateTime lastConected;
  String? photo;
  bool isOnline;

  Contact({
    required this.name,
    required this.surname,
    required this.lastConected,
    this.photo,
    required this.isOnline,
  });
}
