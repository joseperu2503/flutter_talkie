import 'package:flutter/material.dart';
import 'package:talkie/app/features/auth/components/countries_dialog.dart';
import 'package:talkie/app/shared/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
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
    super.initState();
  }

  final loginController = Get.put(LoginController());

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
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const CountriesDialog();
                          },
                        );
                      },
                      child: Obx(
                        () => CustomTextField(
                          hintText: 'Email',
                          value: loginController.email.value,
                          onChanged: (value) {
                            loginController.changeEmail(value);
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                        ),
                      ),
                    ),
                    const Height(18),
                    Obx(
                      () => CustomTextField(
                        hintText: 'Password',
                        value: loginController.password.value,
                        onChanged: (value) {
                          loginController.changePassword(value);
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        isPassword: true,
                        onFieldSubmitted: (value) {
                          loginController.login();
                        },
                      ),
                    ),
                    const Height(40),
                    CustomElevatedButton(
                      text: 'Log In',
                      onPressed: () {
                        loginController.login();
                      },
                    ),
                    const Spacer(),
                    const Height(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.isDarkMode
                                ? AppColors.neutralOffWhite
                                : AppColors.neutralActive,
                            height: 24 / 14,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/register');
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Text(
                            ' Register Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.isDarkMode
                                  ? AppColors.brandColorDarkMode2
                                  : AppColors.brandColorDefault,
                              height: 24 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                      ],
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
