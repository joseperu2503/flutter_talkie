import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/widgets/countries_dialog.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/contacts/controllers/contacts_controller.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:talkie/app/shared/widgets/custom_text_button.dart';
import 'package:get/get.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  @override
  void initState() {
    contactsController.initDataDialog();
    super.initState();
  }

  final ContactsController contactsController = Get.find<ContactsController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          top: 52,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add by email or phone',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: context.isDarkMode
                    ? AppColors.neutralOffWhite
                    : AppColors.neutralActive,
                height: 30 / 24,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const Height(36),
            Text(
              'Who do you want to add as a contact?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: context.isDarkMode
                    ? AppColors.neutralOffWhite
                    : AppColors.neutralDark,
                height: 20 / 12,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            const Height(12),
            ReactiveForm(
              formGroup: contactsController.form,
              child: Obx(
                () {
                  if (contactsController.authMethod.value == AuthMethod.email) {
                    return const CustomTextField(
                      hintText: 'Email',
                      formControlName: 'email',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            final Country? country = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CountriesDialog();
                              },
                            );

                            if (country != null) {
                              contactsController.changeCountry(country);
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? AppColors.neutralDark
                                  : AppColors.neutralOffWhite,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 12,
                              right: 12,
                              bottom: 10,
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  ...EmojiPickerUtils().setEmojiTextStyle(
                                    contactsController.country.value?.flag ??
                                        '',
                                    emojiStyle: DefaultEmojiTextStyle.copyWith(
                                      fontFamily: 'NotoColorEmoji',
                                      fontSize: 16,
                                      height: 20 / 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '  ${contactsController.country.value?.dialCode ?? ''}',
                                    style: TextStyle(
                                      color: context.isDarkMode
                                          ? AppColors.neutralOffWhite
                                          : AppColors.neutralActive,
                                      fontSize: 14,
                                      height: 24 / 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Width(8),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Phone Number',
                          formControlName: 'phone',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            contactsController.phoneFormatter.value,
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Height(32),
            CustomElevatedButton(
              text: 'Send Friend Request',
              onPressed: () {
                contactsController.addContact();
              },
            ),
            const Height(40),
            Obx(
              () => CustomTextButton(
                text: contactsController.authMethod.value == AuthMethod.email
                    ? 'Or continue with phone'
                    : 'Or continue with email',
                onPressed: () {
                  contactsController.toggleAuthMethod();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
