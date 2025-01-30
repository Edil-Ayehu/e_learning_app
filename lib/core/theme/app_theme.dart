import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
    ),
    textTheme: AppTypography.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightDivider),
      ),
    ),
  );

  // static ThemeData darkTheme = ThemeData(
  //   useMaterial3: true,
  //   brightness: Brightness.dark,
  //   primaryColor: AppColors.primary,
  //   scaffoldBackgroundColor: AppColors.darkBackground,
  //   colorScheme: const ColorScheme.dark(
  //     primary: AppColors.primary,
  //     secondary: AppColors.secondary,
  //     error: AppColors.error,
  //     background: AppColors.darkBackground,
  //     surface: AppColors.darkSurface,
  //   ),
  //   textTheme: AppTypography.darkTextTheme,
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: AppColors.primary,
  //       foregroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //     ),
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,
  //     fillColor: AppColors.darkSurface,
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: const BorderSide(color: AppColors.darkDivider),
  //     ),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: const BorderSide(color: AppColors.darkDivider),
  //     ),
  //   ),
  // );
}
