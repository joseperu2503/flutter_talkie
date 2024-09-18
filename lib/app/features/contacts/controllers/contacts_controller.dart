import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/models/contact.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  RxList<Contact> contacts = <Contact>[].obs;

  getContacts() async {
    loading.value = LoadingStatus.loading;
    try {
      Future.delayed(const Duration(milliseconds: 500));

      contacts.value = [
        Contact(
          name: 'Athalia',
          surname: 'Putri',
          lastConected: DateTime(2024, 09, 16),
          photo: 'https://randomuser.me/api/portraits/women/1.jpg',
          isOnline: false,
        ),
        Contact(
          name: 'Erlan',
          surname: 'Sadewa',
          lastConected: DateTime(2024, 09, 16),
          photo: 'https://randomuser.me/api/portraits/women/2.jpg',
          isOnline: false,
        ),
        Contact(
          name: 'Midala',
          surname: 'Sadewa',
          lastConected: DateTime(2024, 09, 16),
          photo: 'https://randomuser.me/api/portraits/women/3.jpg',
          isOnline: false,
        ),
        Contact(
          name: 'Nafisa',
          surname: 'Sadewa',
          lastConected: DateTime(2024, 09, 16),
          photo: null,
          isOnline: true,
        ),
        Contact(
          name: 'Salsabila',
          surname: 'Akira',
          lastConected: DateTime(2024, 09, 16),
          photo: 'https://randomuser.me/api/portraits/women/4.jpg',
          isOnline: true,
        ),
      ];

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackBarService.show(e.message);
    }
  }
}
