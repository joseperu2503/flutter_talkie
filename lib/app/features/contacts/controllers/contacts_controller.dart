import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/services/contacts_service.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/plugins/formx/formx.dart';
import 'package:flutter_talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  Rx<FormxInput<String>> username = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>()],
  ).obs;

  resetUsername() {
    username.value = username.value.updateValue('').unTouch();
  }

  changeUsername(FormxInput<String> value) {
    username.value = value;
  }

  Rx<FormxInput<String>> search = const FormxInput<String>(
    value: '',
  ).obs;

  changeSearch(FormxInput<String> value) {
    search.value = value;
  }

  addContact() async {
    FocusManager.instance.primaryFocus?.unfocus();

    loading.value = LoadingStatus.loading;
    try {
      final response = await ContactsService.addContact(username.value.value);
      loading.value = LoadingStatus.success;
      SnackbarService.show(response.message, type: SnackbarType.success);
      appRouter.pop();
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
