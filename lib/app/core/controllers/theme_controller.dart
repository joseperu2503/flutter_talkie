import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkie/app/core/core.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  Future<void> changeTheme(ThemeMode theme) async {
    await StorageService.set<String>('theme', theme.toString());
    themeMode.value = theme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            theme == ThemeMode.dark ? AppColors.neutralActive : AppColors.white,
      ),
    );
    Get.changeThemeMode(themeMode.value);
  }

  Future<void> getThemeModeFromStorage() async {
    final storedTheme = await StorageService.get<String>('theme');

    ThemeMode theme;
    if (storedTheme == 'ThemeMode.dark') {
      theme = ThemeMode.dark;
    } else if (storedTheme == 'ThemeMode.light') {
      theme = ThemeMode.light;
    } else {
      theme = ThemeMode.system;
    }

    await changeTheme(theme);
  }
}
