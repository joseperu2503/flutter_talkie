import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/countries_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';

class CountriesDialog extends StatefulWidget {
  const CountriesDialog({super.key});

  @override
  State<CountriesDialog> createState() => _CountriesDialogState();
}

class _CountriesDialogState extends State<CountriesDialog> {
  @override
  void initState() {
    countriesController.initData();
    countriesController.getCountries();
    super.initState();
  }

  final countriesController = Get.find<CountriesController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.only(
          top: 36,
        ),
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 500,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select a country',
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
                  const Height(16),
                  CustomTextField(
                    hintText: 'Search',
                    formControl: countriesController.search,
                  ),
                ],
              ),
            ),
            const Height(8),
            Expanded(
              child: ReactiveValueListenableBuilder(
                formControl: countriesController.search,
                builder: (context, formGroup, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    itemBuilder: (context, index) {
                      final country =
                          countriesController.filteredCountries[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 32,
                          right: 24,
                        ),
                        onTap: () {
                          context.pop(country);
                        },
                        leading: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            children: EmojiPickerUtils().setEmojiTextStyle(
                              country.flag,
                              emojiStyle: DefaultEmojiTextStyle.copyWith(
                                fontFamily: 'NotoColorEmoji',
                                fontSize: 14,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          country.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralBody,
                            height: 20 / 14,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        trailing: Text(
                          country.dialCode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralBody,
                            height: 20 / 14,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      );
                    },
                    itemCount: countriesController.filteredCountries.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
