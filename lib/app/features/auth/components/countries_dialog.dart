import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/countries_controller.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';
import 'package:get/get.dart';

class CountriesDialog extends StatelessWidget {
  const CountriesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final CountriesController countriesController =
        Get.find<CountriesController>();

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
            Obx(
              () => CustomTextField(
                autofocus: true,
                hintText: 'Enter a username',
                value: countriesController.search.value,
                onChanged: (value) {
                  countriesController.changeSearch(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
