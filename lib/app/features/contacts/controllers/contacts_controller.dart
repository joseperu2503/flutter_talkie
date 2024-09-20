import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/models/contact.dart';
import 'package:flutter_talkie/app/features/contacts/services/contacts_service.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  RxList<Contact> contacts = <Contact>[].obs;

  getContacts() async {
    loading.value = LoadingStatus.loading;
    try {
      contacts.value = await ContactsService.getContacts();
      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackBarService.show(e.message);
    }
  }
}
