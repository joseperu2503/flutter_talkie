import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Variable reactiva para cambiar entre temas
  Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  // Método para alternar entre temas
  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  // Guardar el estado del tema en almacenamiento local (opcional)
  // y leerlo al iniciar la app
  ThemeMode getThemeModeFromStorage() {
    // Recuperar tema almacenado localmente
    Get.changeThemeMode(ThemeMode.dark);

    return ThemeMode.light; // Valor por defecto
  }
}
