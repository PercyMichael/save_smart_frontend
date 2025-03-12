import 'package:flutter/material.dart';
import 'constants.dart';

class ThemeHelper {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      surface: AppColors.backgroundColor,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardTheme: CardTheme(
      color: AppColors.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textLightColor,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        ),
        minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        ),
        minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
    ),
  );
}