import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/features/auth/components/countries_dialog.dart';
import 'package:talkie/app/features/auth/controllers/register_controller.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/controllers/countries_controller.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  void initState() {
    loginController.initData();
    countriesController.getCountries();
    super.initState();
  }

  final loginController = Get.put(LoginController());
  final countriesController = Get.find<CountriesController>();
  final registerController = Get.put<RegisterController>(RegisterController());

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 8,
              right: 16,
            ),
            height: 64,
            child: const Row(
              children: [
                CustomBackButton(),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 24,
                  left: 24,
                  bottom: 8,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter Your Phone Number',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 30 / 24,
                        color: context.isDarkMode
                            ? AppColors.neutralOffWhite
                            : AppColors.neutralActive,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Height(8),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 295,
                        ),
                        child: Text(
                          'Please confirm your country code and enter your phone number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 24 / 14,
                            color: context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralActive,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Height(40),
                    Row(
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
                                countriesController.changeCountry(country);
                              }
                            },
                            child: Obx(
                              () => Container(
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
                                        countriesController
                                                .country.value?.flag ??
                                            '',
                                        emojiStyle:
                                            DefaultEmojiTextStyle.copyWith(
                                          fontFamily: 'NotoColorEmoji',
                                          fontSize: 16,
                                          height: 20 / 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '  ${countriesController.country.value?.dialCode ?? ''}',
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
                        ),
                        const Width(8),
                        Expanded(
                          child: Obx(
                            () => CustomTextField(
                              hintText: 'Phone Number',
                              value: registerController.phone.value,
                              onChanged: (value) {
                                registerController.changePhone(value);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                countriesController.phoneFormatter.value,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Height(81),
                    CustomElevatedButton(
                      text: 'Continue',
                      onPressed: () {
                        loginController.login();
                      },
                    ),
                    SizedBox(
                      height: 32 + screen.padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
