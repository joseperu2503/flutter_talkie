import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/register_controller.dart';
import 'package:flutter_talkie/app/shared/widgets/back_button.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  final registerController = Get.put(RegisterController());

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hello! Register to get\nstarted',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 30 / 24,
                        color: context.isDarkMode
                            ? AppColors.neutralOffWhite
                            : AppColors.neutralActive,
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Username',
                        hintText: 'Your username',
                        value: registerController.username.value,
                        onChanged: (value) {
                          registerController.changeUsername(value);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Name',
                        hintText: 'Your name',
                        value: registerController.name.value,
                        onChanged: (value) {
                          registerController.changeName(value);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Surname',
                        hintText: 'Your surname',
                        value: registerController.surname.value,
                        onChanged: (value) {
                          registerController.changeSurname(value);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Email',
                        hintText: 'Your email',
                        value: registerController.email.value,
                        onChanged: (value) {
                          registerController.changeEmail(value);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Phone',
                        hintText: 'Your phone',
                        value: registerController.phone.value,
                        onChanged: (value) {
                          registerController.changePhone(value);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Obx(
                      () => CustomTextField(
                        label: 'Password',
                        hintText: 'Password',
                        value: registerController.password.value,
                        onChanged: (value) {
                          registerController.changePassword(value);
                        },
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        onFieldSubmitted: (value) {
                          registerController.register();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomElevatedButton(
                      text: 'Register',
                      onPressed: () {
                        registerController.register();
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
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
                            context.pop();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Text(
                            ' Login Now',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: context.isDarkMode
                                  ? AppColors.brandColorDarkMode
                                  : AppColors.brandColorDefault,
                              height: 24 / 14,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                      ],
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
