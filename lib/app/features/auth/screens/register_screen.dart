import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/register_controller.dart';
import 'package:talkie/app/shared/widgets/back_button.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:talkie/app/shared/widgets/custom_text_field3.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    registerController.initData();
    super.initState();
  }

  final registerController = Get.put<RegisterController>(RegisterController());

  bool get passwordMinLength {
    final password =
        registerController.form.control('password').value as String?;
    return password != null && password.length >= 6;
  }

  bool get passwordLettersAndNumbers {
    final password =
        registerController.form.control('password').value as String?;
    final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');
    return (password != null && regex.hasMatch(password));
  }

  bool get passwordUppercaseLetter {
    final password =
        registerController.form.control('password').value as String?;
    final regex = RegExp(r'[A-Z]');
    return (password != null && regex.hasMatch(password));
  }

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
                  top: 4,
                  right: 24,
                  left: 24,
                  bottom: 8,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: ReactiveForm(
                  formGroup: registerController.form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Your Account',
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
                            'Please enter your details to create a new account. It only takes a few steps!',
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
                      const CustomTextField3(
                        hintText: 'Name',
                        formControlName: 'name',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                      const Height(18),
                      const CustomTextField3(
                        hintText: 'Surname',
                        formControlName: 'surname',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                      const Height(18),
                      const CustomTextField3(
                        hintText: 'Password',
                        formControlName: 'password',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                      const Height(18),
                      Text(
                        'The password must have:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 24 / 14,
                          color: context.isDarkMode
                              ? AppColors.neutralOffWhite
                              : AppColors.neutralActive,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      const Height(18),
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/check-circle.svg',
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      passwordMinLength
                                          ? AppColors.accentSuccess
                                          : AppColors.neutralWeak,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const Width(12),
                                  Text(
                                    'At least 6 characters',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 24 / 14,
                                      color: context.isDarkMode
                                          ? AppColors.neutralOffWhite
                                          : AppColors.neutralActive,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                              const Height(8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/check-circle.svg',
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      passwordLettersAndNumbers
                                          ? AppColors.accentSuccess
                                          : AppColors.neutralWeak,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const Width(12),
                                  Text(
                                    'Letters and numbers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 24 / 14,
                                      color: context.isDarkMode
                                          ? AppColors.neutralOffWhite
                                          : AppColors.neutralActive,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                              const Height(8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/check-circle.svg',
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                      passwordUppercaseLetter
                                          ? AppColors.accentSuccess
                                          : AppColors.neutralWeak,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const Width(12),
                                  Text(
                                    '1 uppercase letter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 24 / 14,
                                      color: context.isDarkMode
                                          ? AppColors.neutralOffWhite
                                          : AppColors.neutralActive,
                                      leadingDistribution:
                                          TextLeadingDistribution.even,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const Height(81),
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return CustomElevatedButton(
                            text: 'Register',
                            onPressed: form.valid
                                ? () {
                                    registerController.register();
                                  }
                                : null,
                          );
                        },
                      ),
                      const Height(24),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Already have an account?',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: context.isDarkMode
                      //             ? AppColors.neutralOffWhite
                      //             : AppColors.neutralActive,
                      //         height: 24 / 14,
                      //         leadingDistribution: TextLeadingDistribution.even,
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         context.pop();
                      //       },
                      //       behavior: HitTestBehavior.translucent,
                      //       child: Text(
                      //         ' Login Now',
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w600,
                      //           color: context.isDarkMode
                      //               ? AppColors.brandColorDarkMode2
                      //               : AppColors.brandColorDefault,
                      //           height: 24 / 14,
                      //           leadingDistribution: TextLeadingDistribution.even,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 80 + screen.padding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
