import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/controllers/theme_controller.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_button.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_checkbox.dart';
import 'package:flutter_talkie/app/shared/widgets/custom_text_button.dart';
import 'package:get/get.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          top: 52,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Obx(
          () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a theme',
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
                CustomCheckbox(
                  isSelected:
                      themeController.themeMode.value == ThemeMode.light,
                  onPress: () {
                    themeController.changeTheme(ThemeMode.light);
                  },
                  label: 'Light',
                ),
                const Height(16),
                CustomCheckbox(
                  isSelected: themeController.themeMode.value == ThemeMode.dark,
                  onPress: () {
                    themeController.changeTheme(ThemeMode.dark);
                  },
                  label: 'Dark',
                ),
                const Height(16),
                CustomCheckbox(
                  isSelected:
                      themeController.themeMode.value == ThemeMode.system,
                  onPress: () {
                    themeController.changeTheme(ThemeMode.system);
                  },
                  label: 'System',
                ),
                const Height(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomTextButton(
                      width: 100,
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Width(12),
                    CustomButton(
                      width: 100,
                      text: 'Ok',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
