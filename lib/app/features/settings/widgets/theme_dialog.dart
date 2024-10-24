import 'package:flutter/material.dart';
import 'package:talkie/app/core/controllers/theme_controller.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/shared/widgets/custom_elevated_button.dart';
import 'package:talkie/app/shared/widgets/custom_checkbox.dart';
import 'package:talkie/app/shared/widgets/custom_text_button.dart';
import 'package:get/get.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({super.key});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  late ThemeMode themeMode;

  @override
  void initState() {
    final themeController = Get.find<ThemeController>();
    setState(() {
      themeMode = themeController.themeMode.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(
          top: 32,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
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
              isSelected: themeMode == ThemeMode.light,
              onPress: () {
                setState(() {
                  themeMode = ThemeMode.light;
                });
              },
              label: 'Light',
            ),
            const Height(32),
            CustomCheckbox(
              isSelected: themeMode == ThemeMode.dark,
              onPress: () {
                setState(() {
                  themeMode = ThemeMode.dark;
                });
              },
              label: 'Dark',
            ),
            const Height(24),
            CustomCheckbox(
              isSelected: themeMode == ThemeMode.system,
              onPress: () {
                setState(() {
                  themeMode = ThemeMode.system;
                });
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
                CustomElevatedButton(
                  width: 100,
                  text: 'Ok',
                  onPressed: () {
                    themeController.changeTheme(themeMode);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
