import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/models/add_contact_response.dart';

class ContactsService {
  static Future<AddContactResponse> addContact(String username) async {
    try {
      Map<String, dynamic> data = {
        "username": username,
      };

      final response = await Api.post('/contacts', data: data);

      return AddContactResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
