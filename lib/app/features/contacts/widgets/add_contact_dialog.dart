import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/contacts/controllers/contacts_controller.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_text_field_2.dart';
import 'package:get/get.dart';

class AddContactDialog extends StatelessWidget {
  const AddContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactsController contactsController =
        Get.find<ContactsController>();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          top: 52,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add by username',
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
            const SizedBox(
              height: 36,
            ),
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
            const SizedBox(
              height: 12,
            ),
            Obx(
              () => CustomTextField2(
                autofocus: true,
                hintText: 'Enter a username',
                value: contactsController.username.value,
                onChanged: (value) {
                  contactsController.changeUsername(value);
                },
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Obx(
              () => CustomElevatedButton(
                text: 'Send Friend Request',
                onPressed: contactsController.username.value.isInvalid
                    ? null
                    : () {
                        contactsController.addContact();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
