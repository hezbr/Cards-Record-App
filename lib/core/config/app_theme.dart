import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppThemeMode {
  Light, // الثيم الفاتح
  Dark, // الثيم الداكن
  Phone, // وضع الهاتف
}

class AppThemeController extends GetxController {
  void changeThemeMode(AppThemeMode themeMode) {}
}

class AppThemeAndColors {
  static final primaryColor = const Color(0xffAD7BE9);
  static final canvasColor = const Color(0xffEEEEEE);
  // static final colorScheme = ColorScheme.fromSwatch().copyWith(
  //   primary: const Color(0xffAD7BE9),
  //   // primary: Colors.blue,
  //   secondary: const Color(0xffdfe7fd),
  //   // background: const Color(0xffeae4e9),
  // )
  static final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xffAD7BE9),
    primary: const Color(0xffAD7BE9),
    // primary: Colors.blue,
    secondary: const Color(0xffdfe7fd),
    background: const Color(0xffEEEEEE),
  );

  static final textTheme = const TextTheme(
    // theme for label in buttons
    titleLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 14), // لم استخدمه باي مكان
    bodyMedium: TextStyle(fontSize: 13),
    // خصائص النص داخل كل زر
    labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
  );

  static final appBarTheme = const AppBarTheme(elevation: 10
      // backgroundColor: Color(0xffAD7BE9),
      // foregroundColor: Color(0xffEEEEEE),
      );

  static final bottomNavigationBarTheme = const BottomNavigationBarThemeData(
    elevation: 15,
    // selectedItemColor: Get.theme.primaryColor,
    // unselectedItemColor: Get.theme.primaryColor.withAlpha(200),
    // showSelectedLabels: true,
  );

  static final cardTheme = CardTheme().copyWith(
    color: const Color(0xffeae4e9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 4,
  );

  static final floatingButtonTheme= FloatingActionButtonThemeData().copyWith(
    backgroundColor: ButtonStyle().backgroundColor?.resolve({}),
  );

  static final ar_lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppThemeAndColors.primaryColor,
    colorScheme: AppThemeAndColors.colorScheme,
    fontFamily: 'Al-Jazeera',
    textTheme: AppThemeAndColors.textTheme,
    appBarTheme: AppThemeAndColors.appBarTheme,
    bottomNavigationBarTheme: AppThemeAndColors.bottomNavigationBarTheme,
    cardTheme: AppThemeAndColors.cardTheme,
    floatingActionButtonTheme: AppThemeAndColors.floatingButtonTheme,
  );

  static final en_lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppThemeAndColors.primaryColor,
    colorScheme: AppThemeAndColors.colorScheme,
    fontFamily: 'Roboto',
    textTheme: AppThemeAndColors.textTheme,
    appBarTheme: AppThemeAndColors.appBarTheme,
    bottomNavigationBarTheme: AppThemeAndColors.bottomNavigationBarTheme,
    cardTheme: AppThemeAndColors.cardTheme,
    floatingActionButtonTheme: AppThemeAndColors.floatingButtonTheme,
  );
}
