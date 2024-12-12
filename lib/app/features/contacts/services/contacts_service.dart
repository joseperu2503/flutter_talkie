import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/contacts/models/add_contact_response.dart';

class ContactsService {
  static Future<AddContactResponse> addContact({
    required String? email,
    required PhoneRequest? phone,
    required AuthMethod type,
  }) async {
    try {
      Map<String, dynamic> form = {
        "phone": phone?.toJson(),
        "email": email,
        "type": type.toString().split('.').last,
      };

      final response = await Api.post('/contacts', data: form);

      return AddContactResponse.fromJson(response.data);
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
