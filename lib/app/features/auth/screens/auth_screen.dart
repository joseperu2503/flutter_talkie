import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/features/auth/components/countries_dialog.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/shared/widgets/custom_text_button.dart';
import 'package:get/get.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:talkie/app/shared/widgets/custom_text_field3.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    _loginController.initData();
    super.initState();
  }

  final _loginController = Get.find<LoginController>();

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
                    Obx(
                      () => Text(
                        _loginController.authMethod.value == AuthMethod.email
                            ? 'Enter Your Email'
                            : 'Enter Your Phone Number',
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
                    ),
                    const Height(8),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 295,
                        ),
                        child: Obx(
                          () => Text(
                            _loginController.authMethod.value ==
                                    AuthMethod.email
                                ? 'Please provide your email address to continue'
                                : 'Please provide your country code and enter your phone number to continue',
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
                    ),
                    const Height(40),
                    ReactiveForm(
                      formGroup: _loginController.form,
                      child: Column(
                        children: [
                          Obx(
                            () {
                              if (_loginController.authMethod.value ==
                                  AuthMethod.email) {
                                return const CustomTextField3(
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
                                        final Country? country =
                                            await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const CountriesDialog();
                                          },
                                        );

                                        if (country != null) {
                                          _loginController
                                              .changeCountry(country);
                                        }
                                      },
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? AppColors.neutralDark
                                              : AppColors.neutralOffWhite,
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                              ...EmojiPickerUtils()
                                                  .setEmojiTextStyle(
                                                _loginController
                                                        .country.value?.flag ??
                                                    '',
                                                emojiStyle:
                                                    DefaultEmojiTextStyle
                                                        .copyWith(
                                                  fontFamily: 'NotoColorEmoji',
                                                  fontSize: 16,
                                                  height: 20 / 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '  ${_loginController.country.value?.dialCode ?? ''}',
                                                style: TextStyle(
                                                  color: context.isDarkMode
                                                      ? AppColors
                                                          .neutralOffWhite
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
                                    child: CustomTextField3(
                                      hintText: 'Phone Number',
                                      formControlName: 'phone',
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        _loginController.phoneFormatter.value,
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Height(81),
                    CustomElevatedButton(
                      text: 'Continue',
                      onPressed: () {
                        _loginController.verifyAccount();
                      },
                    ),
                    const Spacer(),
                    const Height(40),
                    Obx(
                      () => CustomTextButton(
                        text: _loginController.authMethod.value ==
                                AuthMethod.email
                            ? 'Or continue with phone'
                            : 'Or continue with email',
                        onPressed: () {
                          _loginController.toggleAuthMethod();
                        },
                      ),
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
