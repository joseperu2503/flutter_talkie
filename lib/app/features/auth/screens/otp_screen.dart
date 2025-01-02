import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/controllers/register_controller.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:pinput/pinput.dart';
import 'package:talkie/app/shared/widgets/custom_text_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _loginController = Get.find<LoginController>();
  final _registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: TextStyle(
        fontSize: 32,
        height: 1,
        color: context.isDarkMode
            ? AppColors.neutralOffWhite
            : AppColors.neutralActive,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: context.isDarkMode
            ? AppColors.neutralDark
            : AppColors.neutralOffWhite,
      ),
      padding: const EdgeInsets.only(bottom: 16, top: 16),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.brandColorDefault),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: context.isDarkMode
            ? AppColors.neutralDark
            : AppColors.neutralOffWhite,
      ),
    );

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
                  top: 4,
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
                      'Enter Code',
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
                        child: Obx(
                          () => Text(
                            _loginController.authMethod.value ==
                                    AuthMethod.email
                                ? 'We have sent you an email with the code to ${_loginController.form.control('email').value}'
                                : 'We have sent you an SMS with the code to ${_loginController.country.value?.dialCode} ${_loginController.form.control('phone').value}',
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
                    Pinput(
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      controller: _registerController.otp,
                      onCompleted: (pin) {
                        _registerController.verifyCode();
                      },
                      autofocus: true,
                    ),
                    const Height(81),
                    CustomTextButton(
                      text: 'Resend code',
                      onPressed: () {
                        _registerController.sendVerificationCode();
                      },
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandColorDefault,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    SizedBox(
                      height: 80 + screen.padding.bottom,
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
