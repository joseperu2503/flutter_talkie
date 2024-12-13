import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/countries_controller.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/chat/models/chat.dart';
import 'package:talkie/app/features/contacts/services/contacts_service.dart';
import 'package:talkie/app/shared/services/ip_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ContactsController extends GetxController {
  final loginController = Get.put<LoginController>(LoginController());
  final chatController = Get.put<ChatController>(ChatController());
  final countriesController =
      Get.put<CountriesController>(CountriesController());

  RxList<Country> countries = <Country>[].obs;
  Rx<Country?> country = Rx<Country?>(null);
  Rx<AuthMethod> authMethod = AuthMethod.phone.obs;

  final form = FormGroup({
    'email': FormControl<String>(validators: [
      Validators.required,
      Validators.email,
    ]),
    'phone': FormControl<String>(validators: [Validators.required]),
  });

  initDataDialog() {
    form.patchValue({
      'email': '',
      'phone': '',
    });

    form.markAsUntouched();
    getCountries();
  }

  toggleAuthMethod() {
    authMethod.value = authMethod.value == AuthMethod.email
        ? AuthMethod.phone
        : AuthMethod.email;

    form.patchValue({
      'email': '',
      'phone': '',
    });

    form.markAsUntouched();
  }

  getCountries() async {
    try {
      await countriesController.getCountries();

      final String? countryCode = await IpService.getCountryFromIP();

      if (countryCode != null) {
        final country =
            countriesController.countries.firstWhereOrNull((Country country) {
          return country.code == countryCode;
        });

        changeCountry(country);
      }
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  addContact() async {
    FocusManager.instance.primaryFocus?.unfocus();

    form.markAllAsTouched();

    if (authMethod.value == AuthMethod.phone) {
      if (form.control('phone').invalid) return;
      if (country.value == null) return;
    }
    if (authMethod.value == AuthMethod.email) {
      if (form.control('email').invalid) return;
    }

    try {
      final response = await ContactsService.addContact(
        email: authMethod.value == AuthMethod.email
            ? form.control('email').value
            : null,
        phone: authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: form.control('phone').value,
                countryId: country.value!.id,
              )
            : null,
        type: authMethod.value,
      );
      SnackbarService.show(response.message, type: SnackbarType.success);
      rootNavigatorKey.currentContext!.pop();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  Rx<MaskInputFormatter> phoneFormatter =
      Rx<MaskInputFormatter>(MaskInputFormatter(
    mask: '#######################',
  ));

  void changeCountry(Country? newCountry) {
    country.value = newCountry;

    if (newCountry != null) {
      phoneFormatter.value = MaskInputFormatter(
        mask: newCountry.mask.replaceAll('9', '#'),
      );
    }
  }

  final search = FormControl<String>();

  List<Chat> get filteredContacts {
    final chats = [...chatController.chats];
    final String searchQuery = search.value?.trim().toLowerCase() ?? '';

    // Filtrar los chats según el nombre o apellido del receptor
    final filteredChats = chats.where((chat) {
      final receiverName = chat.receiver.name.toLowerCase();
      final receiverSurname = chat.receiver.surname.toLowerCase();
      // Retorna true si el nombre o apellido contiene el valor del buscador
      return receiverName.contains(searchQuery) ||
          receiverSurname.contains(searchQuery);
    }).toList();

    filteredChats.sort((a, b) {
      // Obtener la primera letra de cada nombre del receiver
      String initialA = a.receiver.name[0].toUpperCase();
      String initialB = b.receiver.name[0].toUpperCase();

      // Comparar las iniciales
      return initialA.compareTo(initialB);
    });

    return filteredChats;
  }
}
