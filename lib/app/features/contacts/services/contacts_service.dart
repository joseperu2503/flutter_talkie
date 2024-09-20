import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/models/contact.dart';

class ContactsService {
  static Future<List<Contact>> getContacts() async {
    try {
      final response = await Api.get('/contacts');

      return List<Contact>.from(response.data.map((x) => Contact.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
