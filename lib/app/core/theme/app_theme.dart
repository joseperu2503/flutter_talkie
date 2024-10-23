import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Mulish',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
      ),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        accentColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.brandColorDefault,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      dialogBackgroundColor: AppColors.white,
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: Colors.white,
        showDragHandle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.brandColorDefault,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      fontFamily: 'Mulish',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.neutralActive,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.neutralActive,
      ),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.brandColorDarkMode,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      dialogBackgroundColor: AppColors.neutralActive,
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: Colors.white,
        showDragHandle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.neutralDisabled,
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
