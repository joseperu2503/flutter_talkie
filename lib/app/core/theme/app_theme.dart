import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme(ThemeMode themeMode) {
    return ThemeData(
      fontFamily: 'Mulish',
      brightness:
          themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: themeMode == ThemeMode.light
          ? AppColors.white
          : AppColors.neutralActive,
      appBarTheme: AppBarTheme(
        backgroundColor: themeMode == ThemeMode.light
            ? AppColors.white
            : AppColors.neutralActive,
      ),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        brightness:
            themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
        accentColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black12,
        ),
      ),
      dialogBackgroundColor: themeMode == ThemeMode.light
          ? AppColors.white
          : AppColors.neutralActive,
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: Colors.white,
        showDragHandle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeMode == ThemeMode.light
            ? AppColors.brandColorDefault
            : AppColors.neutralDisabled,
      ),
    );
  }
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  const FadeTransitionBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
