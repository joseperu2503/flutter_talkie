import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/login_controller.dart';
import 'package:flutter_talkie/app/shared/widgets/back_button.dart';
import 'package:get/get.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_button.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
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
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                right: 24,
                left: 24,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome back! Glad\nto see you, Again!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 30 / 24,
                      color: AppColors.neutralActive,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Obx(
                    () => CustomTextField(
                      label: 'Email',
                      hintText: 'Your email',
                      value: loginController.email.value,
                      onChanged: (value) {
                        loginController.changeEmail(value);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Obx(
                    () => CustomTextField(
                      label: 'Password',
                      hintText: 'Password',
                      value: loginController.password.value,
                      onChanged: (value) {
                        loginController.changePassword(value);
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      onFieldSubmitted: (value) {
                        loginController.login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    text: 'Log In',
                    onPressed: () {
                      loginController.login();
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.neutralActive,
                          height: 24 / 14,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.translucent,
                        child: const Text(
                          ' Register Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.brandColorDefault,
                            height: 24 / 14,
                            leadingDistribution: TextLeadingDistribution.even,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80 + screen.padding.bottom,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
