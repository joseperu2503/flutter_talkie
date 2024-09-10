import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
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

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Spacer(),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 250,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Obx(
                    () => CustomTextField(
                      label: 'Email',
                      hintText: 'Your email',
                      value: authController.email.value,
                      onChanged: (value) {
                        authController.changeEmail(value);
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
                      value: authController.password.value,
                      onChanged: (value) {
                        authController.changePassword(value);
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      onFieldSubmitted: (value) {
                        authController.login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomButton(
                    text: 'Log In',
                    onPressed: () {
                      authController.login();
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
